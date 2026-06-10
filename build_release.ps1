$dir = $PSScriptRoot
if (-not $dir) { $dir = Get-Location }
$dir = $dir.ToString().TrimEnd('\')

$source = Join-Path $dir "OE3_Updated_Offline"
$dest = Join-Path $dir "OE3_Offline_Release.zip"
$temp = Join-Path $dir "temp_release"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "   Building OE3 Offline Release Zip...   " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

if (-not (Test-Path $source)) {
    Write-Host "ERROR: Source directory '$source' not found!" -ForegroundColor Red
    exit 1
}

# Clean old temp dir if exists
if (Test-Path $temp) {
    Remove-Item -Path $temp -Recurse -Force | Out-Null
}

# Create temp release folder structure
New-Item -ItemType Directory -Path $temp | Out-Null
New-Item -ItemType Directory -Path (Join-Path $temp "saves") | Out-Null

Write-Host "Copying distribution files..." -ForegroundColor Gray

# Copy only distribution files (exclude user saves and runtime logs)
Get-ChildItem -Path $source | ForEach-Object {
    $name = $_.Name
    if ($name -ne "saves" -and $name -ne "log.txt") {
        Copy-Item -Path $_.FullName -Destination (Join-Path $temp $name) -Recurse -Force
    }
}

# Remove old output zip if exists
if (Test-Path $dest) {
    Remove-Item -Path $dest -Force | Out-Null
}

Write-Host "Zipping package to OE3_Offline_Release.zip..." -ForegroundColor Gray
Compress-Archive -Path (Join-Path $temp "*") -DestinationPath $dest -Force

# Clean up temp files
Remove-Item -Path $temp -Recurse -Force | Out-Null

Write-Host "SUCCESS: Release package built at '$dest'." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
