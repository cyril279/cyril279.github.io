# Printers
Finding and using them on immutable distributions

## Overview
1. Setup printer via CUPS  
2. Use flatseal to ensure that flatpak apps use cups for printing  

## Challenge (& solution)
Gnome does a great job of finding network printers, but flatpaks can't print to the printer installed by GNOME.  
I have not been successful in using flatseal to manipulate each flatpak app to be able to have access to our network printer.  

The remaining options were:  

1) Have the flatpak print-to-pdf (or download)  
which allows me to print from the filesystem.  
(works, but cumbersome)
2) Configure the print-server CUPS to handle the printing **<-Winner!**  
which the flatpaks all seem to play-well-with.  

## CUPS

### Access:
The admin page of the cups interface (`localhost:631/admin`) is how printers are added and managed via cups, and typically requires a login.  
Many systems default to allowing members of the `root`, `sys`, and `wheel` groups to log into the cups admin page, but some require additional configuration before a user login is permitted.  

### Configuration 01:
```sh
/etc/cups/cups-files.conf
--------------------
SystemGroup root wheel
```

### Configuration 02:
```sh
# Create a group specifically for printer administration
sudo groupadd -g 999 lpadmin

# Append 'lpadmin' group to someUser
sudo usermod -aG lpadmin someUser
```
```sh
/etc/cups/cups-files.conf
--------------------
SystemGroup root wheel lpadmin
```

### Final steps:
- Log into `localhost:631/admin` with my user credentials
- Add a printer:
  - driverless config for hp envy 4520
  - socket://192.168.9.212:9100

## Flatseal
Use as needed to direct apps to the cups socket.

## References
CUPS config file editing learned from the [archWiki for CUPS](https://wiki.archlinux.org/title/CUPS#Groups)