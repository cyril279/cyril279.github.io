# budgie 10.5 on openSUSE Tumbleweed | 2019/Mar
A slightly modified version of the **Solus-project** [build-instructions], for a working Budgie desktop on openSUSE-TW

### Process Modifications
- A build-dependency list tailored for openSUSE
- Use [Ubuntu-Budgie's "mutter330reduxII" branch] for libmutter-3 compatibility
- Setting the build flag `-Dwith-desktop-icons=none` is necessary to prevent **budgie-desktop-settings** from crashing  
(Solus and Ubuntu are configured to use desktop icons)

### Install build dependencies  
`sudo zypper in accountsservice-devel git glib2-devel gnome-bluetooth-devel gnome-menus-devel gnome-settings-daemon-devel gobject-introspection-devel gsettings-desktop-schemas-devel gtk-doc gtk3-devel ibus-devel intltool json-glib-devel libgnome-desktop-3-devel libupower-glib-devel libuuid-devel libX11-devel libXtst-devel libpeas-devel libwnck-devel meson mutter-devel polkit-devel sassc vala`  

### Clone [Ubuntu-Budgie's "mutter330reduxII" branch]  
`git clone --branch mutter330reduxII --single-branch https://github.com/UbuntuBudgie/budgie-desktop.git`  

`cd budgie-desktop`  

### Configure, build, install
`meson build --prefix=/usr --sysconfdir=/etc --buildtype plain -Dwith-desktop-icons=none`  

`ninja -j$(($(getconf _NPROCESSORS_ONLN)+1)) -C build`

`sudo ninja install -C build`

[build-instructions]:https://github.com/solus-project/budgie-desktop/wiki/Building-Budgie-Desktop  
[Arch mail-archive/commit]:https://www.mail-archive.com/arch-commits@archlinux.org/msg465529.html  
[Ubuntu-Budgie's "mutter330reduxII" branch]:https://github.com/UbuntuBudgie/budgie-desktop/tree/mutter330reduxII  

