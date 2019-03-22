**Questionable steps:**  
- Need to build wayland from source    
  Tumbleweed includes wayland, so why do I have to build it separately to satisfy the kodi-build process?
- Need to get `fstrcmp` from sourceforge  

**To-do:**  
- create full guide here (from fresh installation), so other guide is only cited as reference  
  - do `zypper dup` first, and note version for reference.  
- fork & fix (& pull-req) guide?  

# Kodi (build from source)  
opensuse tumbleweed 2019-01-23  
The [official guide] is incomplete (as of 2019-01-24)  
Attempt to [install required packages](https://github.com/xbmc/xbmc/blob/master/docs/README.openSUSE.md#3-install-the-required-packages) is where the trouble starts.  

`randrproto-devel renderproto-devel`  
are available as:  
`xcb-proto-devel xorgproto-devel`  

`fstrcmp` is obtained from [alternate source](#get-source)  

## Install required packages  
Add `opensuse-multimedia-libs` repository because some needed packages are non-OSS:
```
sudo zypper ar -f http://ftp.gwdg.de/pub/opensuse/repositories/multimedia:/libs/openSUSE_Tumbleweed/ opensuse-multimedia-libs
sudo zypper ref
```
**NOTE:** A message will ask you to accept the key. Enter `a`, the *trust always* option.

### Install build dependencies (modified list)  
`sudo zypper in alsa-devel autoconf automake bluez-devel boost-devel capi4linux-devel ccache cmake doxygen flac-devel fribidi-devel gcc gcc-c++ gettext-devel giflib-devel git glew-devel gperf java-openjdk libass-devel libavahi-devel libbluray-devel libbz2-devel libcap-devel libcap-ng-devel libcdio-devel libcec-devel libcurl-devel libdvdread-devel libgudev-1_0-devel libidn2-devel libjasper-devel libjpeg-devel liblcms2-devel libmad-devel libmicrohttpd-devel libmodplug-devel libmpeg2-devel libmysqlclient-devel libnfs-devel libogg-devel libpcap-devel libplist-devel libpng12-devel libpulse-devel libsamplerate-devel libsmbclient-devel libtag-devel libtiff-devel libtool libudev-devel libunistring-devel libuuid-devel libva-devel libvdpau-devel libvorbis-devel libXrandr-devel libXrender-devel libxslt-devel libyajl-devel lirc-devel lzo-devel make Mesa-libEGL-devel Mesa-libGLESv2-devel Mesa-libGLESv3-devel nasm patch pcre-devel python-devel shairplay-devel sqlite3-devel swig tinyxml-devel xcb-proto-devel xorgproto-devel libopenssl-devel`  

### Kodi  
https://github.com/xbmc/xbmc  
from kodi source directory:  
`sudo make -C tools/depends/target/flatbuffers PREFIX=/usr/local`  
`sudo make -C tools/depends/target/libfmt PREFIX=/usr/local`  
`sudo make -C tools/depends/target/rapidjson PREFIX=/usr/local`  
`sudo make -C tools/depends/target/waylandpp PREFIX=/usr/local`  

### fstrcmp
http://fstrcmp.sourceforge.net  
extraction:  
`tar xvzf fstrcmp-version.tar.gz`  

from extracted fstrcmp directory:  
`./configure`  
`make`  
`sudo make install`  
`sudo ldconfig`  

### Wayland
https://gitlab.freedesktop.org/wayland/wayland <- for `missing wayland_client_core.h` error during build  
`sudo zypper in libffi-devel`  

from wayland source directory:  
`./autogen.sh --prefix=/usr/local --disable-documentation`  
`make`  
`make install`  

### ref:  
[kodi-opensuse github guide](https://github.com/xbmc/xbmc/blob/master/docs/README.openSUSE.md)  
[kodi-opensuse forum guide](https://forum.kodi.tv/showthread.php?tid=337324)  
[wayland via gitlab](https://gitlab.freedesktop.org/wayland/wayland)  

[official guide]: https://github.com/xbmc/xbmc/blob/master/docs/README.openSUSE.md  
