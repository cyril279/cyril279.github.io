
# Kodi
**[Build it from source]**
(because RPMfusion/fedora packages lack ISO-dvd playback)  
tested as of 2018/01/03, using on sda5  

-	Addons
	- [pvr.hts](#pvr.hts)
	- [vfs.rar](#vfs.rar)

**Overview:**  
- download source  
- install packages specifically for building  
- initiate build directories  
- if necessary: build missing dependencies & re-initiate build directories  
- build, (test,) install, profit  
- build & install addons as needed  

**path install info:**  
`/usr/share/kodi`  when installed from a binary package (ie PPA, rpm, deb, etc)  
`/usr/local/share/kodi`  when compiled (unless you specify an alternate prefix)  

**install [needed packages] +wayland requisites**  

**get source, prep & build kodi.app:**  
(kodi source directory can be on remote pc, but build directory(ies) should be local for easiest execution)  
`mkdir ~/workshop.kodi; cd _$`  
`git clone kodi.git source`  
`mkdir build.wayland; cd _$`  

to build specific tag/release:  
`git checkout tags/<tag_name> -b <branch_name>`  

**prep-x11:**  
`cmake ../source -DCMAKE_INSTALL_PREFIX=/usr/local`  

**prep-wayland:**  
`cmake ../source -DCMAKE_INSTALL_PREFIX=/usr/local -DCORE_PLATFORM_NAME=wayland -DWAYLAND_RENDER_SYSTEM=gl`  
  
error message about missing dependencies during prep?   
[build missing dependencies](https://github.com/xbmc/xbmc/blob/master/docs/README.Linux.md#31-build-missing-dependencies) , then prep again.  

**build:**  
`cmake --build . -- VERBOSE=1 -j$(getconf _NPROCESSORS_ONLN)`  

**install:**  
`sudo make install -j$(getconf _NPROCESSORS_ONLN)`  

## Addons
### pvr.hts  
Provides tvheadend interface  
**prep & build [addon.pvr.hts](https://github.com/kodi-pvr/pvr.hts#linux)**  
`cd ~/workshop.kodi`  
`git clone pvr.hts.git`  
`mkdir pvr.hts/build; cd $_`  
`cmake -DADDONS_TO_BUILD=pvr.hts -DADDON_SRC_PREFIX=../.. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr/share/kodi/addons -DPACKAGE_ZIP=1 ../../source/cmake/addons`  
`make` #also installs  
```
-DCMAKE_INSTALL_PREFIX=../../build/addons
-DCMAKE_INSTALL_PREFIX=/usr/local/share/kodi/addons
```
### vfs.rar
Allows listing and execution of archived content  
**prep & build [addon.vfs.rar](https://github.com/xbmc/vfs.rar)**  
`cd ~/workshop.kodi`  
`git clone vfs.rar.git`  
`mkdir vfs.rar/build; cd $_`  
`cmake -DADDONS_TO_BUILD=vfs.rar -DADDON_SRC_PREFIX=../.. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr/share/kodi/addons -DPACKAGE_ZIP=1 ../../source/cmake/addons`  
`make` #also installs  
```
-DCMAKE_INSTALL_PREFIX=../../build/addons
-DCMAKE_INSTALL_PREFIX=/usr/local/share/kodi/addons
```

## Notes:
**unset cmake cache variables:**  
`cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -UCORE_PLATFORM_NAME -UWAYLAND_RENDER_SYSTEM`  

Multi-episode (tv) files are incorrectly listed in the library.  
settings > media > library > video > [tv_kids]  ← menu, change content,...  
while setting the content type for tv_kids to ‘tv shows’, enable ‘dvd order’ within [settings].  
This allows the tv show list to correctly title each listing when the show contains multiple episodes.  

## Installation via RPMfusion:
Easiest method, but **lacks ISO-dvd playback on Fedora (**Fedora/RPM fusion do not include complete/correct versions of libraries needed for iso playback)  

RPMfusion provides dnf-installables within days of the release.  
`dnf --enablerepo=rpmfusion-free-updates-testing --refresh upgrade`  

[needed packages]: https://github.com/xbmc/xbmc/blob/master/docs/README.Fedora.md#3-install-the-required-packages
[Build it from source]: https://github.com/xbmc/xbmc/blob/master/docs/README.Fedora.md

