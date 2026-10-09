-- Shows the emoji replacement state and turns it on or off with emoji-replacement.sh.
property appTitle : "WhatsApp Emoji Replacement Fixer"

set toggleScript to quoted form of POSIX path of (path to resource "emoji-replacement.sh")

try
	set state to do shell script "/bin/sh " & toggleScript & " status"
on error errorText
	display alert appTitle message errorText as critical
	return
end try

if state is "on" then
	set question to "Emoji replacement is ON: WhatsApp changes :D and :) to emoji." & return & return & "Turn it off? WhatsApp quits and opens again."
	set actionButton to "Turn Off"
	set command to "off"
else
	set question to "Emoji replacement is OFF: :D and :) stay as text." & return & return & "Turn it on again? WhatsApp quits and opens again."
	set actionButton to "Turn On"
	set command to "on"
end if

-- The Cancel button stops the script.
display dialog question buttons {"Cancel", actionButton} default button actionButton with title appTitle

try
	do shell script "/bin/sh " & toggleScript & " " & command
on error errorText
	display alert appTitle message errorText as critical
	return
end try

if command is "off" then
	display dialog "Done. Emoji replacement is OFF." buttons {"OK"} default button "OK" with title appTitle
else
	display dialog "Done. Emoji replacement is ON." buttons {"OK"} default button "OK" with title appTitle
end if
