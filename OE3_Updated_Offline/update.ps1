param(
    [string]$GameDir = $PSScriptRoot,
    [switch]$Force
)

# Disable PowerShell progress bar to speed up downloads significantly
$ProgressPreference = 'SilentlyContinue'

# Force TLS 1.2/1.3 for GitHub API requests
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

# Clean trailing backslash
if ($GameDir) { $GameDir = $GameDir.TrimEnd('\') }

$scriptName = "update.ps1"
$tempScript = Join-Path $env:TEMP "oe3_update.ps1"

# 1. Self-relocation logic to avoid file locks
if ($PSScriptRoot -ne $env:TEMP) {
    # Running from game folder. Check for updates first!
    Write-Host "Checking for updates..." -ForegroundColor Cyan
    
    $serverFile = Join-Path $GameDir "server.ps1"
    $currentVersion = "v0.0_Beta"
    if (Test-Path $serverFile) {
        $vLine = Get-Content -Path $serverFile | Select-String '\$global:version\s*=\s*"([^"]+)"'
        if ($vLine) {
            $currentVersion = $vLine.Matches.Groups[1].Value
        }
    }
    
    $apiUrl = "https://api.github.com/repos/DoctorQwack/Obliterate-Everything-3-Offline/releases/latest"
    try {
        $res = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "OE3-Updater" }
    } catch {
        Write-Host "Failed to query GitHub API: $_" -ForegroundColor Red
        Read-Host "Press Enter to exit..."
        exit 1
    }
    
    $latestVersion = $res.tag_name
    Write-Host "Current version: $currentVersion"
    Write-Host "Latest version:  $latestVersion" -ForegroundColor Green
    
    $force = $false
    if ($currentVersion -eq $latestVersion) {
        Write-Host "You are already up to date!" -ForegroundColor Green
        $choice = Read-Host "Do you want to re-install/force update anyway? (y/n)"
        if ($choice -ne "y") {
            exit 0
        }
        $force = $true
    } else {
        Write-Host "New version $latestVersion is available!" -ForegroundColor Yellow
        $choice = Read-Host "Do you want to download and install this update? (y/n, default y)"
        if ($choice -eq "n") {
            exit 0
        }
    }
    
    # Copy self to Temp folder and launch from there
    Write-Host "`nRelocating updater to temporary directory to prevent file locks..." -ForegroundColor Gray
    Copy-Item -Path (Join-Path $GameDir $scriptName) -Destination $tempScript -Force
    
    # Launch new process and exit
    $argsList = "-NoProfile -ExecutionPolicy Bypass -File `"$tempScript`" -GameDir `"$GameDir`""
    if ($force) { $argsList += " -Force" }
    Start-Process -FilePath "powershell.exe" -ArgumentList $argsList
    exit 0
}

# --- RUNNING FROM TEMP DIRECTORY ---

Write-Host "=========================================" -ForegroundColor Green
Write-Host "    OE3 Offline Updater (Running)        " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Game Directory: $GameDir" -ForegroundColor Cyan

# 1. Wait for game server/launcher to close
Write-Host "`nPlease close the game server (terminal window) and the game window if open." -ForegroundColor Yellow
Write-Host "Waiting for running instances to close..." -ForegroundColor Gray

while ($true) {
    $locked = $false
    $testFiles = @("server.ps1", "Launch OE3 Offline.bat", "OE3_UPDATED.swf", "flashplayer.exe", "ruffle.exe")
    foreach ($tf in $testFiles) {
        $p = Join-Path $GameDir $tf
        if (Test-Path $p) {
            try {
                $fileStream = [System.IO.File]::Open($p, 'Open', 'Write', 'None')
                $fileStream.Close()
            } catch {
                $locked = $true
                break
            }
        }
    }
    
    if (-not $locked) {
        break
    }
    
    Write-Host "." -NoNewline -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}
Write-Host "`nAll instances closed. Proceeding with update." -ForegroundColor Green

# 2. Query latest asset
$apiUrl = "https://api.github.com/repos/DoctorQwack/Obliterate-Everything-3-Offline/releases/latest"
$res = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "OE3-Updater" }
$latestVersion = $res.tag_name

# Determine if converter files exist (Legacy saves edition)
$isLegacyEdition = Test-Path (Join-Path $GameDir "converter.html")

$downloadUrl = $null
$filename = $null
foreach ($asset in $res.assets) {
    if ($isLegacyEdition) {
        if ($asset.name -like "*Legacy_Saves_Included.zip") {
            $downloadUrl = $asset.browser_download_url
            $filename = $asset.name
            break
        }
    } else {
        if ($asset.name -like "*Release.zip" -and $asset.name -notlike "*Legacy_Saves_Included.zip") {
            $downloadUrl = $asset.browser_download_url
            $filename = $asset.name
            break
        }
    }
}

if ($null -eq $downloadUrl) {
    $downloadUrl = $res.assets[0].browser_download_url
    $filename = $res.assets[0].name
}

Write-Host "Downloading: $filename..." -ForegroundColor Cyan
$tempZip = Join-Path $env:TEMP $filename
if (Test-Path $tempZip) { Remove-Item $tempZip -Force | Out-Null }

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip
} catch {
    Write-Host "Failed to download update: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "Extracting update package..." -ForegroundColor Cyan
$tempExtract = Join-Path $env:TEMP "oe3_extract"
if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force | Out-Null }
New-Item -ItemType Directory -Path $tempExtract | Out-Null

try {
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
} catch {
    Write-Host "Failed to extract update package: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "Applying update files..." -ForegroundColor Gray
Get-ChildItem -Path $tempExtract -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Substring($tempExtract.Length + 1)
    $destPath = Join-Path $GameDir $relativePath
    
    $isSaves = ($relativePath -like "saves*" -or $relativePath -eq "saves")
    $isConfig = ($relativePath -eq "config.json")
    
    if (-not $isSaves -and -not $isConfig) {
        if ($_.PSIsContainer) {
            if (-not (Test-Path $destPath)) {
                New-Item -ItemType Directory -Path $destPath | Out-Null
            }
        } else {
            Copy-Item -Path $_.FullName -Destination $destPath -Force
        }
    }
}

# Clean up temp
Remove-Item $tempZip -Force | Out-Null
Remove-Item $tempExtract -Recurse -Force | Out-Null
Remove-Item $MyInvocation.MyCommand.Path -Force | Out-Null

Write-Host "`nSUCCESS! Obliterate Everything 3 has been updated to $latestVersion!" -ForegroundColor Green
Write-Host "Restarting game launcher..." -ForegroundColor Cyan
Start-Sleep -Seconds 2

# Launch the game batch file again
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$GameDir\Launch OE3 Offline.bat`"" -WorkingDirectory $GameDir
exit 0
