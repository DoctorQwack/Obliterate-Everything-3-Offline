$port = 8765
$dir = $PSScriptRoot
if (-not $dir) { $dir = Get-Location }
$dir = $dir.ToString().TrimEnd('\')

Write-Host "=========================================" -ForegroundColor Green
Write-Host "   OE3 Offline Server Starting...        " -ForegroundColor Green
Write-Host "   Serving from: $dir" -ForegroundColor Cyan
Write-Host "   URL: http://localhost:$port/" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Green

# Port Conflict Auto-Recovery Logic
$conn = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -First 1
if ($conn) {
    $pidToKill = $conn.OwningProcess
    if ($pidToKill -ne $PID -and $pidToKill -gt 4) {
        Write-Host "Port $port is currently blocked by process PID $pidToKill (likely an orphaned server)." -ForegroundColor Yellow
        Write-Host "Attempting to release the port automatically..." -ForegroundColor Yellow
        try {
            Stop-Process -Id $pidToKill -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            Write-Host "Port released successfully!" -ForegroundColor Green
        } catch {
            Write-Host "Failed to release port automatically. You may need to close the program using it." -ForegroundColor Red
        }
    }
}

$l = New-Object Net.HttpListener
$l.Prefixes.Add("http://localhost:$port/")

try {
    $l.Start()
} catch {
    Write-Host "ERROR: Could not start listener on port $port." -ForegroundColor Red
    Write-Host "This usually means another instance is already running or the port is blocked." -ForegroundColor Yellow
    Write-Host "Details: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit
}

# Open the browser automatically
try {
    Start-Process "http://localhost:$port/"
} catch {
    Write-Host "Could not open browser automatically. Please open http://localhost:$port/ manually." -ForegroundColor Yellow
}

Write-Host "Server is running. Keep this window open while playing!" -ForegroundColor Gray
Write-Host "Press Ctrl+C in this window to stop the server." -ForegroundColor Gray
Write-Host ""

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
            Write-Host " -> 200 OK (Saved profile to save_$user_safe.json)" -ForegroundColor Green
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
                Write-Host " -> 200 OK (Loaded profile from save_$user_safe.json)" -ForegroundColor Green
            } else {
                $res.StatusCode = 404
                $res.ContentType = "application/json"
                $writer = New-Object System.IO.StreamWriter($res.OutputStream)
                $writer.Write('{"error":"no save file"}')
                $writer.Close()
                Write-Host " -> 404 Not Found (No save_$user_safe.json)" -ForegroundColor Yellow
            }
            $res.Close()
            continue
        }

        if ($p -eq '') { $p = 'index.html' }
        
        # Replace forward slashes with backslashes for Windows path resolution
        $p_win = $p -replace '/', '\'
        $f = Join-Path $dir $p_win
        
        Write-Host "Request: $($req.HttpMethod) /$p" -NoNewline
        
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
                Write-Host " -> 200 OK ($($fs.Length) bytes, $t)" -ForegroundColor Green
            } finally {
                $fs.Close()
            }
        } else {
            $res.StatusCode = 404
            Write-Host " -> 404 Not Found" -ForegroundColor Yellow
        }
        
        $res.Close()
    } catch {
        Write-Host " -> ERROR: $_" -ForegroundColor Red
        # Make sure response is closed in case of exception to avoid hanging the client browser connection
        if ($null -ne $res) {
            try { $res.Close() } catch {}
        }
    }
}
