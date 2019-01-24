
**Still needs testing to verify:**  
- works with multimedia types  
- addon-builds function as desired  
- Install only completely necessary packages  

**To do:**  
- eliminate need to build wayland from source (see "not right")  
- eliminate need to get fstrcmp from sourceforge  
- create full guide here (from fresh installation), so other guide is only cited as reference  
  - do `zypper dup` first, and note version for reference.  
- fork & fix (& pull-req) guide?  

**not right**  
- Tumbleweed includes wayland, so why do I have to build it separately to satisfy the kodi-build process?
- Maybe try fresh source too? at least remove `tools/depends/target/stuff` <- made no difference  

# Kodi (build from source)  
opensuse tumbleweed 2019-01-23  
The [official guide] is incomplete (as of 2019-01-24)  
Attempt to [install required packages](https://github.com/xbmc/xbmc/blob/master/docs/README.openSUSE.md#3-install-the-required-packages) is where the trouble starts.
`randrproto-devel renderproto-devel`  
are available as:  
`xcb-proto-devel xorgproto-devel`  
`fstrcmp` is attained from [alternate source](#get-source)  

### Install required packages (modified list):  
`sudo zypper in alsa-devel autoconf automake bluez-devel boost-devel capi4linux-devel ccache cmake doxygen flac-devel fribidi-devel gcc gcc-c++ gettext-devel giflib-devel glew-devel gperf java-openjdk libass-devel libavahi-devel libbluray-devel libbz2-devel libcap-devel libcap-ng-devel libcdio-devel libcec-devel libcurl-devel libdvdread-devel libgudev-1_0-devel libidn2-devel libjasper-devel libjpeg-devel liblcms2-devel libmad-devel libmicrohttpd-devel libmodplug-devel libmpeg2-devel libmysqlclient-devel libnfs-devel libogg-devel libpcap-devel libplist-devel libpng12-devel libpulse-devel libsamplerate-devel libsmbclient-devel libtag-devel libtiff-devel libtool libudev-devel libuuid-devel libva-devel libvdpau-devel libvorbis-devel libXrandr-devel libXrender-devel libxslt-devel libyajl-devel lirc-devel lzo-devel make Mesa-libEGL-devel Mesa-libGLESv2-devel Mesa-libGLESv3-devel nasm patch pcre-devel python-devel shairplay-devel sqlite3-devel swig tinyxml-devel xcb-proto-devel xorgproto-devel libopenssl-devel`  

### Get source  
**(Clone into directory structure as desired)**  
https://github.com/xbmc/xbmc  
http://fstrcmp.sourceforge.net <- for missing fstrcmp  
https://gitlab.freedesktop.org/wayland/wayland <- for wayland error during build  

### Build dependencies  
**from kodi source directory:**  
`sudo make -C tools/depends/target/flatbuffers PREFIX=/usr/local`  
`sudo make -C tools/depends/target/libfmt PREFIX=/usr/local`  
`sudo make -C tools/depends/target/rapidjson PREFIX=/usr/local`  
`sudo make -C tools/depends/target/waylandpp PREFIX=/usr/local`  

**fstrcmp:**  
`tar xvzf file`  
cd into extracted fstrcmp directory  
`./configure`  
`make`  
`sudo make install`  
`sudo ldconfig`  

**from wayland source directory:**  
`./autogen.sh --prefix=/usr/local`  
`make`  
`make install`  

### missing wayland_client_core.h, so build wayland per [gitlab direction](https://gitlab.freedesktop.org/wayland/wayland)  
prereq:  
`libffi-devel`  
ran modified setup command to circumvent installing unneeded packages:  
`./autogen.sh --prefix=/usr/local --disable-documentation`  

### ref:  
[kodi-opensuse github guide](https://github.com/xbmc/xbmc/blob/master/docs/README.openSUSE.md)  
[kodi-opensuse forum guide](https://forum.kodi.tv/showthread.php?tid=337324)  
[wayland via gitlab](https://gitlab.freedesktop.org/wayland/wayland)  

[official guide]: https://github.com/xbmc/xbmc/blob/master/docs/README.openSUSE.md  

