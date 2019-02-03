# workstation: openSUSE
**Why openSUSE (vs.Fedora):**  
1. Rolling  
2. zypper  
2. nicely decorated bash  
2. other little items already installed/work out of box (so what else have I been missing?)  
  a. firefox flash  
  b. chrome-gnome stuff  
  c. more ir codes  

**openSUSE** adds a gui/management layer in between the DE and the underlying OS.  

**Upside(s):**  
1. because openSUSE has intelligent, centralized, and fine grained control over all aspects, despite upstream of DE.  
2. using the tools ensure that the process is done right/completely, despite what the end-user thinks they understand about unix/linux  

**Downside(s)**  
1. tutorials are more limited than more standard distro (centos, redhat, fedora, arch)  
2. adds distro-specific stuff for the end-user to know about/learn  
2. This layer is mostly gui  
These aren't strong, but raise the flag of whether it is worth it for the (few) benefits.  

### Getting started:
**packages (util):**  
`zypper in hplip nfs4-acl-tools git htop`  
[markdown extension for browser](https://github.com/simov/markdown-viewer) (best markdown find to date!)

**packages (preference):**  
`zypper in materia-gtk-theme paper-icon-theme`  
`zypper rm gnome-software PackageKit`  

**opensuse-multimedia-libs:**  
```
sudo zypper ar -f http://ftp.gwdg.de/pub/opensuse/repositories/multimedia:/libs/openSUSE_Tumbleweed/ opensuse-multimedia-libs
sudo zypper ref
```
### Configuration:
#### NFS/ACL:
**fstab mount options for NFS shares:**  
`defaults,x-systemd.automount,x-systemd.requires=network-online.target`  
ensures that NFS shares are mounted upon resume  
ref:[Arch wiki: Mount using /etc/fstab with systemd](https://wiki.archlinux.org/index.php/NFS#Mount_using_/etc/fstab_with_systemd)  

**add relevant groups**  
append groups to users appropriately  
(see [Fileshare] for details)  

_/etc/idmapd.conf_  
**uncomment & enter domain-name** <- same name as used in server idmapd.conf  
```
Domain = sameDomainNameHere
```
**Enable (& start) rcpbind service**  
`systemctl enable rpcbind`  
`systemctl start rpcbind`  
#### NetworkManager vs. Wicked:  
- for laptop? NetworkManager. full stop.  
- I like the configurability of Wicked, but it lacks gnome integration (applet)  
**Service switch (to [Wicked])**  
`systemctl status network` #show/verify which service is managing the network, and its status  
`systemctl stop network` #stop the network (& assigned services)  
`systemctl disable NetworkManager`  
`systemctl enable wicked`  
`systemctl start network`  #start the network (& assigned services)  
`systemctl status network`  #show/verify which service is managing the network, and its status  

#### static ip:
Use gateway ip for dns server address (& routing).  

CLI setup differs per service chosen  
**If Wicked:**  
_/etc/sysconfig/network/ifcfg-p4p1_  
``` 
BOOTPROTO='static'  
STARTMODE='auto'  
IPADDR='192.168.9.14/24'  
```
_/etc/sysconfig/network/routes_  
``` 
default 192.168.9.1 - -  
```
_/etc/sysconfig/network/config_  
```
NETCONFIG_DNS_STATIC_SERVERS="192.168.9.1"  
```
 
**If NetworkManager**, ~[three files need to be modified](https://forums.opensuse.org/showthread.php/431523-Configure-Static-Ip-using-the-Terminal?p=2109330#post2109330) if not done through the gui.  

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

**If wicked**, theres an xml to spar with (unexplored)  
_/etc/wicked/*.xml_  
see:  
https://www.suse.com/documentation/sles-12/book_sle_admin/data/sec_basicnet_manconf.html  
https://github.com/openSUSE/wicked/blob/master/README  

[Fileshare]: ../html/fileshare.html#acl-setup
[Wicked]: https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.network.html#sec.network.manconf.using_wicked

