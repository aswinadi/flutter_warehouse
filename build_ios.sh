#!/usr/bin/env bash

# Build script for iOS Release bundle (IPA)

set -e

echo "=== Building Maxmar Warehouse for iOS ==="

# 1. Fetch Flutter dependencies
echo "Fetching Flutter dependencies..."
flutter pub get

# 2. Update CocoaPods dependencies
echo "Installing CocoaPods dependencies..."
cd ios
pod install
cd ..

# 3. Clean build directory
echo "Cleaning Flutter project..."
flutter clean
flutter pub get

# 4. Build iOS IPA release
echo "Building IPA release package..."
flutter build ipa --release --dart-define=APP_ENV=production

echo "=== Build Complete! ==="
echo "IPA build output location: build/ios/ipa/"
echo "You can now upload the .ipa file using Xcode Organizer or Apple Transporter app."
