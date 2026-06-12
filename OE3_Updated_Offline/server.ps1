$port = 8765
$dir = $PSScriptRoot
if (-not $dir) { $dir = Get-Location }
$dir = $dir.ToString().TrimEnd('\')

$configPath = Join-Path $dir "config.json"
$config = $null
$global:forceVaultRefresh = $false
$global:forceLogout = $false
$global:gameInstances = @()
$global:instanceCount = 0
$global:cmdBuffer = ""
$global:inConsoleMode = $false
$global:version = "v0.4_Beta"

function Save-Config {
    $script:config | ConvertTo-Json | Out-File -FilePath $script:configPath -Force -Encoding utf8
}

# C# Win32 API import for changing window titles programmatically
try {
    $sig = '[DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern bool SetWindowText(IntPtr hWnd, string lpString);'
    Add-Type -MemberDefinition $sig -Name "Win32Utils" -Namespace "Win32" -ErrorAction SilentlyContinue
} catch {}

function Log-Message($msg, $color = "Gray") {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formattedMsg = "[$time] $msg"
    
    # Cooperative multitasking console redraw
    if ($global:inConsoleMode) {
        $len = 9 + $global:cmdBuffer.Length # "Console> " is 9 chars
        Write-Host ("`b" * $len) -NoNewline
        Write-Host (" " * $len) -NoNewline
        Write-Host ("`b" * $len) -NoNewline
        Write-Host $formattedMsg -ForegroundColor $color
        Write-Host "Console> $global:cmdBuffer" -NoNewline
    } else {
        Write-Host $formattedMsg -ForegroundColor $color
    }
    
    try {
        $logFile = Join-Path $dir "log.txt"
        Add-Content -Path $logFile -Value $formattedMsg -ErrorAction SilentlyContinue
    } catch {}
}

# Compiled C# database reader helper for high-performance skips/reads
try {
    $csharpCode = @"
using System;
using System.IO;
using System.Collections.Generic;

public class DbParser {
    public static List<string> ReadUserBlock(string path, int lineNum) {
        List<string> lines = new List<string>();
        using (StreamReader reader = new StreamReader(path)) {
            for (int i = 1; i < lineNum; i++) {
                reader.ReadLine();
            }
            string line;
            while ((line = reader.ReadLine()) != null) {
                lines.Add(line);
                string trimmed = line.Trim();
                if (trimmed.EndsWith("}") || trimmed.EndsWith("},")) {
                    if (line.StartsWith("\t}") || line.StartsWith("}")) {
                        break;
                    }
                }
            }
        }
        return lines;
    }
}
"@
    Add-Type -TypeDefinition $csharpCode -ErrorAction SilentlyContinue
} catch {}

function Parse-DateToMs($dateVal) {
    if (-not $dateVal) {
        return [System.DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
    }
    if ($dateVal -is [int] -or $dateVal -is [long] -or $dateVal -is [double]) {
        return [long]$dateVal
    }
    $parsedDate = $null
    $formats = @("yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd")
    foreach ($fmt in $formats) {
        try {
            $parsedDate = [DateTime]::ParseExact($dateVal, $fmt, [System.Globalization.CultureInfo]::InvariantCulture)
            $dto = New-Object System.DateTimeOffset($parsedDate)
            return $dto.ToUnixTimeMilliseconds()
        } catch {}
    }
    return [System.DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
}

function Convert-DictToList($dataDict, $size, $defaultVal) {
    $result = [System.Collections.Generic.List[object]]::new()
    
    $isDict = $false
    if ($null -ne $dataDict) {
        if ($dataDict -is [System.Collections.IDictionary]) {
            $isDict = $true
        } else {
            $props = $dataDict.PSObject.Properties | Select-Object -ExpandProperty Name
            if ($props -contains "0") {
                $isDict = $true
            }
        }
    }

    if ($isDict) {
        for ($idx = 0; $idx -lt $size; $idx++) {
            $strIdx = $idx.ToString()
            if ($null -ne $dataDict.$strIdx) {
                $val = $dataDict.$strIdx
                
                $isInnerDict = $false
                if ($val -is [System.Collections.IDictionary]) {
                    $isInnerDict = $true
                } elseif ($null -ne $val -and $val.PSObject -ne $null) {
                    $valProps = $val.PSObject.Properties | Select-Object -ExpandProperty Name
                    if ($valProps -contains "0") { $isInnerDict = $true }
                }

                if ($isInnerDict) {
                    $innerList = @(
                        [int]$(if ($null -ne $val."0") { $val."0" } else { -1 }),
                        [int]$(if ($null -ne $val."1") { $val."1" } else { -1 }),
                        [int]$(if ($null -ne $val."2") { $val."2" } else { -1 }),
                        [int]$(if ($null -ne $val."3") { $val."3" } else { -1 })
                    )
                    $result.Add($innerList)
                } else {
                    $result.Add([int]$val)
                }
            } else {
                $result.Add($defaultVal)
            }
        }
    } elseif ($dataDict -is [System.Collections.IList] -or $dataDict -is [array]) {
        for ($idx = 0; $idx -lt $size; $idx++) {
            if ($idx -lt $dataDict.Count) {
                $val = $dataDict[$idx]
                if ($val -is [System.Collections.IList] -or $val -is [array]) {
                    $arr = [System.Collections.Generic.List[int]]::new()
                    for ($i = 0; $i -lt 4; $i++) {
                        if ($i -lt $val.Count) { $arr.Add([int]$val[$i]) } else { $arr.Add(-1) }
                    }
                    $result.Add($arr.ToArray())
                } else {
                    $isInnerDict = $false
                    if ($val -is [System.Collections.IDictionary]) {
                        $isInnerDict = $true
                    } elseif ($null -ne $val -and $val.PSObject -ne $null) {
                        $valProps = $val.PSObject.Properties | Select-Object -ExpandProperty Name
                        if ($valProps -contains "0") { $isInnerDict = $true }
                    }

                    if ($isInnerDict) {
                        $innerList = @(
                            [int]$(if ($null -ne $val."0") { $val."0" } else { -1 }),
                            [int]$(if ($null -ne $val."1") { $val."1" } else { -1 }),
                            [int]$(if ($null -ne $val."2") { $val."2" } else { -1 }),
                            [int]$(if ($null -ne $val."3") { $val."3" } else { -1 })
                        )
                        $result.Add($innerList)
                    } else {
                        $result.Add([int]$val)
                    }
                }
            } else {
                $result.Add($defaultVal)
            }
        }
    } else {
        for ($idx = 0; $idx -lt $size; $idx++) {
            $result.Add($defaultVal)
        }
    }
    return $result.ToArray()
}

function Convert-LegacySave($user, $lineNum) {
    # Find database file
    $legacyDirs = @(
        (Join-Path $dir "Legacy Save Files"),
        (Join-Path (Split-Path $dir -Parent) "Legacy Save Files"),
        $dir
    )
    $dbPath = $null
    foreach ($d in $legacyDirs) {
        if (Test-Path $d) {
            $files = Get-ChildItem -Path $d -Filter "*.json" | Where-Object { $_.Name -like "*PlayerObjects*" }
            if ($files) {
                $dbPath = $files[0].FullName
                break
            }
        }
    }

    if ($null -eq $dbPath) {
        throw "No legacy database JSON file found in 'Legacy Save Files' folder."
    }

    # Execute C# block parser helper
    $userLines = [DbParser]::ReadUserBlock($dbPath, $lineNum)
    if ($userLines.Count -eq 0) {
        throw "Could not extract user data block from database at line $lineNum."
    }

    $fullStr = [string]::Join("`n", $userLines).TrimEnd()
    if ($fullStr.EndsWith(",")) {
        $fullStr = $fullStr.Substring(0, $fullStr.Length - 1)
    }

    $wrapper = "{" + $fullStr + "}"
    $userDataObj = $null
    try {
        $userDataObj = ConvertFrom-Json $wrapper
    } catch {
        throw "Failed to parse extracted JSON: $_"
    }

    $keys = @($userDataObj.PSObject.Properties | Where-Object { $_.MemberType -eq 'NoteProperty' } | Select-Object -ExpandProperty Name)
    if ($keys.Count -eq 0) {
        throw "Extracted JSON is empty or invalid."
    }
    $legacyUser = $userDataObj.$($keys[0])

    # Perform conversion logic
    $username = if ($null -ne $legacyUser.username) { $legacyUser.username } else { "GuestPlayer" }
    $maxInv = if ($null -ne $legacyUser.maxinventory) { [int]$legacyUser.maxinventory } else { 50 }

    $dangerClass = 0
    if ($null -ne $legacyUser.class) {
        $dangerClass = [int]$legacyUser.class
    } elseif ($null -ne $legacyUser.dangerClass) {
        $dangerClass = [int]$legacyUser.dangerClass
    }

    $newUser = [ordered]@{
        username = $username
        callsign = if ($null -ne $legacyUser.callsign) { $legacyUser.callsign } else { $username }
        password = if ($null -ne $legacyUser.password) { $legacyUser.password } else { "" }
        credits = if ($null -ne $legacyUser.credits) { [int]$legacyUser.credits } else { 500 }
        stations = if ($null -ne $legacyUser.stations) { [int]$legacyUser.stations } else { 7 }
        maxinventory = $maxInv
        wins = if ($null -ne $legacyUser.wins) { [int]$legacyUser.wins } else { 0 }
        losses = if ($null -ne $legacyUser.losses) { [int]$legacyUser.losses } else { 0 }
        rating = if ($null -ne $legacyUser.rating) { [int]$legacyUser.rating } else { 1000 }
        classlock = if ($null -ne $legacyUser.classlock) { [int]$legacyUser.classlock } else { 0 }
        dangerClass = $dangerClass
        campaignseed = if ($null -ne $legacyUser.campaignseed) { [int]$legacyUser.campaignseed } else { 0 }
        campaignstart = if ($null -ne $legacyUser.campaignstart) { [int]$legacyUser.campaignstart } else { -1 }
        lastbonus = 0
        platinum = if ($null -ne $legacyUser.platinum) { [int]$legacyUser.platinum } else { 30 }
        starttime = if ($null -ne $legacyUser.starttime) { $legacyUser.starttime } else { "" }
    }

    $newUser["lasttime"] = Parse-DateToMs($legacyUser.lasttime)
    $newUser["laststations"] = Parse-DateToMs($legacyUser.laststations)

    $newUser["armory"] = Convert-DictToList $legacyUser.armory $maxInv @(-1, -1, -1, -1)
    $newUser["equip"] = Convert-DictToList $legacyUser.equip 21 -1
    $newUser["campaign"] = Convert-DictToList $legacyUser.campaign 36 0
    $newUser["prizes"] = Convert-DictToList $legacyUser.prizes 36 @(-1, -1, -1, -1)

    # Save files
    $savesDir = Join-Path $dir "saves"
    if (-not (Test-Path $savesDir)) {
        New-Item -ItemType Directory -Path $savesDir | Out-Null
    }

    $safeUsername = $username -replace '[^a-zA-Z0-9_\-]', ''
    if (-not $safeUsername) { $safeUsername = "GuestPlayer" }

    $outputFile = Join-Path $savesDir "save_$safeUsername.json"
    $newUserJson = ConvertTo-Json -InputObject $newUser -Depth 5
    [System.IO.File]::WriteAllText($outputFile, $newUserJson, [System.Text.Encoding]::UTF8)

    # Secondary file for callsign if it differs
    $callsign = $newUser["callsign"]
    if ($null -ne $callsign) {
        $safeCallsign = $callsign -replace '[^a-zA-Z0-9_\-]', ''
        if ($safeCallsign -and $safeCallsign.ToLower() -ne $safeUsername.ToLower()) {
            $callsignUser = [ordered]@{
                username = $callsign
                callsign = $callsign
            }
            foreach ($k in $newUser.Keys) {
                if ($k -ne "username" -and $k -ne "callsign") {
                    $callsignUser[$k] = $newUser[$k]
                }
            }
            $callsignFile = Join-Path $savesDir "save_$safeCallsign.json"
            $callsignJson = ConvertTo-Json -InputObject $callsignUser -Depth 5
            [System.IO.File]::WriteAllText($callsignFile, $callsignJson, [System.Text.Encoding]::UTF8)
        }
    }
}

# Clear old log file at startup
try {
    $logFile = [System.IO.Path]::Combine($dir, "log.txt")
    if ([System.IO.File]::Exists($logFile)) { 
        [System.IO.File]::Delete($logFile) 
    }
} catch {}

Log-Message "=========================================" "Green"
Log-Message "   OE3 Offline Server Starting ($global:version)..." "Green"
Log-Message "   Serving from: $dir" "Cyan"
Log-Message "=========================================" "Green"

# Load or Initialize config.json
if (Test-Path $configPath) {
    try {
        $config = Get-Content -Raw $configPath | ConvertFrom-Json
        Log-Message "Loaded launcher config from config.json." "Green"
    } catch {
        Log-Message "Error parsing config.json: $_. Recreating defaults." "Yellow"
    }
}

if ($null -eq $config) {
    $config = [PSCustomObject]@{
        launch_mode = "ask"
        remember_mode = $false
        ruffle_backend = "dx12"
        default_quality = "medium"
        disable_plat_purchase = $false
        store_refresh_period_minutes = 60
    }
}

# Ensure all fields are populated
$configUpdated = $false
if ($null -eq $config.launch_mode) { $config | Add-Member -MemberType NoteProperty -Name "launch_mode" -Value "ask" -Force; $configUpdated = $true }
if ($null -eq $config.remember_mode) { $config | Add-Member -MemberType NoteProperty -Name "remember_mode" -Value $false -Force; $configUpdated = $true }
if ($null -eq $config.ruffle_backend) { $config | Add-Member -MemberType NoteProperty -Name "ruffle_backend" -Value "dx12" -Force; $configUpdated = $true }
if ($null -eq $config.default_quality) { $config | Add-Member -MemberType NoteProperty -Name "default_quality" -Value "medium" -Force; $configUpdated = $true }
if ($null -eq $config.disable_plat_purchase) { $config | Add-Member -MemberType NoteProperty -Name "disable_plat_purchase" -Value $false -Force; $configUpdated = $true }
if ($null -eq $config.store_refresh_period_minutes) { $config | Add-Member -MemberType NoteProperty -Name "store_refresh_period_minutes" -Value 60 -Force; $configUpdated = $true }

if ($configUpdated) {
    Save-Config
    Log-Message "Populated missing configuration defaults in config.json." "Green"
}

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

# 1.5 Auto-migrate existing saves from root folder to saves/ folder
try {
    $savesDir = Join-Path $dir "saves"
    if (-not (Test-Path $savesDir)) {
        [System.IO.Directory]::CreateDirectory($savesDir) | Out-Null
    }
    Get-ChildItem -Path $dir -Filter "save_*.json" -File | ForEach-Object {
        $dest = Join-Path $savesDir $_.Name
        if (-not (Test-Path $dest)) {
            Log-Message "Migrating save file: $($_.Name) -> saves/" "Cyan"
            Move-Item -Path $_.FullName -Destination $dest -Force
        } else {
            Remove-Item -Path $_.FullName -Force
        }
    }
} catch {
    Log-Message "Error migrating saves: $_" "Yellow"
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
        Log-Message "HTTP Server successfully started and listening at http://127.0.0.1:$port/" "Green"
        break
    } catch {
        Log-Message "Failed to start listener on port $currentPort - $_" "Yellow"
        try { $l.Close() } catch {}
    }
}

if (-not $listenerStarted) {
    Log-Message "ERROR: Could not find any available port to start the HTTP listener (tried ports $port to $($port + $maxTries - 1))." "Red"
    exit 1
}

# 3. Choose Launch Mode & Optionally Remember
$launchMode = $config.launch_mode
$flashplayerExe = [System.IO.Path]::Combine($dir, "flashplayer.exe")
$ruffleExe = [System.IO.Path]::Combine($dir, "ruffle.exe")

if (-not $launchMode -or $launchMode -eq "default") {
    $launchMode = "ask"
}

if ($config.remember_mode -and $launchMode -ne "ask") {
    Log-Message "Using remembered launch mode: $launchMode" "Green"
} else {
    $hasFlash = [System.IO.File]::Exists($flashplayerExe)
    $hasRuffle = [System.IO.File]::Exists($ruffleExe)
    
    $flashStatus = if ($hasFlash) { "Available - Recommended" } else { "NOT FOUND" }
    $ruffleStatus = if ($hasRuffle) { "Available" } else { "NOT FOUND" }
    
    $hasConverter = Test-Path (Join-Path $dir "converter.html")
    if ($hasConverter) {
        Log-Message " [5] Web Save Converter" "Cyan"
        Log-Message "=========================================" "Cyan"
        $choice = Read-Host " Enter choice (1-5, Default is 1)"
    } else {
        Log-Message "=========================================" "Cyan"
        $choice = Read-Host " Enter choice (1-4, Default is 1)"
    }
    if ($choice -eq "2") {
        $launchMode = "ruffle"
    } elseif ($choice -eq "3") {
        $launchMode = "browser"
    } elseif ($choice -eq "4") {
        $launchMode = "auto"
    } elseif ($choice -eq "5" -and $hasConverter) {
        $launchMode = "converter"
    } else {
        $launchMode = "flashplayer"
    }
    
    $rem = Read-Host " Remember this selection for next launch? (y/n)"
    if ($rem.ToLower().Trim() -eq "y" -or $rem.ToLower().Trim() -eq "yes") {
        $config.launch_mode = $launchMode
        $config.remember_mode = $true
        Save-Config
        Log-Message "Launch mode selection remembered." "Green"
    }
}

function Set-WindowTitle($proc, $title) {
    if ($null -eq $proc) { return }
    try {
        for ($i = 0; $i -lt 15; $i++) {
            $proc.Refresh()
            if ($proc.MainWindowHandle -ne [System.IntPtr]::Zero) {
                [Win32.Win32Utils]::SetWindowText($proc.MainWindowHandle, $title) | Out-Null
                break
            }
            Start-Sleep -Milliseconds 150
        }
    } catch {}
}

function Start-GameInstance {
    $mode = $script:config.launch_mode
    $flashplayerExe = [System.IO.Path]::Combine($script:dir, "flashplayer.exe")
    $ruffleExe = [System.IO.Path]::Combine($script:dir, "ruffle.exe")
    
    if ($mode -eq "converter") {
        try {
            Log-Message "Opening Web Save Converter in default browser..." "Green"
            Start-Process "http://127.0.0.1:$script:port/converter.html"
        } catch {
            Log-Message "Could not open browser. Please open http://127.0.0.1:$script:port/converter.html manually." "Yellow"
        }
        return $null
    }
    
    if ($mode -eq "ask" -or $mode -eq "auto") {
        if ([System.IO.File]::Exists($flashplayerExe)) {
            $mode = "flashplayer"
        } elseif ([System.IO.File]::Exists($ruffleExe)) {
            $mode = "ruffle"
        } else {
            $mode = "browser"
        }
    }
    
    $proc = $null
    if ($mode -eq "flashplayer") {
        if ([System.IO.File]::Exists($flashplayerExe)) {
            try {
                Log-Message "Launching game natively on http://127.0.0.1:$script:port/OE3_UPDATED.swf using Flash Player Projector..." "Gray"
                $proc = Start-Process -FilePath $flashplayerExe -ArgumentList "http://127.0.0.1:$script:port/OE3_UPDATED.swf" -PassThru
                Log-Message "Flash Player Projector launched successfully." "Green"
            } catch {
                Log-Message "Failed to start Flash Player Projector. Falling back to Ruffle..." "Yellow"
                $mode = "ruffle"
            }
        } else {
            Log-Message "flashplayer.exe not found! Falling back to Ruffle..." "Yellow"
            $mode = "ruffle"
        }
    }
    
    if ($mode -eq "ruffle") {
        if ([System.IO.File]::Exists($ruffleExe)) {
            try {
                $backend = $script:config.ruffle_backend
                if (-not $backend) { $backend = "dx12" }
                $env:RUFFLE_BACKEND = $backend
                $env:WGPU_BACKEND = $backend
                
                Log-Message "Launching game natively on http://127.0.0.1:$script:port/OE3_UPDATED.swf using graphics backend '$backend'..." "Gray"
                $proc = Start-Process -FilePath $ruffleExe -ArgumentList "http://127.0.0.1:$script:port/OE3_UPDATED.swf", "-g", $backend -PassThru
                Log-Message "Ruffle Desktop launched successfully." "Green"
            } catch {
                Log-Message "Failed to start Ruffle Desktop. Falling back to web browser..." "Yellow"
                $mode = "browser"
            }
        } else {
            Log-Message "ruffle.exe not found! Falling back to web browser..." "Yellow"
            $mode = "browser"
        }
    }
    
    if ($mode -eq "browser") {
        try {
            Log-Message "Opening default web browser to http://127.0.0.1:$script:port/..." "Gray"
            Start-Process "http://127.0.0.1:$script:port/"
            Log-Message "Browser launched successfully." "Green"
        } catch {
            Log-Message "Could not open browser automatically. Please open http://127.0.0.1:$script:port/ manually." "Yellow"
        }
    }
    
    return $proc
}

function Run-Diagnostics {
    Write-Host "=== Launcher & Server Diagnostics ===" -ForegroundColor Cyan
    Write-Host "  PowerShell Version:     $($PSVersionTable.PSVersion)"
    Write-Host "  Working Directory:      $script:dir"
    Write-Host "  Port Binding:           http://127.0.0.1:$script:port/"
    Write-Host "  HTTP Listener Status:   $(if ($script:l.IsListening) { 'RUNNING' } else { 'STOPPED' })"
    
    $files = @("index.html", "OE3_UPDATED.swf", "flashplayer.exe", "ruffle.exe")
    Write-Host "  File Checks:"
    foreach ($f in $files) {
        $p = Join-Path $script:dir $f
        $exists = [System.IO.File]::Exists($p)
        $status = if ($exists) { "FOUND" } else { "NOT FOUND" }
        $color = if ($exists) { "Green" } else { "Yellow" }
        if (($f -eq "index.html" -or $f -eq "OE3_UPDATED.swf") -and -not $exists) {
            $status = "CRITICAL MISSING"
            $color = "Red"
        }
        Write-Host "    $($f): " -NoNewline
        Write-Host "$status" -ForegroundColor $color
    }
    
    # Active port checking
    Write-Host "  Port Occupancy:"
    try {
        $netstat = netstat -ano | Select-String ":$script:port\s+" | Select-Object -First 1
        if ($netstat) {
            Write-Host "    Port $script:port details: $($netstat.Line.Trim())" -ForegroundColor Yellow
        } else {
            Write-Host "    Port $script:port is successfully occupied by this server instance." -ForegroundColor Green
        }
    } catch {
        Write-Host "    Unable to run port check: $_" -ForegroundColor Yellow
    }
}

function Execute-ConsoleCommand($inputStr) {
    if (-not $inputStr) { return }
    $inputStr = $inputStr.Trim()
    $parts = $inputStr.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
    $action = $parts[0].ToLower()
    
    if ($action -eq "exit" -or $action -eq "resume") {
        $global:inConsoleMode = $false
        Log-Message "Resuming status logs..." "Green"
        return
    }
    
    switch ($action) {
        "help" {
            Write-Host "Commands List:" -ForegroundColor White
            Write-Host "  help                 Display this help menu"
            Write-Host "  launch               Launch a new instance of the game"
            Write-Host "  instances            List all active game instances"
            Write-Host "  close <id>           Close a specific game instance by its ID number"
            Write-Host "  logout               Send logout signal to all running client connections"
            Write-Host "  logs                 Show the last 20 log entries"
            Write-Host "  config               Show current configuration values"
            Write-Host "  mode <type>          Set launch mode (ask, flashplayer, ruffle, browser, auto)"
            Write-Host "  quality <val>        Set default Ruffle graphics quality (high, medium, low)"
            Write-Host "  backend <type>       Set default Ruffle backend (dx12, vulkan, dx11, gl, default)"
            Write-Host "  plat, platt <on/off> Toggle platinum purchasing (enable/disable)"
            Write-Host "  store-period <min>   Set store refresh period in minutes"
            Write-Host "  refresh-store        Force immediate shop items and vault clock refresh"
            Write-Host "  saves                Open the saves folder in Windows Explorer"
            Write-Host "  check-saves          Perform diagnostic integrity scan on all user saves"
            Write-Host "  converter            Open the Web legacy save converter in your browser"
            Write-Host "  diagnostics          Run server health diagnostics check"
            Write-Host "  shutdown             Stop server and exit launcher terminal"
        }
        "launch" {
            $proc = Start-GameInstance
            if ($proc) {
                $global:instanceCount++
                $inst = [PSCustomObject]@{
                    id = $global:instanceCount
                    process = $proc
                    mode = $config.launch_mode
                    start_time = Get-Date -Format "HH:mm:ss"
                }
                $global:gameInstances += $inst
                Set-WindowTitle $proc "OE3 Instance $($inst.id)"
                Write-Host "Launched Game Instance $($inst.id) (PID $($proc.Id)) successfully." -ForegroundColor Green
            } else {
                Write-Host "Browser instance launched." -ForegroundColor Green
            }
        }
        "instances" {
            Write-Host "--- Active Game Instances ---" -ForegroundColor Cyan
            if ($global:gameInstances.Count -eq 0) {
                Write-Host "  No active game instances running." -ForegroundColor Yellow
            } else {
                foreach ($inst in $global:gameInstances) {
                    Write-Host "  Instance $($inst.id): PID $($inst.process.Id) | Mode: $($inst.mode) | Started: $($inst.start_time)" -ForegroundColor White
                }
            }
        }
        "close" {
            if ($parts.Count -lt 2) {
                Write-Host "Usage: close <instance_id>" -ForegroundColor Yellow
            } else {
                try {
                    $instId = [int]$parts[1]
                    $inst = $global:gameInstances | Where-Object { $_.id -eq $instId }
                    if ($inst) {
                        $inst.process.Kill()
                        Write-Host "Game Instance $instId (PID $($inst.process.Id)) terminated." -ForegroundColor Green
                    } else {
                        Write-Host "Instance $instId not found." -ForegroundColor Red
                    }
                } catch {
                    Write-Host "Error parsing instance ID or closing process: $_" -ForegroundColor Red
                }
            }
        }
        "logout" {
            $global:forceLogout = $true
            Log-Message "Logout signal sent to all game clients." "Green"
            Write-Host "Logout signal set. Game clients will log out on next poll (within 10s)." -ForegroundColor Green
        }
        "logs" {
            $logPath = Join-Path $script:dir "log.txt"
            if (Test-Path $logPath) {
                Write-Host "--- Last 20 logs ---" -ForegroundColor Cyan
                Get-Content -Path $logPath -Tail 20 | ForEach-Object { Write-Host $_ }
            } else {
                Write-Host "Log file not found." -ForegroundColor Yellow
            }
        }
        "config" {
            Write-Host "--- Current Config Settings ---" -ForegroundColor Cyan
            Write-Host "  Launch Mode:            $($script:config.launch_mode)"
            Write-Host "  Remember Mode:          $($script:config.remember_mode)"
            Write-Host "  Ruffle Backend:         $($script:config.ruffle_backend)"
            Write-Host "  Default Quality:        $($script:config.default_quality)"
            Write-Host "  Disable Plat Purchase:  $($script:config.disable_plat_purchase)"
            Write-Host "  Store Refresh Period:   $($script:config.store_refresh_period_minutes) minutes"
        }
        "mode" {
            if ($parts.Count -lt 2) {
                Write-Host "Usage: mode [ask|flashplayer|ruffle|browser|auto|converter]" -ForegroundColor Yellow
            } else {
                $newMode = $parts[1].ToLower()
                if ($newMode -in @("ask", "flashplayer", "ruffle", "browser", "auto", "converter")) {
                    $script:config.launch_mode = $newMode
                    if ($newMode -eq "ask") {
                        $script:config.remember_mode = $false
                    }
                    Save-Config
                    Write-Host "Launch mode set to '$newMode'." -ForegroundColor Green
                } else {
                    Write-Host "Invalid mode: '$newMode'. Select from: ask, flashplayer, ruffle, browser, auto, converter" -ForegroundColor Red
                }
            }
        }
        "quality" {
            if ($parts.Count -lt 2) {
                Write-Host "Usage: quality [high|medium|low]" -ForegroundColor Yellow
            } else {
                $newQ = $parts[1].ToLower()
                if ($newQ -in @("high", "medium", "low")) {
                    $script:config.default_quality = $newQ
                    Save-Config
                    Write-Host "Default quality set to '$newQ'." -ForegroundColor Green
                } else {
                    Write-Host "Invalid quality: '$newQ'. Select from: high, medium, low" -ForegroundColor Red
                }
            }
        }
        "backend" {
            if ($parts.Count -lt 2) {
                Write-Host "Usage: backend [dx12|vulkan|dx11|gl|default]" -ForegroundColor Yellow
            } else {
                $newB = $parts[1].ToLower()
                if ($newB -in @("dx12", "vulkan", "dx11", "gl", "default")) {
                    $script:config.ruffle_backend = $newB
                    Save-Config
                    Write-Host "Ruffle backend set to '$newB'." -ForegroundColor Green
                } else {
                    Write-Host "Invalid backend: '$newB'. Select from: dx12, vulkan, dx11, gl, default" -ForegroundColor Red
                }
            }
        }
        "plat" {
            if ($parts.Count -lt 2) {
                Write-Host "Usage: plat [enable|disable|on|off]" -ForegroundColor Yellow
            } else {
                $val = $parts[1].ToLower()
                if ($val -in @("disable", "off", "true")) {
                    $script:config.disable_plat_purchase = $true
                    Save-Config
                    Write-Host "Platinum purchasing disabled." -ForegroundColor Green
                } elseif ($val -in @("enable", "on", "false")) {
                    $script:config.disable_plat_purchase = $false
                    Save-Config
                    Write-Host "Platinum purchasing enabled." -ForegroundColor Green
                } else {
                    Write-Host "Invalid option. Use 'enable' or 'disable'." -ForegroundColor Red
                }
            }
        }
        "platt" {
            if ($parts.Count -lt 2) {
                Write-Host "Usage: plat [enable|disable|on|off]" -ForegroundColor Yellow
            } else {
                $val = $parts[1].ToLower()
                if ($val -in @("disable", "off", "true")) {
                    $script:config.disable_plat_purchase = $true
                    Save-Config
                    Write-Host "Platinum purchasing disabled." -ForegroundColor Green
                } elseif ($val -in @("enable", "on", "false")) {
                    $script:config.disable_plat_purchase = $false
                    Save-Config
                    Write-Host "Platinum purchasing enabled." -ForegroundColor Green
                } else {
                    Write-Host "Invalid option. Use 'enable' or 'disable'." -ForegroundColor Red
                }
            }
        }
        "refresh-store" {
            $global:forceVaultRefresh = $true
            Log-Message "Force store refresh triggered by launcher console." "Green"
            Write-Host "Store refresh flag set. The store will refresh on the client's next sync poll (occurs every 10s)." -ForegroundColor Green
        }
        "store-period" {
            if ($parts.Count -lt 2) {
                Write-Host "Usage: store-period <minutes>" -ForegroundColor Yellow
            } else {
                try {
                    $min = [int]$parts[1]
                    if ($min -lt 1) {
                        Write-Host "Period must be at least 1 minute." -ForegroundColor Red
                    } else {
                        $script:config.store_refresh_period_minutes = $min
                        Save-Config
                        $global:forceVaultRefresh = $true
                        Log-Message "Store refresh period set to $min minutes. Immediate store refresh triggered." "Green"
                        Write-Host "Store refresh period set to $min minutes. Immediate store refresh triggered." -ForegroundColor Green
                    }
                } catch {
                    Write-Host "Invalid number of minutes: '$($parts[1])'" -ForegroundColor Red
                }
            }
        }
        "saves" {
            $savesDir = Join-Path $script:dir "saves"
            if (Test-Path $savesDir) {
                explorer.exe $savesDir
                Write-Host "Opened saves directory." -ForegroundColor Green
            } else {
                Write-Host "Saves directory not found." -ForegroundColor Yellow
            }
        }
        "converter" {
            if (Test-Path (Join-Path $script:dir "converter.html")) {
                Start-Process "http://127.0.0.1:$script:port/converter.html"
                Write-Host "Opened Web Legacy Save Converter in browser." -ForegroundColor Green
            } else {
                Write-Host "Error: The Web legacy save converter is not included in this release version." -ForegroundColor Red
            }
        }
        "check-saves" {
            $savesDir = Join-Path $script:dir "saves"
            if (-not (Test-Path $savesDir)) {
                Write-Host "Saves folder not found at: $savesDir" -ForegroundColor Red
                return
            }
            $files = Get-ChildItem -Path $savesDir -Filter "save_*.json"
            if ($files.Count -eq 0) {
                Write-Host "No save files found in saves/ folder." -ForegroundColor Yellow
                return
            }
            Write-Host "Scanning save profiles:" -ForegroundColor Cyan
            foreach ($f in $files) {
                $user = $f.BaseName.Replace("save_", "")
                $size = $f.Length
                $modified = $f.LastWriteTime
                $status = "OK"
                $errorMsg = ""
                try {
                    $raw = Get-Content -Raw $f.FullName
                    $json = ConvertFrom-Json $raw
                    if ($null -eq $json) {
                        $status = "EMPTY FILE"
                    } elseif (-not $json.credits -or -not $json.platinum) {
                        $status = "WARNING (Keys missing)"
                    }
                } catch {
                    $status = "CORRUPT JSON"
                    $errorMsg = $_.Exception.Message
                }
                
                Write-Host "  User: $user" -ForegroundColor White
                Write-Host "    Size: $size bytes"
                Write-Host "    Last Modified: $modified"
                if ($status -eq "OK") {
                    Write-Host "    Status: $status" -ForegroundColor Green
                } else {
                    Write-Host "    Status: $status" -ForegroundColor Red
                    if ($errorMsg) { Write-Host "    Error: $errorMsg" -ForegroundColor Yellow }
                }
            }
        }
        "diagnostics" {
            Run-Diagnostics
        }
        "shutdown" {
            Write-Host "Shutting down HTTP server..." -ForegroundColor Red
            foreach ($inst in $global:gameInstances) {
                try { $inst.process.Kill() } catch {}
            }
            $script:l.Stop()
            exit 0
        }
        default {
            Write-Host "Unknown command '$action'. Type 'help' for command list." -ForegroundColor Red
        }
    }
}

# Launch initial game instance
$firstProc = Start-GameInstance
if ($firstProc) {
    $global:instanceCount++
    $firstInst = [PSCustomObject]@{
        id = $global:instanceCount
        process = $firstProc
        mode = $config.launch_mode
        start_time = Get-Date -Format "HH:mm:ss"
    }
    $global:gameInstances += $firstInst
    Set-WindowTitle $firstProc "OE3 Instance $($firstInst.id)"
}

Log-Message "Server is running. Press any key to open the interactive console." "Gray"
Log-Message "Press Ctrl+C to force stop the server." "Gray"
Log-Message ""

$contextAsync = $l.BeginGetContext($null, $null)

while ($l.IsListening) {
    $res = $null
    try {
        # Cooperative check for HTTP request (non-blocking)
        if ($contextAsync.IsCompleted) {
            $c = $l.EndGetContext($contextAsync)
            $contextAsync = $l.BeginGetContext($null, $null)
            
            $req = $c.Request
            $res = $c.Response
            
            $p = $req.Url.LocalPath.TrimStart('/')
            
            if ($p -eq 'config' -and $req.HttpMethod -eq 'GET') {
                $cfgData = @{
                    launch_mode = $config.launch_mode
                    remember_mode = $config.remember_mode
                    ruffle_backend = $config.ruffle_backend
                    default_quality = $config.default_quality
                    disable_plat_purchase = $config.disable_plat_purchase
                    store_refresh_period_minutes = $config.store_refresh_period_minutes
                    force_vault_refresh = $global:forceVaultRefresh
                    force_logout = $global:forceLogout
                }
                $global:forceVaultRefresh = $false
                $global:forceLogout = $false
                
                $body = $cfgData | ConvertTo-Json -Compress
                $res.StatusCode = 200
                $res.ContentType = "application/json"
                $writer = New-Object System.IO.StreamWriter($res.OutputStream)
                $writer.Write($body)
                $writer.Close()
                Log-Message "Request: GET /config -> 200 OK (Served config)" "Green"
                $res.Close()
                continue
            }
            
            if ($p -eq 'save' -and $req.HttpMethod -eq 'POST') {
                $user = $req.QueryString["user"]
                $user_safe = [regex]::Replace($user, '[^a-zA-Z0-9_\-]', '')
                if (-not $user_safe) { $user_safe = "GuestPlayer" }
                $reader = New-Object System.IO.StreamReader($req.InputStream)
                $body = $reader.ReadToEnd()
                $reader.Close()
                $savesDir = Join-Path $dir "saves"
                if (-not (Test-Path $savesDir)) {
                    [System.IO.Directory]::CreateDirectory($savesDir) | Out-Null
                }
                $saveFile = Join-Path $savesDir "save_$user_safe.json"
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
                
                $saveFile = Join-Path $dir "saves\save_$user_safe.json"
                if (-not (Test-Path $saveFile)) {
                    $saveFile = Join-Path $dir "save_$user_safe.json"
                }
                
                # Explicit case-insensitive resolution if file is not found (useful for cross-platform/case-sensitive setups)
                if (-not (Test-Path $saveFile)) {
                    $savesDir = Join-Path $dir "saves"
                    if (Test-Path $savesDir) {
                        $matchedFile = Get-ChildItem -Path $savesDir -Filter "save_*.json" -File | Where-Object { $_.BaseName -ieq "save_$user_safe" } | Select-Object -First 1
                        if ($matchedFile) {
                            $saveFile = $matchedFile.FullName
                        }
                    }
                }
                
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
            if ($p -eq 'legacy/generate_index' -and $req.HttpMethod -eq 'POST') {
                try {
                    if (Test-Path (Join-Path $dir "index_status.json")) { Remove-Item (Join-Path $dir "index_status.json") -Force | Out-Null }
                    if (Test-Path (Join-Path $dir "legacy_index.json")) { Remove-Item (Join-Path $dir "legacy_index.json") -Force | Out-Null }
                } catch {}
                
                Log-Message "Starting background scan of legacy database..." "Cyan"
                Start-Process -FilePath "python" -ArgumentList "generate_index.py" -WorkingDirectory $dir -NoNewWindow
                
                $res.StatusCode = 200
                $res.ContentType = "application/json"
                $writer = New-Object System.IO.StreamWriter($res.OutputStream)
                $writer.Write('{"status":"ok"}')
                $writer.Close()
                $res.Close()
                continue
            }
            if ($p -eq 'legacy/convert' -and $req.HttpMethod -eq 'GET') {
                $user = $req.QueryString["user"]
                $line = $req.QueryString["line"]
                Log-Message "Converting legacy save for: $user (Line $line) natively..." "Cyan"
                
                $res.StatusCode = 200
                $res.ContentType = "application/json"
                $writer = New-Object System.IO.StreamWriter($res.OutputStream)

                try {
                    Convert-LegacySave -user $user -lineNum $line
                    $writer.Write('{"status":"ok"}')
                    Log-Message "Conversion successful for legacy user: $user" "Green"
                } catch {
                    $errorMsg = $_.ToString().Trim()
                    $escapedError = $errorMsg -replace '"','\"' -replace "`r","" -replace "`n","\n"
                    $writer.Write("{\`"status\`":\`"error\`",\`"message\`":\`"$escapedError\`"}")
                    Log-Message "Conversion failed for legacy user $user : $errorMsg" "Red"
                }
                $writer.Close()
                $res.Close()
                continue
            }

            if ($p -eq '') { $p = 'index.html' }
            
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
                    '.json' { 'application/json; charset=utf-8' }
                    default { 'application/octet-stream' }
                }
                
                $res.ContentType = $t
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
        }
        
        # Check if game processes exited
        $exitedInstances = @()
        foreach ($inst in $global:gameInstances) {
            if ($inst.process -and $inst.process.HasExited) {
                Log-Message "Game Instance $($inst.id) (PID $($inst.process.Id)) has closed." "Yellow"
                $exitedInstances += $inst
            }
        }
        if ($exitedInstances.Count -gt 0) {
            $global:gameInstances = $global:gameInstances | Where-Object { $_.id -notin $exitedInstances.id }
            if ($global:gameInstances.Count -eq 0) {
                $autoShutdown = $true
                if ($global:inConsoleMode) {
                    $len = 9 + $global:cmdBuffer.Length
                    Write-Host ("`b" * $len) -NoNewline
                    Write-Host (" " * $len) -NoNewline
                    Write-Host ("`b" * $len) -NoNewline
                }
                Write-Host "All game instances have closed. Server will auto-shutdown in 5 seconds. Press any key to cancel and open the console..." -ForegroundColor Yellow
                for ($sec = 5; $sec -gt 0; $sec--) {
                    Write-Host "$sec... " -NoNewline -ForegroundColor Yellow
                    for ($ms = 0; $ms -lt 1000; $ms += 100) {
                        if ($contextAsync.IsCompleted) {
                            $c = $l.EndGetContext($contextAsync)
                            $contextAsync = $l.BeginGetContext($null, $null)
                            
                            $req = $c.Request
                            $res = $c.Response
                            $p = $req.Url.LocalPath.TrimStart('/')
                            
                            if ($p -eq 'config' -and $req.HttpMethod -eq 'GET') {
                                $cfgData = @{
                                    launch_mode = $config.launch_mode
                                    remember_mode = $config.remember_mode
                                    ruffle_backend = $config.ruffle_backend
                                    default_quality = $config.default_quality
                                    disable_plat_purchase = $config.disable_plat_purchase
                                    force_vault_refresh = $global:forceVaultRefresh
                                    force_logout = $global:forceLogout
                                }
                                $global:forceVaultRefresh = $false
                                $global:forceLogout = $false
                                
                                $body = $cfgData | ConvertTo-Json -Compress
                                $res.StatusCode = 200
                                $res.ContentType = "application/json"
                                $writer = New-Object System.IO.StreamWriter($res.OutputStream)
                                $writer.Write($body)
                                $writer.Close()
                                Log-Message "Request: GET /config -> 200 OK (Served config)" "Green"
                                $res.Close()
                            } else {
                                $res.StatusCode = 404
                                $res.Close()
                            }
                        }
                        if ([Console]::KeyAvailable) {
                            $null = [Console]::ReadKey($true)
                            $autoShutdown = $false
                            break
                        }
                        Start-Sleep -Milliseconds 100
                    }
                    if (-not $autoShutdown) { break }
                }
                Write-Host ""
                if ($autoShutdown) {
                    Log-Message "Auto-shutdown triggered. Stopping server..." "Yellow"
                    $l.Stop()
                    break
                } else {
                    Log-Message "Auto-shutdown cancelled by user." "Green"
                    $global:inConsoleMode = $true
                    $global:cmdBuffer = ""
                    Write-Host "Console> " -NoNewline
                }
            }
        }
        
        # Check for console key input
        if ([Console]::KeyAvailable) {
            $keyInfo = [Console]::ReadKey($true)
            if (-not $global:inConsoleMode) {
                $global:inConsoleMode = $true
                $global:cmdBuffer = ""
                Write-Host ""
                Write-Host "====================================================" -ForegroundColor Yellow
                Write-Host "         LAUNCHER INTERACTIVE CONSOLE               " -ForegroundColor Yellow
                Write-Host "====================================================" -ForegroundColor Yellow
                Write-Host " Type 'help' to see commands, or 'exit' to close console." -ForegroundColor Cyan
                Write-Host "====================================================" -ForegroundColor Yellow
                Write-Host "Console> " -NoNewline
            } else {
                if ($keyInfo.Key -eq [System.ConsoleKey]::Enter) {
                    Write-Host ""
                    Execute-ConsoleCommand $global:cmdBuffer
                    $global:cmdBuffer = ""
                    if ($global:inConsoleMode) {
                        Write-Host "Console> " -NoNewline
                    }
                } elseif ($keyInfo.Key -eq [System.ConsoleKey]::Backspace) {
                    if ($global:cmdBuffer.Length -gt 0) {
                        $global:cmdBuffer = $global:cmdBuffer.Substring(0, $global:cmdBuffer.Length - 1)
                        Write-Host "`b `b" -NoNewline
                    }
                } else {
                    $char = $keyInfo.KeyChar
                    if ($char) {
                        $global:cmdBuffer += $char
                        Write-Host $char -NoNewline
                    }
                }
            }
        }
        
        Start-Sleep -Milliseconds 50
    } catch {
        Log-Message "Error in main loop: $_" "Red"
        if ($null -ne $res) {
            try { $res.Close() } catch {}
        }
        Start-Sleep -Milliseconds 50
    }
}
