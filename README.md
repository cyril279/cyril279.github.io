Document repository of... breadcrumbs? 
# Deets & Strats

### Method
- [fileshare](fileshare/README.md)  
- [mdadm](docs/mdadm.md)  
- [quadlets](docs/serverConfigQuadlets.md)  
- [Tvheadend](docs/serverConfigTVH.md)  

### Configuration
- [config-fstab](docs/fstab.md)  
- [config-general](docs/config.md)  
- [hardware/firmware](hardware/README.md)
- [server-General (immutable)](docs/serverConfigImmutable.md)
- [server-General](docs/serverConfigGeneral.md)  
- [workbench (distrobox)](docs/configDistrobox.md)  

# 2026/06
Overall, spinning up a new linux system has gotten remarkably easier over the years, to the point where a significant amount of the how-to/configuration documentation that I have captured is no longer needed.  
Much of the archived info is only retained because I still own hardware that _could possibly_ benefit from the legacy methods.  
The increased ease is a direct result of two main things:

### My preferences & usage patterns are well established  
I have been daily-driving linux since 2016, and am well settled on the kind of interface and experience that I prefer, so now spend my computing time actually _using_ the PC and not distro-hopping, tweaking & re-configuring, babysitting updates or troubleshooting upgrades.

### 'Declaritive configuration' for the win
From whatever distro/spin (immutable is a must these days), I add whatever apps/services that are needed via quadlets, flatpaks, and/or distrobox.  
There is definitely a learning curve to gettting the non-native/containerized methods to play-well with the OS, but once established, the declaritive configuration approach is infinitely repeatable and eliminates fiddling with distro-specific patterns or package-groups.  

# Notes/Timeline

Spin/Pattern/Distro    |   Base/DE	|	Benefits |	Drawbacks
--:|:-|:--:|:--
**[U-Blue/Dakota!! :)](https://github.com/projectbluefin/dakota)** 2026/06 (testdriving)|   GnomeOS/Gnome | immutable,rollback,rolling,auto-update,current    | Container-life, for better and for worse
**[U-Blue/Bazzite/Bluefin](https://universal-blue.org/)** 2026/06 (current,serverus)|   Fedora-Silverblue/Gnome |	immutable,rollback,rolling,auto-update,current	| Container-life, for better and for worse
**[MicroOS](https://en.opensuse.org/Portal:MicroOS)/[Aeon](https://en.opensuse.org/Portal:Aeon)** 2024/07 (current,laptop) |   tumbleweed/Gnome |	immutable,snapper,rolling,auto-update,current	| Container-life uncomplicates the base installation at the cost of complicating app installation/operation
**[tumbleweed](https://get.opensuse.org/tumbleweed/)** 2019/02	|   Gnome |	zypper,yast,snapper,rolling,Nvidia repo,current	| yast/SUSE approach inherently introduces: 1) SUSE’s own way of doing things 2) a duplication of existing DE tools 3) less DE intregration
**Fedora** 2016/11	|   Gnome |	dnf,DE-transparent,Nvidia repo,current	| short support life, but not rolling. Consistent trouble upgrading versions
**Manjaro** 2016/08	|	Arch |   Out-of-the-box brilliance, insane package/DE availability, DE-transparent, Nvidia easiest, current	| feels a little unbridled for me. I like the (perceived) protections of the enterprise-backed distros.
Gnome| | beautiful, minimalist approach, centralized settings, gtk4/csd | resource hog (functions, but not as graphically snappy on older hardware)
**elementary** 2016/09|	Ubuntu/Pantheon | beautiful, minimalist approach, centralized settings, gtk4/csd | **OS:** Ubuntu-based **DE:** settings/options are too limited, forcing command-line hackery for petty customization
**Mint** 2016/03	|   Debian |  Well supported, batteries included | Ubuntu-based 
xfce ||	light on resources, graphically snappy, runs csd apps | not as cohesive as gnome
budgie ||	GNOME-like but snappier, more cohesive than XFCE	| less cohesive than GNOME, less snappy than XFCE, less mature/complete than both
cinnamon || familiar, centralized settings | feels dated, anti-csd
**Ubuntu** 2014/09	|   Debian/Unity |	Baseline. Good enough, batteries included. VERY well supported b/c gateway distro	| Ubuntu uses a different filesystem-framework than other gnu/linux standards. I Never truly settled into the unity way-of-things.

# Archive

Method/Config | Reason Archived
--:|:--
[docker/docker-compose](docs/serverConfigDocker.md) | I prefer the more native feel of Quadlets
[Kodi](docs/kodi-gen.md) | Flatpak is good-enough, no longer need to build from source
[nvidia](docs/nvidia.md) | Switched to linux-friendly Radeon where discrete card is used
[Open CASCADE JT Assistant](docs/jtviewer.md) | IDEK (haven't used in a while)
[Transmission (server)](docs/serverConfigTransmission.md) | Configured via Quadlet
[Transmission (docker)](docs/serverConfigDocker.md#transmission) | Configured via Quadlet
[Tvheadend (docker)](docs/serverConfigDocker.md#tvheadend) |  Configured via Quadlet
--|--
**OS/DE**  | **Reason Archived**
[microOS](docs/microOS.md) | Obsoleted by immutable workflow
[Fedora](docs/fedora.md) | Obsoleted by immutable workflow
[OpenSUSE](docs/opensuse.md) | Obsoleted by immutable workflow
[PantheNOT](docs/pantheNOT/README.md) | Un-used, not worth the trouble

# Bookmarks
[markdown extension for browser](https://github.com/simov/markdown-viewer) (best markdown find to date!)  
