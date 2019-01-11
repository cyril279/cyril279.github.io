
# Cross-Platform Remote-Effort

**Goal:**
One Harmony activity, Same media-center software (kodi), two different Operating Systems.

**Challenge:**
Kodi commands are the same across platforms, but sleep/suspend command is not the same.
A range of MCE-IR commands are not interpreted on linux without trickery.

**Solution:**
Since sleep/suspend command is different for each platform, final interpretation of the sleep/suspend instruction must occur within each platform (remote and Flirc are common to both platforms).
**FLIRC** translates **MCE-IR signals** (some of which are not recognized by linux/kodi), into **keystrokes** that are readily interpreted by all.
This eliminates the need for unique harmony devices, and trickery.

remote sends ir-command 
flirc translates ir-command to keystroke
OS translates keystroke to os-specific suspend/sleep command
-- OR --
kodi keymap translates keystroke to app-specific suspend/sleep command
Proof of concept:
[Kodi harmony flirc power issue (2015)](http://forum.flirc.tv/index.php?/topic/1997-flirc-harmony-kodi-and-suspend/)


### Suspend
**Definitions:**
```
[keystroke] := alt+backslash
[suspend command, linux] := systemctl suspend
[suspend command, windows] := %windir%\System32\rundll32.exe powrprof.dll,SetSuspendState 0,1,0
```

FLIRC sends keystroke, os interprets keystroke appropriately
This suspends the system without regard for what app is focused, and is therefore the preferred method.

### Assign [suspend command] to [keystroke]
**Gnome:**
settings > devices > keyboard
[keystroke] := [suspend command, linux]
**Windows:**
create shortcut in user’s desktop
enter [suspend command, windows] as location of item
assign [keystroke] to ‘shortcut key’ of shortcut
**kodi:**
This will only suspend a system if kodi is the focused application, but is cross-platform functional.
create entry in keymap.xml, assigning [keystroke] to (kodi’s) sleep function:
**userdata\keymaps\keymap.xml**
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
### Flirc & Harmony
**Harmony software:**
Setup activity to use Flirc,TV,& AVR
ensure that flirc-power-off command has been assigned to a button
devices > FLIRC Media player > Settings > adjust power settings > 
[ I want to turn off this device when it’s not in use ]
[ One button on the remote for turning it both On and Off ]
[ I don't have the original remote, but I know the command that is used: PowerOff ]
**Flirc:**
link Flirc’s [power-off] signal to [keystroke]
### Un-explored:
**power_mce:**
If existing MCE remote power button works with mce-ir receiver:
harmony software: assign new power step [mce po
Determine what the keyboard power button is outputting (using ‘xev’?)
xev -event keyboard
**power_keyboard:**
Determine what the keyboard (logitech k400) power button is outputting (using ‘xev’?)
xev -event keyboard
link the command to a keystroke via kodi keymap file.
**Notes:**
Flirc, 2nd gen user guide
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
Flirc:kodi  

### Other:
kodi doesn’t respond to some rc6 commands because they are broadcast beyond kodi’s ir spectrum.  
The easy route is [FLIRC], which internally translates the ir codes, and output’s them to the PC as standard keyboard codes (super universal). Also, with Flirc & harmony remote, I am freed from rc6/kodi/linux incompatibilities.  
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
  - https://flirc.tv/downloads
  - [Harmony](https://support.myharmony.com/en-in/harmony-experience-with-kodi) :: mfg: Flirc model: Kodi
  - power-off :: [source1] :: [source2]

[FLIRC]: https://flirc.tv/downloads
[old un-supported software]: https://forum.kodi.tv/showthread.php?tid=164252
[other list of hacky options]: https://forum.kodi.tv/showthread.php?tid=285623&pid=2388566#pid2388566
[source1]: https://support.flirc.tv/hc/en-us/articles/200904676-Getting-flirc-to-wake-up-your-computer
[source2]: https://community.logitech.com/s/question/0D53100005r8PXhCAM/harmony-650-and-flirckodi-media-pc-cant-switch-pc-onoff

