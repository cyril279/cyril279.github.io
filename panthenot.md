# Panthenot?
Gnome, but modularized. (but messy)

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

# Gnome (Fedora workstation) <- best by far
The best of pantheon without the intrusive elementary overrides

dnf install pantheon-session-settings switchboard{,-plug*} elementary{,-sound,-icon}-theme elementary-wallpapers-gnome tilix dconf-editor xscreensaver gedit-plugin-{drawspaces,git}

startup -> xscreensaver -no-splash  
& configure via the app.

## ulauncher
because using gala jacks-up use of the "super_L/R" as the launch hotkey

`zypper in python3-pyinotify python-keybinder`  
Grab (& install) from ulauncher.io: `ulauncher_5.3.*_fedora29.rpm`  #using beta because stable release doesn't work on 20190607 Tumbleweed

`ctrl+Super_L` actuates ulauncher  

## cleanup
vi org.pantheon.desktop.gala.gschema.xml  
set 'button-layout' to 'menu:close' #ignores 'appmenu'?  
sudo glib-compile-schemas .  

org.pantheon.desktop.gala.gschema.xml  
org.gnome.desktop.preferences...  
