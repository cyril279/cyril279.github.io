# Distrobox
Distrobox acts as a wrapper that creates tightly integrated containers, enabling the sharing of the user's HOME directory, external storage, USB devices, and graphical applications (X11/Wayland) with the host system.

Containers can be created using either a declarative command,  
or they can be created/assembled using a declaritive  `containerFile.ini` configuration-file.

The distrobox should be almost transparent (aside from the creation process).  
At its best, distrobox applications will launch and (appear to) function as though they are installed on the base system.  
There should be little to no need to enter the container.

### distrobox-create
```sh
distrobox-create \
--name workbench \
--image docker.io/library/alpine:3.22 \
--home $HOME/distrobox/workbench \
--additional-packages "git git-gitk vim" \
--init-hooks "rm /usr/bin/vi; ln -s /usr/bin/vim /usr/bin/vi"
```

### distrobox-assemble (preferred)
The distrobox configuration is stored in a declaritive `someName.ini` so that you always know what you built, and can reproduce it easily.  
Also, some of the functionality of the `distrobox-assemble` approach is not available to `distrobox-create`.

Recommend storing any local distrobox *.ini files in a separate directory for organization (ex: ~/distrobox),  
and also use that same directory as the home directory for the each container.

Usage examples:  
```sh
# Create specific entry "thisName" in local distrobox.ini file
distrobox-assemble create --name thisName

# Create all entries in file "thatFile.ini"
distrobox-assemble create --file thatFile.ini
# also
distrobox-assemble create thatFile.ini
# also (URL)
distrobox-assemble create --file https://path/to/raw/thatFile.ini
```

# Configs
[inkcutbox.ini](inkcutbox.ini)
```sh
distrobox-assemble create --file https://raw.githubusercontent.com/cyril279/cyril279.github.io/refs/heads/master/docs/inkcutbox.ini
```
[tinygo.ini](tinygo.ini)  
```sh
distrobox-assemble create --file https://raw.githubusercontent.com/cyril279/cyril279.github.io/refs/heads/master/docs/tinygo.ini
```
[utilsMuController.ini (tio, openOCD, bossa-cli & esptool](utilsMuController.ini)
```sh
distrobox-assemble create --file https://raw.githubusercontent.com/cyril279/cyril279.github.io/refs/heads/master/docs/utilsMuController.ini
```
[workbench.ini](workbench.ini)
```sh
distrobox-assemble create --file https://raw.githubusercontent.com/cyril279/cyril279.github.io/refs/heads/master/docs/workbench.ini
```
