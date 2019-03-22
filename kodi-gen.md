
# Kodi
**[Build it from source]**
(because distribution packages lack ISO-dvd playback)  

### Addons
- [pvr.hts](#pvr.hts)  
- [vfs.rar](#vfs.rar)  

### Overview:  
- download source  
- install packages specifically for building  
- initiate build directories  
- if necessary: build missing dependencies & re-initiate build directories  
- build, (test,) install, profit  
- build & install addons as needed  

### Path install info:  
`/usr/share/kodi`  when installed from a binary package (ie PPA, rpm, deb, etc)  
`/usr/local/share/kodi`  when compiled (unless you specify an alternate prefix)  

## Install required packages
- [Fedora](#fedora)
- [openSUSE](kodi-opensuse.md#install-required-packages)

## Obtain source,& build Kodi  
(kodi source directory can be on remote pc, but build directory(ies) should be local)  
`git clone kodi.git kodi-source`  
`mkdir kodi-build-wayland; cd _$`  

to build specific tag/release:  
`git checkout tags/<tag_name> -b <branch_name>`  

**prep-wayland:**  
`cmake ../kodi-source -DCMAKE_INSTALL_PREFIX=/usr/local -DCORE_PLATFORM_NAME=wayland -DWAYLAND_RENDER_SYSTEM=gl`  
  
**prep-x11:**  
`cmake ../kodi-source -DCMAKE_INSTALL_PREFIX=/usr/local`  

error message about missing dependencies during prep?   
[build missing dependencies](https://github.com/xbmc/xbmc/blob/master/docs/README.Linux.md#31-build-missing-dependencies) , then prep again.  

**build:**  
`cmake --build . -- VERBOSE=1 -j$(getconf _NPROCESSORS_ONLN)`  

**install:**  
`sudo make install -j$(getconf _NPROCESSORS_ONLN)`  

## Addons
### [pvr.hts](https://github.com/kodi-pvr/pvr.hts#linux)
Provides tvheadend interface  
**prep & build**  
`cd ~/workshop.kodi`  
`git clone pvr.hts.git`  
`mkdir pvr.hts/build; cd $_`  
`cmake -DADDONS_TO_BUILD=pvr.hts -DADDON_SRC_PREFIX=../.. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr/local/share/kodi/addons -DPACKAGE_ZIP=1 ../../kodi-source/cmake/addons`  
`make` #also installs  

_doprep.sh:_  
```
#!/bin/bash
cmake -DADDONS_TO_BUILD=pvr.hts -DADDON_SRC_PREFIX=../.. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr/local/share/kodi/addons -DPACKAGE_ZIP=1 ../../kodi-source/cmake/addons/
```
### [vfs.rar](https://github.com/xbmc/vfs.rar)
Allows listing and execution of archived content  
**prep & build**  
`cd ~/workshop.kodi`  
`git clone vfs.rar.git`  
`mkdir vfs.rar/build; cd $_`  
`cmake -DADDONS_TO_BUILD=vfs.rar -DADDON_SRC_PREFIX=../.. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr/local/share/kodi/addons -DPACKAGE_ZIP=1 ../../kodi-source/cmake/addons`  
`make` #also installs  

[needed packages]: https://github.com/xbmc/xbmc/blob/master/docs/README.Fedora.md#3-install-the-required-packages
[Build it from source]: https://github.com/xbmc/xbmc/blob/master/docs/README.Fedora.md

