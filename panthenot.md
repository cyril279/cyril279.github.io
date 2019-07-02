# Panthenot?
Gnome, but modularized. (but messy)

two approaches:
1. Use gala over an xfce session, and work out the kinks.  
  -works, but scattered/layered settings, resulting in unpredictable desktop.  
1. Use pantheon over a gnome installation (and work out the kinks)  
  -a fair bit of setup/cleanup, but nice results so far.

## Gnome (oS Tumbleweed) <- showing promise 2019/06/25
***Note*** must use NetworkManager, not wicked. else, wingpanel crashes, or `zypper rm wingpanel-indicator-network`
```
zypper ar http://download.opensuse.org/repositories/X11:/Pantheon/openSUSE_Tumbleweed/ pantheon
zypper in patterns-pantheon-pantheon_{basis,multimedia} xscreensaver {elementary-plus,papirus}-icon-theme 
zypper in --no-recommends sddm
```
### SDDM themes from the interwebs

```
dnf in qt5-qtquickcontrols{,2}  
sudo tar -xzvf ~Downloads/<filename.tar.gz> -C /usr/share/sddm/themes  
vi /etc/sddm.conf -> [Theme] -> Current=<filename>  
sddm-greeter --test-mode --theme /usr/share/sddm/themes/breeze
```
_/etc/sddm.conf_
```
[General]
Numlock=on
[Theme]
ThemeDir=/usr/share/sddm/themes
Current=Lime-Green-v.2
```
_/usr/share/sddm/themes/Lime-Green-v.2/theme.conf.user_
```
[General]
type=image
Background="/usr/share/backgrounds/Pablo Garcia Saldana.jpg"
DateFormat="yyyy, dddd MMMM d"
HeaderText="just say yes >:)"
```
need an example config file?
```
sddm --example-config > sddm.conf.example
```
### cleanup via gschema override for cross-user effect
00_org.panthenot.theme.gschema.override  
```
[org.gnome.desktop.interface:Pantheon]
cursor-theme='Adwaita'
gtk-theme='elementary'
icon-theme='elementary'

[org.pantheon.desktop.gala.appearance:Pantheon]
button-layout='menu:close'

[net.launchpad.plank.dock.settings:Pantheon]
theme='elementary'
```
00_org.gnome.theme.gschema.override
```
[org.gnome.desktop.interface:GNOME]
cursor-theme='DMZ-White'
gtk-theme='Adwaita'
icon-theme='Paper'
```
## Gnome (Fedora workstation) <- best to date 2019/06/23
The best of pantheon without the intrusive elementary overrides
```
dnf install pantheon-session-settings switchboard{,-plug*} elementary-sound-theme elementary-wallpapers-gnome tilix dconf-editor xscreensaver gedit-plugin-{drawspaces,git} sddm {paper,papirus,elementary,elementary-xfce}-icon-theme
```
## xfce (openSUSE TW)
Add the pantheon repository  
`zypper ar http://download.opensuse.org/repositories/X11:/Pantheon/openSUSE_Tumbleweed/ pantheon`

zypper in gala plank gnome-settings-daemon gnome-disk-utility nautilus tilix dconf-editor

flatpak install org.gnome.gedit org.gnome.Calendar org.gnome.Evince org.gnome.gitg org.gnome.Boxes io.github.GnomeMpv org.gnome.Music org.gnome.Podcasts org.gnome.Photos io.elementary.code 

replace xfwm with gala  
`gala --replace &`  
good? then save the session  
settings manager > session and startup > session > gala [Restart Style=Immediately]  
[save session]  
switch to `[Application Autostart]` tab, add `plank` to the list

## ulauncher
because using gala jacks-up use of the "super_L/R" as the launch hotkey (xfce)  
even beyond the xfce thing, this is nice.  
https://ulauncher.io/#Download

`zypper in python3-pyinotify typelib-1_0-Keybinder-3_0`  
Grab (& install) from ulauncher.io: `ulauncher_5.3.*_fedora29.rpm`  #using beta because stable release doesn't work on 20190607 Tumbleweed

`ctrl+Super_L` to actuate ulauncher  

## xscreensaver
startup -> `xscreensaver -nosplash` (or -no-splash)  
& configure via the app.

