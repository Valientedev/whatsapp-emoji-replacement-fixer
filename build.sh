#!/bin/sh
# Builds "WhatsApp Emoji Replacement Fixer.app" and the zip for a GitHub release.
set -eu
cd "$(dirname "$0")"

APP="build/WhatsApp Emoji Replacement Fixer.app"
PLIST="$APP/Contents/Info.plist"

rm -rf build
mkdir -p build
osacompile -o "$APP" src/main.applescript
cp src/emoji-replacement.sh "$APP/Contents/Resources/"
plutil -replace CFBundleIdentifier -string "io.github.valientedev.whatsapp-emoji-replacement-fixer" "$PLIST"
plutil -replace CFBundleShortVersionString -string "1.0.0" "$PLIST"
plutil -replace NSAppleEventsUsageDescription -string "The app quits WhatsApp and opens it again, so that WhatsApp reads the new setting." "$PLIST"
xattr -cr "$APP"
codesign --force --deep --sign - "$APP"
ditto -c -k --norsrc --keepParent "$APP" "build/WhatsApp-Emoji-Replacement-Fixer.zip"
echo "Built $APP and build/WhatsApp-Emoji-Replacement-Fixer.zip"
