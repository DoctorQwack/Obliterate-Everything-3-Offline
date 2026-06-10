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
    $logFile = [System.IO.Path]::Combine($dir, "log.txt")
    if ([System.IO.File]::Exists($logFile)) { 
        [System.IO.File]::Delete($logFile) 
    }
} catch {}

Log-Message "=========================================" "Green"
Log-Message "   OE3 Offline Server Starting...        " "Green"
Log-Message "   Serving from: $dir" "Cyan"
Log-Message "   URL: http://127.0.0.1:$port/" "Cyan"
Log-Message "=========================================" "Green"

# 1. Detailed File Verification
Log-Message "Verifying folder contents..." "Gray"
$indexExists = $false
$swfExists = $false

try {
    $indexPath = [System.IO.Path]::Combine($dir, "index.html")
    $indexExists = [System.IO.File]::Exists($indexPath)
    if ($indexExists) { $indexStatus = "FOUND"; $indexColor = "Green" } else { $indexStatus = "MISSING"; $indexColor = "Red" }
    Log-Message "index.html check: $indexStatus" $indexColor
} catch {
    Log-Message "Error checking index.html: $_" "Red"
}

try {
    $swfPath = [System.IO.Path]::Combine($dir, "OE3_UPDATED.swf")
    $swfExists = [System.IO.File]::Exists($swfPath)
    if ($swfExists) { $swfStatus = "FOUND"; $swfColor = "Green" } else { $swfStatus = "MISSING"; $swfColor = "Red" }
    Log-Message "OE3_UPDATED.swf check: $swfStatus" $swfColor
} catch {
    Log-Message "Error checking OE3_UPDATED.swf: $_" "Red"
}



# 2. Port Conflict Auto-Recovery & HTTP Listener Initialization
$listenerStarted = $false
$maxTries = 20

for ($i = 0; $i -lt $maxTries; $i++) {
    $currentPort = $port + $i
    Log-Message "Checking port conflict for port $currentPort..." "Gray"
    
    $portInUse = $false
    try {
        $netstat = netstat -ano | Select-String ":$currentPort\s+" | Select-Object -First 1
        if ($netstat) {
            $parts = $netstat.Line.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
            $pidToKill = [int]$parts[-1]
            if ($pidToKill -ne $PID) {
                if ($pidToKill -gt 4) {
                    Log-Message "Port $currentPort is blocked by process PID $pidToKill (likely an orphaned server)." "Yellow"
                    Log-Message "Attempting to release the port automatically..." "Yellow"
                    Stop-Process -Id $pidToKill -Force -ErrorAction SilentlyContinue
                    Start-Sleep -Seconds 1
                    Log-Message "Port released successfully!" "Green"
                } else {
                    Log-Message "Port $currentPort is blocked by System/Reserved process (PID $pidToKill). Skipping..." "Yellow"
                    $portInUse = $true
                }
            }
        }
    } catch {
        Log-Message "Error checking port conflict for $currentPort - $_" "Yellow"
    }

    if ($portInUse) {
        continue
    }

    $l = New-Object Net.HttpListener
    $l.Prefixes.Add("http://127.0.0.1:$currentPort/")
    
    try {
        Log-Message "Starting listener on http://127.0.0.1:$currentPort/..." "Gray"
        $l.Start()
        $port = $currentPort
        $listenerStarted = $true
        Log-Message "HTTP Server successfully started and listening." "Green"
        break
    } catch {
        Log-Message "Failed to start listener on port $currentPort - $_" "Yellow"
        try { $l.Close() } catch {}
    }
}

if (-not $listenerStarted) {
    Log-Message "ERROR: Could not find any available port to start the HTTP listener (tried ports $port to $($port + $maxTries - 1))." "Red"
    Read-Host "Press Enter to exit..."
    exit
}

# 4. Open the game (Native Ruffle Desktop if available, otherwise Web Browser)
$ruffleExe = [System.IO.Path]::Combine($dir, "ruffle.exe")
if ([System.IO.File]::Exists($ruffleExe)) {
    try {
        Log-Message "Found native Ruffle Desktop player (ruffle.exe)." "Green"
        
        # Read Ruffle graphics backend configuration (defaults to dx12 to prevent Vulkan driver crashes)
        $backend = $env:RUFFLE_BACKEND
        if (-not $backend) { $backend = "dx12" }
        $env:WGPU_BACKEND = $backend
        
        Log-Message "Launching game natively on http://127.0.0.1:$port/OE3_UPDATED.swf using graphics backend '$backend'..." "Gray"
        Start-Process -FilePath $ruffleExe -ArgumentList "http://127.0.0.1:$port/OE3_UPDATED.swf", "-g", $backend
        Log-Message "Ruffle Desktop launched successfully." "Green"
    } catch {
        Log-Message "Failed to start Ruffle Desktop. Falling back to web browser..." "Yellow"
        try {
            Start-Process "http://127.0.0.1:$port/"
        } catch {
            Log-Message "Could not open browser. Please open http://127.0.0.1:$port/ manually." "Yellow"
        }
    }
} else {
    try {
        Log-Message "Opening default web browser to http://127.0.0.1:$port/..." "Gray"
        Start-Process "http://127.0.0.1:$port/"
        Log-Message "Browser launched successfully." "Green"
    } catch {
        Log-Message "Could not open browser automatically. Please open http://127.0.0.1:$port/ manually." "Yellow"
    }
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
                '.txt'  { 'text/plain; charset=utf-8' }
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
