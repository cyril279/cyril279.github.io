## Distrobox containers
Containers can be created using either a declarative command,  
or they can be assembled using a `containerFile.ini` configuration-file.

### distrobox-create
Simple, straight-forward, well documented online

```sh
#create container:
distrobox-create \
--name workbench \
--image docker.io/library/alpine:3.22 \
--home ~/distrobox/workbench \
--additional-packages "git git-gitk vim" \
--init-hooks "rm /usr/bin/vi; ln -s /usr/bin/vim /usr/bin/vi"
```

### distrobox-assemble
As a locally stored `distrobox.ini`, each container's configuration is inherently documented, and  therefore quickly/easily reproducible.  
Also, some of the functionality of the `distrobox-assemble` approach is not available to `distrobox-create`.

Recommend storing the distrobox *.ini files in a separate directory for organization (ex: ~/distrobox),  
and also use that same directory as the home directory for the each container.
```sh
distrobox-assemble create --name thisName
# or
distrobox-assemble create --file thatFile.ini
# or
distrobox-assemble create thatFile.ini
```
```ini
# workbench.ini
[workbench]
image=docker.io/library/alpine:latest
home=~/distrobox/workbench
pull=true
replace=true
additional_packages="git git-gitk vim"
init_hooks="rm /usr/bin/vi; ln -s /usr/bin/vim /usr/bin/vi"
exported_bins="/usr/bin/git /usr/bin/gitk"
exported_bins_path="~/.local/bin"
```
```ini
# inkcutBox.ini
[inkcutBox]
image=docker.io/library/alpine:3.22
home=~/distrobox/inkcutBox
pull=true
additional_packages="gcc git cups-dev musl-dev linux-headers"
additional_packages="python3-dev pipx py3-qt5"
additional_flags="--env PIPX_BIN_DIR=/usr/local/bin"
exported_bins="/usr/bin/pipx"
exported_bins_path="~/.local/bin"
```
## My setup
Not tried: grouping home directories by distribution  
```ini
# ~/workbench/distrobox.ini
[workbench]
image=docker.io/library/alpine:latest
home=~/dbxAlpine
pull=true
replace=true
additional_packages="git git-gitk vim"
init_hooks="rm /usr/bin/vi; ln -s /usr/bin/vim /usr/bin/vi"
exported_bins="/usr/bin/git /usr/bin/gitk"
exported_bins_path="~/.local/bin"

[inkcutBox]
#image=docker.io/library/alpine:3.22
clone=workbench
home=~/dbxAlpine
pull=true
additional_packages="gcc cups-dev musl-dev linux-headers"
additional_packages="python3-dev pipx py3-qt5"
additional_flags="--env PIPX_BIN_DIR=/usr/local/bin"
exported_bins="/usr/bin/pipx"
exported_bins_path="~/.local/bin"
```