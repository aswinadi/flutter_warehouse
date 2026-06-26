param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev", "prod", "both")]
    [string]$env = "both"
)

# Helper function to check, copy, rename, and zip Windows build to root directory
function Copy-WindowsBuildToRoot($targetName) {
    $sourcePath = "build/windows/x64/runner/Release"
    if (Test-Path $sourcePath) {
        $destDirName = "$targetName-windows"
        $destPath = "./$destDirName"
        $zipPath = "./$destDirName.zip"

        # Clean existing folder
        if (Test-Path $destPath) {
            Write-Host "Cleaning existing directory: $destPath..." -ForegroundColor Yellow
            Remove-Item -Path $destPath -Recurse -Force
        }
        # Clean existing zip
        if (Test-Path $zipPath) {
            Write-Host "Cleaning existing ZIP: $zipPath..." -ForegroundColor Yellow
            Remove-Item -Path $zipPath -Force
        }

        # Create destination directory
        New-Item -ItemType Directory -Path $destPath -Force | Out-Null

        # Copy build contents
        Write-Host "Copying build files to $destPath..." -ForegroundColor Yellow
        Copy-Item -Path "$sourcePath\*" -Destination $destPath -Recurse -Force

        # Rename executable to warehouse.exe for a cleaner presentation
        $exeFile = Get-ChildItem -Path $destPath -Filter "*.exe" | Select-Object -First 1
        if ($exeFile) {
            Write-Host "Renaming executable $($exeFile.Name) to warehouse.exe..." -ForegroundColor Yellow
            Rename-Item -Path $exeFile.FullName -NewName "warehouse.exe" -Force
        }

        # Create ZIP archive for distribution (using resolved absolute paths for robustness)
        Write-Host "Creating ZIP archive: $zipPath..." -ForegroundColor Yellow
        $resolvedDestPath = (Resolve-Path $destPath).Path
        $resolvedZipPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($zipPath)
        Compress-Archive -Path "$resolvedDestPath\*" -DestinationPath $resolvedZipPath -Force

        Write-Host "Success! Build package created:" -ForegroundColor Cyan
        Write-Host " - Folder: $destPath" -ForegroundColor Cyan
        Write-Host " - ZIP:    $zipPath" -ForegroundColor Cyan
    } else {
        Write-Host "Error: Could not find compiled Windows build at $sourcePath" -ForegroundColor Red
    }
}

# Build Development Desktop App
if ($env -eq "dev" -or $env -eq "both") {
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host "Building Development Windows App..." -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green
    
    flutter build windows -t lib/main_development.dart --dart-define=APP_ENV=development
    Copy-WindowsBuildToRoot "warehouse-dev"
}

# Build Production Desktop App
if ($env -eq "prod" -or $env -eq "both") {
    Write-Host "==============================================" -ForegroundColor Green
    Write-Host "Building Production Windows App..." -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green
    
    flutter build windows -t lib/main_production.dart --dart-define=APP_ENV=production
    Copy-WindowsBuildToRoot "warehouse-prod"
}
