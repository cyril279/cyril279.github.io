Document repository of... breadcrumbs? 

## Method
- [fileshare](fileshare/README.md)  
- [mdadm](docs/mdadm.md)  
- [quadlets](docs/serverConfigQuadlets.md)  
- [Tvheadend](docs/serverConfigTVH.md)  

## Configuration
- [config-fstab](docs/fstab.md)  
- [config-general](docs/config.md)  
- [hardware/firmware](hardware/README.md)
- [server-General (immutable)](docs/serverConfigImmutable.md)
- [server-General](docs/serverConfigGeneral.md)  
- [workbench (distrobox)](docs/configDistrobox.md)  

## NOTES

Spin/Pattern/Distro    |   Base/DE	|	Benefits |	Drawbacks
--:|:-|:--:|:--
**[U-Blue/Dakota!! :)](https://github.com/projectbluefin/dakota)** 2026/06 |   GnomeOS/Gnome | immutable,rollback,rolling,auto-update,current    | Container-life, for better and for worse
**[U-Blue/Bazzite/Bluefin](https://universal-blue.org/)** 2026/06	|   Fedora-Silverblue/Gnome |	immutable,rollback,rolling,auto-update,current	| Container-life, for better and for worse
**[MicroOS](https://en.opensuse.org/Portal:MicroOS)/[Aeon](https://en.opensuse.org/Portal:Aeon)** 2024/07	|   tumbleweed/Gnome |	immutable,snapper,rolling,auto-update,current	| Container-life uncomplicates the base installation at the cost of complicating app installation/operation
**[tumbleweed](https://get.opensuse.org/tumbleweed/)** 2019/02	|   Gnome |	zypper,yast,snapper,rolling,Nvidia repo,current	| yast/SUSE approach inherently introduces: 1) SUSE’s own way of doing things 2) a duplication of existing DE tools 3) less DE intregration
**Fedora** 2016/11	|   Gnome |	dnf,DE-transparent,Nvidia repo,current	| short support life, but not rolling. Consistent trouble upgrading versions
**Manjaro** 2016/08	|	Arch/Gnome |   Out-of-the-box brilliance, insane package/DE availability, DE-transparent, Nvidia easiest, current	| feels a little unbridled for me. I like the protections offered by the enterprise-backed distros.
**elementary** 2016/09|	Ubuntu/Pantheon | See "Desktop Environment": Pantheon | Ubuntu-based
**Mint** 2016/03	|   Debian/Cinnamon |   See "Desktop Environment": Cinnamon | Ubuntu-based
**Ubuntu** 2014/09	|   Debian/Unity |	See "Desktop Environment": Unity	| Not a fan of apt-get, Ubuntu uses a different filesystem-framework than the other gnu/linux standards
------- | ------- | ------- | -------
**Desktop Environment**	|   |	**Benefits**	|	**Drawbacks**
gnome	|   |	beautiful, minimalist approach, gtk4/csd | resource hog (functions, but not as graphically snappy on older hardware)
pantheon  |   |   beautiful, minimalist approach, gtk4/csd | settings/options are too limited, forcing command-line hackery for petty customization
cinnamon    |   | familiar, centralized settings | feels old/dated, resource hog, anti-csd
Unity   |   |   Good enough. batteries included. |  I Never truly settled into the unity way-of-things which is odd considering it's tweaked GNOME, which I like
xfce	|   |	light on resources, graphically snappy, runs csd apps | not as cohesive as gnome
budgie	|   |	GNOME-like but snappier, more cohesive than XFCE	| less cohesive than GNOME, less snappy than XFCE, less mature/complete than both

## Archive

### Method/Config
- [docker/docker-compose](docs/serverConfigDocker.md)  
- [Kodi](docs/kodi-gen.md)  
- [nvidia](docs/nvidia.md)  
- [Open CASCADE JT Assistant](docs/jtviewer.md)  
- [Transmission (server)](docs/serverConfigTransmission.md)  
- [Transmission (docker)](docs/serverConfigDocker.md#transmission)  
- [Tvheadend (docker)](docs/serverConfigDocker.md#tvheadend)  

### OS/DE
- [microOS](docs/microOS.md)  
- [Fedora](docs/fedora.md)  
- [OpenSUSE](docs/opensuse.md)  
- [PantheNOT](docs/pantheNOT/README.md)  

## bookmarks
[markdown extension for browser](https://github.com/simov/markdown-viewer) (best markdown find to date!)  
