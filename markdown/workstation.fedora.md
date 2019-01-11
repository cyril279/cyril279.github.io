# Workstation (Gnome)

[Make it useful:](#make-it-useful)
[Install favorite packages & media codecs](#install-favorite-packages)
[Make it yours:](#make-it-yours)
[Extensions](#extensions)
[Themes](#themes)

### Make it useful:

#### enable the rpm-fusion repos #for multimedia, etc.
    su -c 'dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'

#### Install favorite packages
    su -c 'dnf -y install nano inkscape gnome-mpv gnome-tweak-tool chrome-gnome-shell paper-icon-theme adapta-gtk-theme breeze-cursor-theme pop-icon-theme tilix-nautilus pop-gtk-theme gthumb libdvdcss chromium freshplayerplugin'

#### Install Media Codecs
    su -c 'dnf groupupdate Multimedia'

#### Start & enable ssh server
    systemctl start sshd
    systemctl enable sshd

[manage repos](https://fedoramagazine.org/configure-software-repositories-fedora/)

### Make it yours:

- [**Extensions**](https://extensions.gnome.org)
	-   [open weather](https://extensions.gnome.org/extension/750/openweather/)
	-   [lock keys](https://extensions.gnome.org/extension/36/lock-keys/)
	-   [dash to panel](https://extensions.gnome.org/extension/1160/dash-to-panel/) / [dash to dock](https://extensions.gnome.org/extension/307/dash-to-dock/)

#### Themes
**operation on theme folder:**

    sudo cp -a /source/folder /dest/

**ex:**

    sudo cp -a '/home/cyril/installers/Gnome-OSX-II-2-6-NT' '/usr/share/themes/Gnome-OSX-II-2-6-NT'

### Issues?

If upgrade to newer Fedora release, check repositories referencing older releases:

[https://fedoramagazine.org/configure-software-repositories-fedora/](https://fedoramagazine.org/configure-software-repositories-fedora/)

-   Cutter software? :: [ref_01](http://libregraphicsworld.org/blog/entry/vinyl-cutting-on-linux-the-real-deal)
    
-   [inkcut](http://inkcut.sourceforge.net) (inkscape extension)
    
#### system boots, but not to gdm/login? [reboot to prompt, & disable wayland](https://ask.fedoraproject.org/en/question/70961/fedora-22-will-not-boot-after-installation-vm/?answer=77048#post-id-77048)

1.  At the grub boot menu, press 'e' to edit the bootup settings.
2.  go down to the line starting with "linux16 /vmlinuz" (it will probably span multiple lines) and add a " 3" to the end (that is a space, then a '3'). This will tell the bootup scripts to load only the text console, and not attempt to start a graphical login screen.
3.  Press CTRL-X to boot the edited settings.
4.  login as root.
5.  "vi /etc/gdm/custom.conf" (or use your editor preference instead of vi), and delete the leading "#" from the line "#WaylandEnable=false". Save the file.
6.  Reboot and enjoy :)
Note that I have heard that replacing step 5 with "dnf update" will also fix the issue (and update the rest of the system in the process). This would be preferable to just updating the file as per the above, but you can always follow my instructions and then run an update once you are able to graphically login.

## [Harmony/flirc/kodi](HARMONY-FLIRC-KODI.html)

# Android 7.1 compile environment (F25)

[(originally posted to xda)](https://forum.xda-developers.com/chef-central/android/guide-setting-android-compile-t3530696)

(package list is adapted from [Omni’s instructions for F19](https://docs.omnirom.org/Setting_Up_A_Compile_Environment#Fedora_19_x64), to compile Android 7.1 on F25)

**From a clean installation of Fedora-25:**

Update the installation

    su -c 'dnf -y update'

Install additional packages that we need to compile AOSP

    su -c 'dnf -y install zip curl gcc gcc-c++ flex bison gperf glibc-devel.{x86_64,i686} zlib-devel.{x86_64,i686} ncurses-devel.i686 libX11-devel.i686 libstdc++.i686 readline-devel.i686 libXrender.i686 libXrandr.i686 perl-Digest-MD5-File python-markdown mesa-libGL-devel.i686 git schedtool pngcrush [ncurses-compat-libs](https://ask.fedoraproject.org/en/question/89534/parrallel-install-ncurses-6-ncurses-5-on-fedora-24/)  [java-1.8.0-openjdk-devel](http://stackoverflow.com/questions/5407703/javac-command-not-found) xz-lzma-compat android-tools'

install & configure repo

    mkdir -p ~/bin
    curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
add line to end of ~/.bashrc

    export PATH=~/bin:$PATH
configure git to identify you

    git config --global user.email "your@email.address"
    git config --global user.name "Your Name"

[setting up ccache](https://source.android.com/source/initializing.html#setting-up-ccache) (for quicker rebuilds):

Issue these commands in the root of the source tree:

    export USE_CCACHE=1
    export CCACHE_DIR=/<path_of_your_choice>/.ccache
prebuilts/misc/linux-x86/ccache/ccache -M 50G
The suggested cache size is 50-100G.
The ccache size is stored in the CCACHE_DIR and is persistent.
For persistence, add `USE_CCHACHE’ snd ‘CCACHE_DIR` commands to .bashrc (or equivalent):

Watch ccache being used:
    watch -n1 -d prebuilts/misc/linux-x86/ccache/ccache -s

# History
- +**Fedora (Server) 2017/09** (installed on Optiplex 3010 as Media Server and DVR backend)
- **Fedora (Gnome) 2016/11** (dnf,clean/simple/easy DE,PakAvl+,ComSup+,builds android,melikey)
- **Elementary(Pantheon)** 2016/09 (Beautiful OS,lightweight,OBF+,UB,oversimplified/limited controls)
- +**Opensuse(tumbleweed@KDE)** 2016/09 (brilliant package management,rolling,ComSup+,PakAvl+, over-thinks & duplicates other aspects,can’t get multimedia support right)
- **Manjaro(KDE)** 2016/08 (OBF+,PakAvl+,ComSup+,rolling+,proprietary support+, KDE: pretty, but more menu-bars than it's worth)
- **Mint(Cinnamon)** 2016/03 (OBF++,UB, looks/feels dated)
- **Ubuntu(Unity)** 2014/09 (OBF+,ComSup+,PakAvl+, but despise AptGet and Unity)

OBF = Out of the Box Functionality
PakAvl = Package Availability
ComSup = Community support
 UB = Ubuntu Based, so PakAvl+,ComSup+, but AptGet

> Written with [StackEdit](https://stackedit.io/).

