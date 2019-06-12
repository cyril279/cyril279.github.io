# Panthenot
Gnome, but modularized.

## mashup
starts with a complete gnome pattern  

Add the pantheon repository  
`zypper ar http://download.opensuse.org/repositories/X11:/Pantheon/openSUSE_Tumbleweed/ pantheon`
Add the necessary squishy bits  
```
sudo zypper in --no-recommends -t pattern xfce pantheon
zypper in gala plank xfce4-panel-plugin-pulseaudio switchboard* lightdm-gtk-greeter-settings
```

switch to xfce session:  
replace xfwm with gala
`gala --replace &`  
good? then save the session  
settings manager > session and startup > session > gala [Restart Style=Immediately]  
[save session]  
switch to `[Application Autostart]` tab, add `plank` to the list

## ulauncher
because using gala jacks-up use of the "super_L/R" as the launch hotkey

`zypper in python3-pyinotify python-keybinder`  
Grab (& install) from ulauncher.io: `ulauncher_5.3.*_fedora29.rpm`  #using beta because stable release doesn't work on 20190607 Tumbleweed

`ctrl+Super_L` actuates ulauncher  

## cleanup
vi org.pantheon.desktop.gala.gschema.xml
set 'button-layout' to 'menu:close' #ignores 'appmenu'
sudo glib-compile-schemas .

https://wilkiecat.wordpress.com/2013/10/22/how-do-i-add-os-elementary-to-xubuntu/  
https://ubuntuforums.org/archive/index.php/t-2117202.html 
https://unix.stackexchange.com/questions/316525/how-to-replace-xfce-window-manager-with-awesome   

## customization
hotcorner settings:
system settings > desktop > Hot Corners
