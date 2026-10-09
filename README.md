# WhatsApp Emoji Replacement Fixer

A small macOS app that turns off the automatic emoji replacement in WhatsApp for Mac.

When the replacement is on, WhatsApp changes `:D` to 😃 and `:)` to 🙂 when you type them. WhatsApp has a setting for this, but its menu item (Edit > Substitutions > Emoji replacement) is hidden.

This project is not affiliated with WhatsApp or Meta.

## Install

1. Download `WhatsApp-Emoji-Replacement-Fixer.zip` from the [latest release](../../releases/latest).
2. Unzip it and move `WhatsApp Emoji Replacement Fixer.app` to the Applications folder.
3. Open the app.

### First launch

Apple did not notarize the app, so macOS blocks it the first time:

1. Open the app. macOS shows a warning. Click **Done**.
2. Open **System Settings > Privacy & Security**.
3. Scroll down and click **Open Anyway** for `WhatsApp Emoji Replacement Fixer`.

macOS can also ask you to let the app control WhatsApp. Click **Allow**. The app uses this permission only to quit WhatsApp and open it again, so that WhatsApp reads the new setting.

## Use

Open the app. It shows the current state and turns the emoji replacement off or on.

## Use from the Terminal

Run the script from this repository:

```sh
sh src/emoji-replacement.sh status   # shows "on" or "off"
sh src/emoji-replacement.sh off      # :D stays as text
sh src/emoji-replacement.sh on       # :D changes to an emoji again
```

## How it works

WhatsApp saves the setting `disableAutomaticEmojiReplacement` under the short key `daer`, in this file:

```
~/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/Library/Preferences/group.net.whatsapp.WhatsApp.shared.plist
```

To turn the replacement off, the app sets `daer` to `true`. To turn it on again, the app deletes `daer`.

The app reads the short key from the WhatsApp app files each time. If a WhatsApp update changes the key, the app finds the new one. If WhatsApp removes the setting, the app shows "This WhatsApp version is not supported."

Tested with WhatsApp 26.35.74 on macOS 15.7.

## Build

```sh
./build.sh
```

The script writes the app and the zip to `build/`.

## License

[MIT](LICENSE)
