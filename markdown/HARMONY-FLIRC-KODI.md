
# Cross-Platform Remote-Effort

**Goal:**  
One Harmony activity, different desktop environments/sessions (Windows, Linux, & Kodi).  

**Challenge:**  
1. A range of MCE-IR commands are _not_ interpreted by linux or kodi without trickery.  
2. Sleep/suspend command is different for each desktop environment.  

**Solution:**  
1.  **FLIRC** translates **MCE-IR signals** into **keystrokes** that are readily interpreted by all.  
This eliminates the need for obscure harmony devices, and/or trickery.  
2. **Don't use any of the off-the-shelf ir shutdown commands**  
	a. Harmony sends ots [FLIRC-powerOff] ir-command  
	b. FLIRC translates ir-command to someKeystroke  
	c. desktop environment interprets someKeystroke to [appropriate suspend-command](#assign-suspend-command-to-keystroke-)  

Proof of concept:  
[Kodi harmony FLIRC power issue (2015)](http://forum.FLIRC.tv/index.php?/topic/1997-FLIRC-harmony-kodi-and-suspend/)  

### Definitions:
```
[suspend-keystroke] := alt+backslash
[suspend-command, linux] := systemctl suspend
[suspend-command, windows] := %windir%\System32\rundll32.exe powrprof.dll,SetSuspendState 0,1,0
```

### Assign [suspend command] to [keystroke]
**Gnome (& maybe Pantheon):**  
settings > devices > keyboard  
[suspend-keystroke] := [suspend-command, linux]  
**Windows:**  
create shortcut in user’s desktop  
enter [suspend-command, windows] as location of item  
assign [suspend-keystroke] to ‘shortcut key’ of shortcut  
**kodi:**  
This will only suspend a system if kodi is the focused application, but is cross-platform functional.  
create entry in keymap.xml, assigning [suspend-keystroke] to (kodi’s) sleep function.  
**Example:**  
_userdata\keymaps\keymap.xml_  
```sh
<?xml version="1.0" encoding="UTF-8"?>
<keymap>
  <global>
	<keyboard>
  	<backslash mod="alt">Suspend()</backslash>
  	<t mod="shift,alt">PlayPvrTV</t>
	</keyboard>
  </global>
</keymap>
```
### FLIRC & Harmony
**MyHarmony:**  
- Setup activity to use FLIRC,TV,& AVR  
- Assign FLIRC-power-off command to a button    
- Ensure that FLIRC-device issues [suspend-command] at both power on AND off (suspend command is also used to awaken the system)
```
devices > FLIRC > Change Device Settings > Power Settings >  
[ I want to turn off this device when it’s not in use ]  
[ One button on the remote for turning it both On and Off ]  
[ I don't have the original remote, but I know the command that is used: PowerOff ]  
```
reduce (eliminate) [command repeats](https://support.myharmony.com/en-us/adjusting-a-devices-command-repeats#myharmony) for FLIRC-device  
```
devices > FLIRC > Change Device Settings > Device command repeats > set to `0`  
```
[repeat-key-presses Method for other software](https://support.flirc.tv/hc/en-us/articles/203390449-Double-Key-Presses-with-Harmony-)  

**FLIRC:**  
link FLIRC’s [power-off] signal to [suspend-keystroke]  
### Notes:
**Un-explored:**  
Determine what the keyboard (logitech k400) power button is outputting (using ‘xev’?)  
xev -event keyboard  
link the command to a keystroke via kodi keymap file.  

**Notes:**  
[FLIRC, support](https://support.flirc.tv/hc/en-us)  
[other FLIRC support](https://flirc.gitbooks.io/flirc-instructions/)  
kodi shortcuts to use  

keystroke | function
:--: | :--:
p | play
space | play/pause
x | stop
e | epg
ctrl+r | record
h | channel list
c | context menu
i | info
k | pvr
0 (zero) | toggle last two channels
f | fast forward
r | rewind
backspace | back

**find usb keyboard id’s**  
https://superuser.com/a/552026  
**WMC shortcuts**  
https://technet.microsoft.com/en-us/library/ff404226.aspx  
http://tweaks.com/windows/39108/windows-media-center-keyboard-shortcuts/  
https://www.simplehelp.net/2008/06/18/42-keyboard-shortcuts-for-controlling-windows-media-center/  
**Devices to use with Harmony**  
anyware:gp-ir02bk (mce remote)  
FLIRC:kodi  

### Other:
kodi doesn’t respond to some rc6 commands because they are broadcast beyond kodi’s ir spectrum.  
The easy route is [FLIRC], which internally translates the ir codes, and output’s them to the PC as standard keyboard codes (super universal). Also, with FLIRC & harmony remote, I am freed from rc6/kodi/linux incompatibilities.  
Regarding Windows, getting Kodi to see the missing rc6 codes directly involves a registry hack, and some [old un-supported software] “Advanced MCE Remote Mapper Tool”.  
*[other list of hacky options]  
Regarding Linux, there’s a [dance with ir-keytables and some services.](https://forum.kodi.tv/showthread.php?tid=255465&pid=2221301#pid2221301)  

- using keyboard.xml
  - [keyboard.xml with remotes](https://kodi.wiki/view/keymap#Remotes)
  - [keymap.xml](https://kodi.wiki/view/keymap)
  - [sample](https://kodi.wiki/view/Sample_MCE_remote_keyboard.xml)
  - [how-to walk-through](https://kodi.wiki/view/HOW-TO:Modify_keymaps#Where_to_find_keyboard.xml)
  - [keymaps for most remotes](https://kodi.wiki/view/Alternative_keymaps_for_most_remotes)
**OR**
- FLIRC
  - https://FLIRC.tv/downloads
  - [Harmony](https://support.myharmony.com/en-in/harmony-experience-with-kodi) :: mfg: FLIRC model: Kodi
  - power-off :: [source1] :: [source2]

[FLIRC]: https://FLIRC.tv/downloads
[old un-supported software]: https://forum.kodi.tv/showthread.php?tid=164252
[other list of hacky options]: https://forum.kodi.tv/showthread.php?tid=285623&pid=2388566#pid2388566
[source1]: https://support.FLIRC.tv/hc/en-us/articles/200904676-Getting-FLIRC-to-wake-up-your-computer
[source2]: https://community.logitech.com/s/question/0D53100005r8PXhCAM/harmony-650-and-FLIRCkodi-media-pc-cant-switch-pc-onoff

