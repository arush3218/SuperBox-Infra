# Usage: .\package_lambda.ps1

Write-Host "Packaging Lambda function..." -ForegroundColor Cyan

# Navigate to project root
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$LambdaModule = Join-Path $ScriptDir "..\modules\lambda"

Write-Host "Project root: $ProjectRoot" -ForegroundColor Gray
Write-Host "Lambda module: $LambdaModule" -ForegroundColor Gray

# Create temporary directory
$TempDir = Join-Path $env:TEMP "lambda_package_$(Get-Random)"
New-Item -ItemType Directory -Path $TempDir | Out-Null
Write-Host "Temporary directory: $TempDir" -ForegroundColor Gray

# Copy lambda.py to temp directory
$LambdaSource = Join-Path $ProjectRoot "aws\lambda.py"
if (-not (Test-Path $LambdaSource)) {
    Write-Host "Error: lambda.py not found in aws folder" -ForegroundColor Red
    Remove-Item -Recurse -Force $TempDir
    exit 1
}

Copy-Item $LambdaSource $TempDir
Write-Host "[OK] Copied lambda.py" -ForegroundColor Green

# Create zip file
$ZipPath = Join-Path $TempDir "lambda_payload.zip"
Compress-Archive -Path (Join-Path $TempDir "lambda.py") -DestinationPath $ZipPath -Force
Write-Host "[OK] Created lambda_payload.zip" -ForegroundColor Green

# Move zip to lambda module
$LambdaModuleResolved = Resolve-Path (Join-Path $ScriptDir "..\modules\lambda")
if (-not (Test-Path $LambdaModuleResolved)) {
    New-Item -ItemType Directory -Path $LambdaModuleResolved -Force | Out-Null
}

$DestZip = Join-Path $LambdaModuleResolved "lambda_payload.zip"
Move-Item -Path $ZipPath -Destination $DestZip -Force
Write-Host "[OK] Moved to $DestZip" -ForegroundColor Green

# Cleanup
Remove-Item -Recurse -Force $TempDir
Write-Host "[OK] Cleaned up temporary files" -ForegroundColor Green

Write-Host ""
Write-Host "Lambda function packaged successfully!" -ForegroundColor Green
Write-Host "Location: $DestZip" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  cd $(Split-Path -Parent $ScriptDir)" -ForegroundColor Gray
Write-Host "  tofu init" -ForegroundColor Gray
Write-Host "  tofu plan" -ForegroundColor Gray
Write-Host "  tofu apply" -ForegroundColor Gray
