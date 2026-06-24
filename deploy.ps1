# 1. Build the Flutter web app for production
Write-Host "Building Flutter Web application..." -ForegroundColor Green
flutter build web --release -t lib/main_production.dart --base-href="/user/" --dart-define=APP_ENV=production

# 2. Navigate to the build output
cd build/web

# 3. Create .htaccess file if it doesn't exist
if (-not (Test-Path .htaccess)) {
    @'
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /user/
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /user/index.html [L]
</IfModule>
'@ | Out-File -FilePath .htaccess -Encoding ascii
}

# 4. Initialize temporary Git repo in the build folder and push to release-web
git init
git checkout -b release-web
git remote add origin https://github.com/aswinadi/flutter_warehouse.git
git add .
git commit -m "Deploy update: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git push origin release-web -f

# 5. Return to project root
cd ../..
Write-Host "Build pushed successfully to branch 'release-web'! Now pull on your server." -ForegroundColor Green
