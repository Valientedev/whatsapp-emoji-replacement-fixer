#!/bin/sh
# Turns WhatsApp for Mac's automatic emoji replacement (":D" -> emoji) on or off.
# Usage: emoji-replacement.sh status | off | on
set -eu

APP_ID="net.whatsapp.WhatsApp"
PREFS="$HOME/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/Library/Preferences/group.net.whatsapp.WhatsApp.shared"

fail() { echo "$1" >&2; exit 1; }

find_app() {
  for dir in /Applications "$HOME/Applications"; do
    if [ -d "$dir/WhatsApp.app" ]; then echo "$dir/WhatsApp.app"; return; fi
  done
  fail "WhatsApp is not installed in the Applications folder."
}

# WhatsApp saves each setting under a short key. The binary stores the
# setting name and its short key next to each other.
find_key() {
  modules="$1/Contents/Frameworks/SharedModules.framework/SharedModules"
  [ -f "$modules" ] || fail "This WhatsApp version is not supported."
  key=$(perl -0777 -ne 'print $1 if /disableAutomaticEmojiReplacement\0(\w{1,16})\0/' "$modules")
  [ -n "$key" ] || fail "This WhatsApp version is not supported."
  echo "$key"
}

is_running() { pgrep -x WhatsApp >/dev/null; }

# WhatsApp quits before the change and opens again after it, so that it
# reads the new value.
quit_app() {
  osascript -e "tell application id \"$APP_ID\" to quit" >/dev/null
  i=0
  while is_running; do
    i=$((i + 1))
    [ "$i" -le 40 ] || fail "WhatsApp did not quit. Quit it and try again."
    sleep 0.25
  done
}

APP=$(find_app)
KEY=$(find_key "$APP")

case "${1:-}" in
  status)
    if [ "$(defaults read "$PREFS" "$KEY" 2>/dev/null)" = "1" ]; then echo off; else echo on; fi
    ;;
  off|on)
    was_running=false
    if is_running; then was_running=true; quit_app; fi
    if [ "$1" = off ]; then
      defaults write "$PREFS" "$KEY" -bool true
    else
      defaults delete "$PREFS" "$KEY" 2>/dev/null || true
    fi
    if [ "$was_running" = true ]; then open -b "$APP_ID"; fi
    echo "$1"
    ;;
  *)
    fail "Usage: emoji-replacement.sh status | off | on"
    ;;
esac
