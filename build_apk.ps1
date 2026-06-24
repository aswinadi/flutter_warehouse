param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev", "prod", "both")]
    [string]$env = "both"
)

# Helper function to check and copy APK to root directory
function Copy-ApkToRoot($flavor, $targetName) {
    $sourcePath = "build/app/outputs/flutter-apk/app-$flavor-release.apk"
    if (Test-Path $sourcePath) {
        $destPath = "./$targetName.apk"
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "Success! APK copied to project root: $destPath" -ForegroundColor Cyan
    } else {
        Write-Host "Error: Could not find compiled APK at $sourcePath" -ForegroundColor Red
    }
}

# Build Development APK
if ($env -eq "dev" -or $env -eq "both") {
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host "Building Development APK (Flavor: development)..." -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green
    
    flutter build apk --flavor development -t lib/main_development.dart --dart-define=APP_ENV=development
    Copy-ApkToRoot "development" "warehouse-dev"
}

# Build Production APK
if ($env -eq "prod" -or $env -eq "both") {
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host "Building Production APK (Flavor: production)..." -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green
    
    flutter build apk --flavor production -t lib/main_production.dart --dart-define=APP_ENV=production
    Copy-ApkToRoot "production" "warehouse-prod"
}
