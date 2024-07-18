# Server Config

## NFS
*nix to *nix fileshare protocol
**nfs-share setup, Performed on Fedora 29 server & client**  

### Fedora:
**Install**  
```sh
dnf -y install nfs-utils rpcbind
```
**start (& enable) the service**  
```sh
systemctl start rpcbind
systemctl enable rpcbind  
```
**show available mounts from server (must specify server)**  
```sh
showmount -e 192.168.0.13
```  

**start (& enable) the service(s)**  
```sh
systemctl start nfs-server rpcbind rpc-statd nfs-idmapd
systemctl enable nfs-server rpcbind
```  

### openSUSE
**Install (MicroOS,Aeon)**  
```sh
transactional-update pkg in -t pattern file_server
```

**Install (Tumbleweed,Leap)**  
```sh
zypper in -t pattern file_server
```  
>The NFS server is not part of the default installation  
([Suse docs:22.2](https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.nfs.html#sec.nfs.installation))  

>The configuration files for the NFS export services:  
_/etc/exports_  
_/etc/sysconfig/nfs_  
([SUSE docs:22.3.2](https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.nfs.html#sec.nfs.export.manual))  

**start/enable associated services**  
```sh
systemctl restart nfsserver
systemctl enable nfsserver
```  

### Distro-agnostic
_/etc/idmapd.conf_  
**uncomment & enter domain-name** <- same name as used in server idmapd.conf  
```conf
Domain = sameDomainNameHere
```
**Configure what is exported, access permissions, and with-whom to share**  
_/etc/exports_  
```sh
/storage/share 192.168.1.0/24(rw,sync,subtree_check)
#NOTE: all users must have uid & gid defined the same on all machines, or strange things happen with the share (like question-marks instead of permissions displayed)   
```
...or options per [ kodi.wiki.nfs ](https://kodi.wiki/view/NFS#NFS_sharing_from_Linux)  
```sh
/storage/share 192.168.9.0/24(rw,sync,all_squash,anonuid=1001,anongid=1306,subtree_check)
```

**Configure firewall to allow client servers to access NFS shares**  
```sh
firewall-cmd --permanent --add-service nfs
firewall-cmd --permanent --add-service mountd
firewall-cmd --permanent --add-service rpc-bind
firewall-cmd --reload
```  

**Verify shares export as expected**  
```sh
exportfs -rav
```  

Info: http://www.troubleshooters.com/linux/nfs.htm

## Samba
Windows to *nix fileshare protocol

**Fedora**  
```sh
dnf install samba samba-client samba-common
```  

**openSUSE**  
[[ samba guide ](https://forums.opensuse.org/content.php/199-Configure-Samba-for-Local-Lan-Workgroup)]  
[ https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.samba.html ]

**Configure**  
(backup original conf file)  
/etc/samba/smb.conf  
```conf
netbios name = dubserv
hosts allow = 127.0.0.1 192.168.9.0/24
workgroup = WORKGROUP
add/configure share entry(ies)
[dubstuff]
    comment = media 640 as ext4
    path = /storage/dubstuff
    valid users = @royalty
    create mask = 0775
    create mode = 0775
    browsable = yes
    writable = yes
    read only = no

[media]
    comment = media 3tb as ntfs
    path = /storage/share
    valid users = @smbgrp,@guests,@royalty
    browsable = yes
    writable = yes
    read only = no
```
**Configure firewall to allow samba service**  
```sh
firewall-cmd --permanent --add-service=samba
firewall-cmd --permanent --add-service=samba-client
firewall-cmd --reload
```  

**SEManage the shared directory**  
```sh
dnf install policycoreutils-python-utils
semanage fcontext -a -t samba_share_t '/path/to/goods(/.*)?'
restorecon -Rv /path/to/goods
```

**If shared volume is NTFS partition: edit NTFS fstab entry**  
```sh
context=system_u:object_r:samba_share_t:s0
```
#### Samba Users, groups, & permissions
**User:**  
```sh
groupadd samba #Create a new group  
usermod -a -G samba cyril #add secondary group to existing user  
useradd cyril -G samba #Create a new user & add to smbgrp  
smbpasswd -a cyril #Create a Samba password for the user  
smbpasswd -e cyril #Enable Samba user  
```
**Filesystem:**  
```sh
chmod -R 0770 /path/to/goods #Change the permissions of the folder  
chown -R root:samba /path/to/goods #Change the ownership of the folder  
```
**Test the newly saved entry & restart samba services**  
```sh
testparm
systemctl restart smb nmb
```
**Works? then enable both smb & nmb services**  
```sh
systemctl enable smb nmb
```
**nmb service is avc denied when selinux is enforcing ?**  
```sh
ausearch -c 'nmbd' --raw | audit2allow -M my-nmbd
semodule -i my-nmbd.pp
systemctl restart nmb
```
<=========>
# Client Config

## Software
- ### Fedora  
**Install**  
```sh
dnf -y install nfs-utils rpcbind
```
  
  **start (& enable) the service**  
```sh
systemctl start rpcbind
systemctl enable rpcbind
```  

- ### openSUSE
**Install**  
>To configure your host as an NFS client, **you do not need to install additional software**. All needed packages are installed by default.  
([SUSE docs:22.4](https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.nfs.html#sec.nfs.configuring-nfs-clients))  

  **verify that nfs.service is active & enabled**  
>The prerequisite for importing file systems manually from an NFS server is a running RPC port mapper. The nfs service takes care to start it properly  
([SUSE docs:22.4.2](https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.nfs.html#sec.nfs.import))  

- ### Distro-agnostic
_/etc/idmapd.conf_  
**uncomment & enter domain-name** <- same name as used in server idmapd.conf  
```
Domain = sameDomainNameHere
```
**show available mounts from server (must specify server)**  
```sh
showmount -e 192.168.0.13
```

## Method: fstab
Connecting via entry appended to _/etc/fstab_

- ### NFS
```sh
(ip OR alias)
dubserv:/storage/share /storage/share                       nfs     defaults        0 0
dubserv:/storage/share  /home/storage/mediaShare     nfs    noauto,x-systemd.automount,x-systemd.device-timeout=10,timeo=14,hard,intr,noatime	0 0
```
- noauto: don't mount automatically at boot
- x-systemd.automount: create an automount entry to mount this upon access
- x-systemd.device-timeout: length of time to attempt connecting to the device
- timeo: Length of time in-between attempts to connect
- hard: If the NFS server is unresponsive, requests will be retried indefinitely
- intr: Interruptible: When the server comes back online, the process can be continued from where it was while the server became unresponsive
- noatime: Do not record the access times (unecessary action that slows things down)

https://linoxide.com/file-system/example-linux-nfs-mount-entry-in-fstab-etcfstab/  
-[Arch wiki: Mount using /etc/fstab with systemd](https://wiki.archlinux.org/index.php/NFS#Mount_using_/etc/fstab_with_systemd)  
see [fstab archive](../fstab.md#fstab-archive) for more examples

- ### SAMBA
```
//w.x.y.z/Home$ /mnt/dir cifs credentials=/root/cifs.creds,sec=ntlmssp,file_mode=0700,dir_mode=0700`  
```
  
  _/root/cifs.creds_ | **owned by:** root:root | **permissions:** 0400  
```
domain=A
username=B
password=C
```
A, B and C above must be literal - there's no shell-like parsing of quotes or backslashes.  

  **other mounting info:**
>Add mount entry to /etc/fstab.  
>For avoiding mounting SMB before network initialization, you need to add _netdev option.  
>For making x-systemd.automount to mount SMB, you need to add x-systemd.automount to option.  

[more _netdev stuff](https://ervikrant06.wordpress.com/2014/09/30/what-happens-after-adding-_netdev-option-in-fstab/)  
See [fstab archive] for more examples  

### Client: Windows:

-   [forcing windows to update samba login credentials](https://serverfault.com/a/268944)
-   Close all apps/windows using any shares
-   [ super-key ] > “credentials” > edit or remove credentials as needed
-   nuke all shares (covers 192.168.1.13, 192.168.1.9, Dubserv, dubserv)
`net use * /delete`  
-   OR view connections on a specific server, then delete specific share  
`net view \\SERVERNAME`  
`net use \\SERVERNAME /delete`  
-   establish desired share credentials
`net use \\SERVERNAME\SHARENAME /u:USERNAME`  
-   log-off and back on (restarts services & dependencies)

[another method](https://serverfault.com/questions/326255/how-can-i-clear-the-authentication-cache-in-windows-7-to-a-password-protected/500270#500270)  
[thorough method](https://superuser.com/a/352272)    
[Map drive letter to samba share](https://www.laptopmag.com/articles/map-network-drive-windows-10)  
[Map a drive letter via CLI](https://www.howtogeek.com/118452/how-to-map-network-drives-from-the-command-prompt-in-windows/)  

**https://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-setup-nfs-server-on-centos-7-rhel-7-fedora-22.html
https://www.server-world.info/en/note?os=Fedora_28&p=nfs&f=1
https://www.server-world.info/en/note?os=Fedora_28&p=nfs&f=2
https://linuxconfig.org/how-to-configure-a-nfs-file-server-on-ubuntu-18-04-bionic-beaver#h7-2-configure-your-exports
https://www.tecmint.com/how-to-setup-nfs-server-in-linux/
https://blackcatsoftware.us/fedora-27-configure-nfs-server-and-client/

domain name info:
https://www.lifewire.com/everything-you-need-to-know-about-the-domainname-command-4066531

