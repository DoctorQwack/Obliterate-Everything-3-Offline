$port = 8765
$dir = $PSScriptRoot
if (-not $dir) { $dir = Get-Location }
$dir = $dir.ToString().TrimEnd('\')

function Log-Message($msg, $color = "Gray") {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formattedMsg = "[$time] $msg"
    Write-Host $formattedMsg -ForegroundColor $color
    try {
        $logFile = Join-Path $dir "log.txt"
        Add-Content -Path $logFile -Value $formattedMsg -ErrorAction SilentlyContinue
    } catch {}
}

# Clear old log file at startup
try {
    $logFile = Join-Path $dir "log.txt"
    if (Test-Path $logFile) { Remove-Item $logFile -Force -ErrorAction SilentlyContinue }
} catch {}

Log-Message "=========================================" "Green"
Log-Message "   OE3 Offline Server Starting...        " "Green"
Log-Message "   Serving from: $dir" "Cyan"
Log-Message "   URL: http://127.0.0.1:$port/" "Cyan"
Log-Message "=========================================" "Green"

# 1. Detailed File Verification
Log-Message "Verifying folder contents..." "Gray"
$indexExists = Test-Path (Join-Path $dir "index.html")
$swfExists = Test-Path (Join-Path $dir "OE3_UPDATED.swf")
if ($indexExists) { $indexStatus = "FOUND"; $indexColor = "Green" } else { $indexStatus = "MISSING"; $indexColor = "Red" }
Log-Message "index.html check: $indexStatus" $indexColor

if ($swfExists) { $swfStatus = "FOUND"; $swfColor = "Green" } else { $swfStatus = "MISSING"; $swfColor = "Red" }
Log-Message "OE3_UPDATED.swf check: $swfStatus" $swfColor


# 2. Port Conflict Auto-Recovery Logic
Log-Message "Checking port conflict for port $port..." "Gray"
try {
    $netstat = netstat -ano | Select-String ":$port\s+" | Select-Object -First 1
    if ($netstat) {
        $parts = $netstat.Line.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
        $pidToKill = [int]$parts[-1]
        if ($pidToKill -ne $PID -and $pidToKill -gt 4) {
            Log-Message "Port $port is currently blocked by process PID $pidToKill (likely an orphaned server)." "Yellow"
            Log-Message "Attempting to release the port automatically..." "Yellow"
            Stop-Process -Id $pidToKill -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            Log-Message "Port released successfully!" "Green"
        } else {
            Log-Message "Port $port is in use by current process (PID $pidToKill). Re-using socket." "Gray"
        }
    } else {
        Log-Message "Port $port is free. No conflict detected." "Green"
    }
} catch {
    Log-Message "Error checking port conflicts: $_" "Yellow"
}

# 3. Initialize HTTP Listener (Bind to IPv4 loopback to avoid UAC/Admin check)
Log-Message "Initializing HTTP Listener..." "Gray"
$l = New-Object Net.HttpListener
$l.Prefixes.Add("http://127.0.0.1:$port/")

try {
    Log-Message "Starting listener on http://127.0.0.1:$port/..." "Gray"
    $l.Start()
    Log-Message "HTTP Server successfully started and listening." "Green"
} catch {
    Log-Message "ERROR: Could not start listener on port $port." "Red"
    Log-Message "This usually means another instance is already running or the port is blocked." "Yellow"
    Log-Message "Details: $_" "Red"
    Read-Host "Press Enter to exit..."
    exit
}

# 4. Open the browser automatically to IPv4 loopback
try {
    Log-Message "Opening default web browser to http://127.0.0.1:$port/..." "Gray"
    Start-Process "http://127.0.0.1:$port/"
    Log-Message "Browser launched successfully." "Green"
} catch {
    Log-Message "Could not open browser automatically. Please open http://127.0.0.1:$port/ manually." "Yellow"
}

Log-Message "Server is running. Keep this window open while playing!" "Gray"
Log-Message "Press Ctrl+C in this window to stop the server." "Gray"
Log-Message ""

while ($l.IsListening) {
    $res = $null
    try {
        $c = $l.GetContext()
        $req = $c.Request
        $res = $c.Response
        
        $p = $req.Url.LocalPath.TrimStart('/')
        
        if ($p -eq 'save' -and $req.HttpMethod -eq 'POST') {
            $user = $req.QueryString["user"]
            $user_safe = [regex]::Replace($user, '[^a-zA-Z0-9_\-]', '')
            if (-not $user_safe) { $user_safe = "GuestPlayer" }
            $reader = New-Object System.IO.StreamReader($req.InputStream)
            $body = $reader.ReadToEnd()
            $reader.Close()
            $saveFile = Join-Path $dir "save_$user_safe.json"
            [System.IO.File]::WriteAllText($saveFile, $body)
            $res.StatusCode = 200
            $res.ContentType = "application/json"
            $writer = New-Object System.IO.StreamWriter($res.OutputStream)
            $writer.Write('{"status":"ok"}')
            $writer.Close()
            Log-Message "Request: POST /save?user=$user_safe -> 200 OK (Saved profile)" "Green"
            $res.Close()
            continue
        }
        if ($p -eq 'load' -and $req.HttpMethod -eq 'GET') {
            $user = $req.QueryString["user"]
            $user_safe = [regex]::Replace($user, '[^a-zA-Z0-9_\-]', '')
            if (-not $user_safe) { $user_safe = "GuestPlayer" }
            $saveFile = Join-Path $dir "save_$user_safe.json"
            if (Test-Path $saveFile -PathType Leaf) {
                $body = [System.IO.File]::ReadAllText($saveFile)
                $res.StatusCode = 200
                $res.ContentType = "application/json"
                $writer = New-Object System.IO.StreamWriter($res.OutputStream)
                $writer.Write($body)
                $writer.Close()
                Log-Message "Request: GET /load?user=$user_safe -> 200 OK (Loaded profile)" "Green"
            } else {
                $res.StatusCode = 404
                $res.ContentType = "application/json"
                $writer = New-Object System.IO.StreamWriter($res.OutputStream)
                $writer.Write('{"error":"no save file"}')
                $writer.Close()
                Log-Message "Request: GET /load?user=$user_safe -> 404 Not Found (No save file)" "Yellow"
            }
            $res.Close()
            continue
        }
        if ($p -eq 'log' -and $req.HttpMethod -eq 'POST') {
            $reader = New-Object System.IO.StreamReader($req.InputStream)
            $body = $reader.ReadToEnd()
            $reader.Close()
            Log-Message "[CLIENT] $body" "Cyan"
            $res.StatusCode = 200
            $res.Close()
            continue
        }

        if ($p -eq '') { $p = 'index.html' }
        
        # Replace forward slashes with backslashes for Windows path resolution
        $p_win = $p -replace '/', '\'
        $f = Join-Path $dir $p_win
        
        $logStr = "Request: $($req.HttpMethod) /$p"
        
        if (Test-Path $f -PathType Leaf) {
            $e = [System.IO.Path]::GetExtension($f).ToLower()
            $t = switch ($e) {
                '.html' { 'text/html; charset=utf-8' }
                '.js'   { 'application/javascript; charset=utf-8' }
                '.wasm' { 'application/wasm' }
                '.swf'  { 'application/x-shockwave-flash' }
                '.css'  { 'text/css; charset=utf-8' }
                '.png'  { 'image/png' }
                '.jpg'  { 'image/jpeg' }
                '.gif'  { 'image/gif' }
                '.ico'  { 'image/x-icon' }
                default { 'application/octet-stream' }
            }
            
            $res.ContentType = $t
            
            # Using FileStream and CopyTo for memory efficiency and handling large files (WASM/SWF)
            $fs = [System.IO.File]::OpenRead($f)
            $res.ContentLength64 = $fs.Length
            
            try {
                $fs.CopyTo($res.OutputStream)
                Log-Message "$logStr -> 200 OK ($($fs.Length) bytes, $t)" "Green"
            } finally {
                $fs.Close()
            }
        } else {
            $res.StatusCode = 404
            Log-Message "$logStr -> 404 Not Found" "Yellow"
        }
        
        $res.Close()
    } catch {
        Log-Message "Request: $($req.HttpMethod) /$p -> ERROR: $_" "Red"
        # Make sure response is closed in case of exception to avoid hanging the client browser connection
        if ($null -ne $res) {
            try { $res.Close() } catch {}
        }
    }
}
