$dir = $PSScriptRoot
if (-not $dir) { $dir = Get-Location }
$dir = $dir.ToString().TrimEnd('\')

$source = Join-Path $dir "OE3_Updated_Offline"
$destStandard = Join-Path $dir "OE3_Offline_Release.zip"
$destLegacy = Join-Path $dir "OE3_Offline_Release_Legacy_Saves_Included.zip"
$temp = Join-Path $dir "temp_release"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "   Building OE3 Offline Release Zips...  " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

if (-not (Test-Path $source)) {
    Write-Host "ERROR: Source directory '$source' not found!" -ForegroundColor Red
    exit 1
}

# --- BUILD STANDARD VERSION ---
Write-Host "`n--- BUILDING STANDARD RELEASE (No Legacy Database or Converter) ---" -ForegroundColor Cyan

# Clean old temp dir if exists
if (Test-Path $temp) { Remove-Item -Path $temp -Recurse -Force | Out-Null }
New-Item -ItemType Directory -Path $temp | Out-Null
New-Item -ItemType Directory -Path (Join-Path $temp "saves") | Out-Null

Write-Host "Copying standard files..." -ForegroundColor Gray
Get-ChildItem -Path $source | ForEach-Object {
    $name = $_.Name
    $isSavesOrLog = ($name -eq "saves" -or $name -eq "log.txt" -or $name -eq "server.ps1")
    $isConverterFile = ($name -eq "converter.html" -or $name -eq "generate_index.py" -or $name -eq "convert_save.py" -or $name -eq "legacy_index.json" -or $name -eq "index_status.json")
    
    if (-not $isSavesOrLog -and -not $isConverterFile) {
        Copy-Item -Path $_.FullName -Destination (Join-Path $temp $name) -Recurse -Force
    }
}

if (Test-Path $destStandard) { Remove-Item -Path $destStandard -Force | Out-Null }
Write-Host "Zipping Standard package to OE3_Offline_Release.zip..." -ForegroundColor Gray
Compress-Archive -Path (Join-Path $temp "*") -DestinationPath $destStandard -Force


# --- BUILD LEGACY VERSION ---
Write-Host "`n--- BUILDING LEGACY RELEASE (With Legacy Database & Converter) ---" -ForegroundColor Cyan

# Clean old temp dir if exists
if (Test-Path $temp) { Remove-Item -Path $temp -Recurse -Force | Out-Null }
New-Item -ItemType Directory -Path $temp | Out-Null
New-Item -ItemType Directory -Path (Join-Path $temp "saves") | Out-Null

Write-Host "Copying standard files + converter files..." -ForegroundColor Gray
Get-ChildItem -Path $source | ForEach-Object {
    $name = $_.Name
    # Exclude only saves, log, and server.ps1 (include converter files)
    if ($name -ne "saves" -and $name -ne "log.txt" -and $name -ne "server.ps1") {
        Copy-Item -Path $_.FullName -Destination (Join-Path $temp $name) -Recurse -Force
    }
}

Write-Host "Copying Legacy Database folder..." -ForegroundColor Gray
$dbSource = Join-Path $dir "Legacy Save Files"
if (Test-Path $dbSource) {
    Copy-Item -Path $dbSource -Destination (Join-Path $temp "Legacy Save Files") -Recurse -Force
} else {
    Write-Host "WARNING: 'Legacy Save Files' folder not found in parent directory. Legacy database could not be copied." -ForegroundColor Yellow
}

if (Test-Path $destLegacy) { Remove-Item -Path $destLegacy -Force | Out-Null }
Write-Host "Zipping Legacy package to OE3_Offline_Release_Legacy_Saves_Included.zip..." -ForegroundColor Gray
Compress-Archive -Path (Join-Path $temp "*") -DestinationPath $destLegacy -Force


# Clean up temp files
if (Test-Path $temp) { Remove-Item -Path $temp -Recurse -Force | Out-Null }

Write-Host "`nSUCCESS: Both release packages built successfully!" -ForegroundColor Green
Write-Host "  Standard:  $destStandard" -ForegroundColor Green
Write-Host "  Legacy:    $destLegacy" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
