# workstation: openSUSE | 2019, February
**Why openSUSE (vs.Fedora):**  
1. Rolling  
2. zypper  
2. snapper  
2. yast
2. other little items already installed/work out of box (so what else have I been missing?)  

**openSUSE** adds a management layer (yast) in between the DE and the underlying OS.  

**Upside(s):**  
1. Intelligent, centralized, fine-grained, and comprehensive controls, despite upstream of DE.  
2. Coverage beyond the DE: Networking, Samba, etc. that works well; even headless.
2. Ensures that the process is done right/completely, despite what the end-user thinks they understand about unix/linux  
2. Much less in-the-dark than commandline, but still a coherent (& wiki/doc supported) experience for the end-user.  

**Downside(s)**  
1. tutorials are more limited than more standard distro (centos, redhat, fedora, arch)  
2. adds distro-specific stuff for the end-user to know about/learn  

~~These aren't strong, but raise the flag of whether it is worth it for the (few) benefits.~~ <- fuck that, it's worth it.  
### Getting started:
**packages (util):**  
`zypper in hplip nfs4-acl-tools git htop iotop`  

**packages (preference):**  
`zypper in elementary-xfce-icon-theme papirus-icon-theme neofetch`  
`zypper rm gnome-software joe`  
`zypper al gnome-software joe`

**opensuse-multimedia-libs:**  
```
sudo zypper ar -f http://ftp.gwdg.de/pub/opensuse/repositories/multimedia:/libs/openSUSE_Tumbleweed/ opensuse-multimedia-libs
sudo zypper ref
```
### Configuration:
#### NetworkManager vs. Wicked:  
- for laptop? NetworkManager. full stop.  
- I like the configurability of Wicked (via Yast), but it lacks gnome integration (applet)  
 
**Service switch (to [Wicked])**  
`systemctl status network` #show/verify which service is managing the network, and its status  
`systemctl stop network` #stop the network (& assigned services)  
`systemctl disable NetworkManager`  
`systemctl enable wicked`  
`systemctl start network`  #start the network (& assigned services)  
`systemctl status network`  #show/verify which service is managing the network, and its status  

#### static ip:
Use gateway ip for dns server address (& routing).  

**YAST!**  
Can invoke text-mode gui from terminal, and will help ensure that all is done right.  
`yast`  

**If wicked**, Yast cli. be sure to input interior gateway ip as route and dns server

CLI setup differs per service chosen"  
**If NetworkManager**, ~[three files need to be modified](https://forums.opensuse.org/showthread.php/431523-Configure-Static-Ip-using-the-Terminal?p=2109330#post2109330) if not done via gui.  

> You need to edit three files:  
> _/etc/sysconfig/network/ifcfg-eth0_  
> ``` 
> BOOTPROTO='static'  
> IPADDR='192.168.2.77'  
> MTU='1500'  
> NAME=''  
> NETMASK='255.255.255.0'  
> STARTMODE='auto'  
> USERCONTROL='no'  
> ``` 
> _/etc/sysconfig/network/routes_  
> ``` 
> default 192.168.2.1 - -  
> ```
> _/etc/resolv.conf_  
> ```
> nameserver 192.168.2.1  
> ```

This gem of advice:  
> Another idea, not nearly as geeky or sexy, would be to enter "yast" at that terminal prompt, then use the arrow and tab keys to get to Network Devices -> Network Settings.  
> 
> If you insist on knowing how to do it manually, just look at the contents of the files named above *after* you use Yast to see what it did.  

[Fileshare]: ../html/fileshare.html#acl-setup
[Wicked]: https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.network.html#sec.network.manconf.using_wicked

# xfce
less graphically demanding on old hardware.  
~~Do this on top of gnome, because I still prefer the minimal presentation of gtk applications.~~ <- no, this just handicaps xfce  
`zypper in -t pattern xfce`  
`sudo zypper in yast2-alternatives`  
in yast > misc > alternatives, switch from gdm to lightdm  
set keyboard shortcut `xfce4-popup-whiskermenu` to super-key  

#### notes: unverified:  
laptop broadcom wifi?  
Enable Packman (yast) and install the broadcom-wl package.  
