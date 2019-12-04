# Pantheon@openSUSE

### Prereq: (stable repo)  
`zypper addrepo --refresh https://download.opensuse.org/repositories/X11:Pantheon:Branch/openSUSE_Tumbleweed/X11:Pantheon:Branch.repo`  
`zypper refresh`

### Option:
1. Complete elementary experience:  
   1. Base installation:  
`zypper install -t pattern pantheon`  
   2. Add gnome tweakability:  
`zypper in -t pattern gnome_basis`  
`zypper in libreoffice-gtk3 gnome-{disk-utility,online-accounts,tweaks}`  

2. Append Fully functional pantheon-session over existing gnome installation:  
`zypper install -t pattern pantheon_basis`  
`zypper install pantheon-terminal`  

### Beware:  
- `pantheon-files` does not have batch-rename
- '[No Title Bar]' or '[GTK Title Bar]' must be enabled/configured from a gnome session

### Cleanup:  
/usr/share/glib-2.0/schemas> grep -iR "close:" ./  

must edit both files (& glib-compile-schemas & reboot) for desired effect as of 2019/11/27  
pantheon-settings-daemon-openSUSE-branding.gschema.override  
pantheon-desktop-schemas-openSUSE-branding.gschema.override  

# nmcli-wifi-crasher
Because you might need wifi before you have a graphical desktop

`nmcli d|device` #lists devices  
`nmcli r|radio wifi` #queries wifi radio state  
`nmcli r wifi on` #turns wifi radio on if needed  
`nmcli d wifi list` #lists available networks via ssid  
`sudo nmcli --ask d wifi connect <ssid>` #negotiates connection (asks for password) using credentials supplied  
`sudo nmcli d wifi connect <ssid> password <mypassword>` #negotiates connection using the credentials supplied  


[nmcli-wifi-tutorial 'kifarunix'](https://kifarunix.com/connect-to-wifi-in-linux-using-nmcli-command/)  
[nmcli-wifi-tutorial 'ubuntu'](https://docs.ubuntu.com/core/en/stacks/network/network-manager/docs/configure-wifi-connections)  

\[ [Original pantheNOT ~~struggle~~ documentation](pantheNOT/README.md) \]

[No Title Bar]:https://extensions.gnome.org/extension/2015/no-title-bar-forked/
[GTK Title Bar]:https://extensions.gnome.org/extension/1732/gtk-title-bar/
