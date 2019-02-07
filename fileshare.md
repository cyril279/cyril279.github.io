# File Sharing
- Permissions
  - [Users/Groups](#users-groups)
  - [Posix + gid-bit](#posix-gid-bit)  
  - [ACL](#acl)  
- Network Filesharing
  - [NFS](#nfs)  
  - [Samba](#samba)  

Useful filesharing/permission scheme starts with good group/filesystem scheme.  
I have settled on grouping for functionality (not location), and am leaning toward ACL to manage permissions.  

Whichever method, the relevant groups/user assignments must exist on both server and client for NFSv4.  
They are synchronized using `rpcbind.service`.  

# Users/Groups
**create the groups that we want, and append/apply them to appropriate users**  
(specific gid not required, but can help interpretation)  
```
groupadd -g 1305 docs
groupadd -g 1306 media
groupadd -g 1307 samba
usermod -aG media kodi
usermod -aG docs cyril
```
or do it all from _/etc/group:_  
```
docs:x:1305:cyril
media:x:1306:cyril,kodi,transmission,tvheadend
keeper:x:1308:cyril
```

**remove user from group**  
`usermod -G cyril,wheel cyril` #group for removal is omitted from list  

**list all members of a group**  
`grep 'group-name-here' /etc/group`  

#### Config
 +	| gid | cyril | kodi | tvheadend
---:	|:---:|:---:|:---:|---
docs | 1305 | x | x | -
media | 1306 | x | x | x
samba | 1307 | x | - | -
keeper	| 1308 | x | - | -

# posix + gid-bit

Each directory can only involve one group, so the **share-ability is managed only by appending groups to users**  

### Important:  
umask must be changed so that newly created files can be writen by group.  
This can be set per user, or system-wide. Not obvious which approach is worse for security.  
Setting system wide is easier (one change), but affects all future created users AND the files they create, and is limited to local machine, so this would have to be done on every machine?  

Although locally & visually convenient, this does not seem like the ideal approach to network fileshare permission handling.  

### Process:
_https://unix.stackexchange.com/questions/12842/make-all-new-files-in-a-directory-accessible-to-a-group_  
- adjust umask to allow group write; everyone must do this
- set ownership of directory group as needed
- set directory gid

### umask:
**user-specific change:**  
_~/.bashrc_  
If not already present, append the following line  
`umask 002`

**System-wide change:**  
`grep UMASK /etc/login.defs`  
_/etc/login.defs_  
```
UMASK		002
```

### group ownership:
`chown -R :group path/to/directory`  

### directory gid-bit:
**chmod directories only:**  
`find /path/to/dir -type d -exec echo chmod g+s {} \;`  
`find /path/to/dir -type d -exec chmod g+s {} \;`  
**chmod all:**  
`chmod -R g+rws` # recursively sets group permissions to rwx, where s indicates that the gid bit has been set.  
append groups to users as needed (test)

# ACL

Allows appending multiple users or groups to one directory, each with different permissions, greatly increasing flexibility.  
Not as apparent/convenient/readable (locally over a network connection) as posix options, but lacks the reduction of security brought by umask edits.  

**check for acl support in kernel**  
`grep -i acl /boot/config*`  

**install/verify required packages**  
`dnf install nfs4-acl-tools acl libacl`  
  
**set the directory privileges [[does not affect existing files]]**  

option | function  
:--: | :---  
-R | applied recursively  
-d | sets default at directory, affects newly created files  
-m | modify  
-x | remove specific acl attiribute  
-b | remove acl 

group:guests  
permissions:rwx  
directory: /storage/share  
`setfacl -Rdm g:guests:rwx /storage/share`  
`setfacl -Rdm g:royalty:rwx /storage/share`  
**stackable**  
`setfacl -Rdm g:guests:rwx,g:royalty:rwx /storage/share`  
**alternate usage**  
`setfacl -Rm d:g:guests:rwx,g:royalty:rwx /storage/share`  

**set the file-level privileges [[does not affect directories, so newly created files will not heed ACL]]**  
`setfacl -Rm g:guests:rwx /storage/share`  
`setfacl -Rm g:royalty:rwx /storage/share`  

[[maybe not needed]]
**recursively cd set (default) mask?**  
`setfacl -Rm d:m:rwx .`  
`setfacl -Rm m:rwx .`  

**verify/view ACL’s**  
`getfacl /storage/share`  

**-x remove acl**  
`sudo setfacl -Rx d:g:guests /storage/workshop.kodi/` recursively remove ‘guests’ acl from directory  
`sudo setfacl -Rx g:guests /storage/workshop.kodi/` recursively remove ‘guests’ acl from files  

**-b remove ACL
`setfacl -b foobar` removes all ACL-ness from `foobar`  

https://www.tecmint.com/secure-files-using-acls-in-linux/  
https://www.2daygeek.com/how-to-configure-access-control-lists-acls-setfacl-getfacl-linux/#  
https://www.geeksforgeeks.org/access-control-listsacl-linux/  

Notes:  
nfs4  

df -T showed me that the filesystem was mounted as nfs4 which apparently needs to be accessed from the client using nfs4_getfacl tools

[kodi@kodibox storage]$ sudo nfs4_setfacl -R -a A:dfg:builder:RWX workshop --test

decode this shit!  
https://www.osc.edu/book/export/html/4523  

# NFS
### nix to *nix fileshare protocol
**nfs-share setup, Performed on Fedora 29 server & client**  

## Server:
### Fedora
**Install**  
`dnf -y install nfs-utils rpcbind `  

**start (& enable) the service(s)**  
`systemctl start nfs-server rpcbind rpc-statd nfs-idmapd`  
`systemctl enable nfs-server rpcbind`  

### openSUSE
**Install**  
`zypper in -t pattern file_server`  
>The NFS server is not part of the default installation  
([Suse docs:22.2](https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.nfs.html#sec.nfs.installation))  

>The configuration files for the NFS export services:  
_/etc/exports_  
_/etc/sysconfig/nfs_  
([SUSE docs:22.3.2](https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.nfs.html#sec.nfs.export.manual))  

**start/enable associated services**  
`systemctl restart nfsserver`  
`systemctl enable nfsserver`  

### Distro-agnostic
_/etc/idmapd.conf_  
**uncomment & enter domain-name** <- same name as used in server idmapd.conf  
```
Domain = sameDomainNameHere
```
**Configure what is exported, and with-whom to share**  
_/etc/exports_  
`/storage/share 192.168.0.0/24(rw,sync,subtree_check)`  
`/storage/share 192.168.1.0/24(rw,sync,subtree_check)`  

**Configure firewall to allow client servers to access NFS shares**  
`firewall-cmd --permanent --add-service nfs`  
`firewall-cmd --permanent --add-service mountd`  
`firewall-cmd --permanent --add-service rpc-bind`  
`firewall-cmd --reload`  

**see shares export correctly**  
`exportfs -rav`  

## Client:
### Fedora
**Install**  
`dnf -y install nfs-utils rpcbind `  

**start (& enable) the service**  
`systemctl start rpcbind`  
`systemctl enable rpcbind`  

### openSUSE
**Install**  
>To configure your host as an NFS client, **you do not need to install additional software**. All needed packages are installed by default.  
([SUSE docs:22.4](https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.nfs.html#sec.nfs.configuring-nfs-clients))  

**verify that nfs.service is active & enabled**  
>The prerequisite for importing file systems manually from an NFS server is a running RPC port mapper. The nfs service takes care to start it properly  
([SUSE docs:22.4.2](https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.nfs.html#sec.nfs.import))  

**fstab entry** (options appended)  
`defaults,x-systemd.automount,x-systemd.requires=network-online.target`  
[Arch wiki: Mount using /etc/fstab with systemd](https://wiki.archlinux.org/index.php/NFS#Mount_using_/etc/fstab_with_systemd)  

### Distro-agnostic
_/etc/idmapd.conf_  
**uncomment & enter domain-name** <- same name as used in server idmapd.conf  
```
Domain = sameDomainNameHere
```
**show available mounts from server (must specify server)**  
`showmount -e 192.168.0.13`  

**append nfs entry to /etc/fstab**  
```
(ip OR alias)
dubserv:/storage/share /storage/share                       nfs     defaults        0 0
192.168.0.13:/storage/share /storage/share               nfs     defaults        0 0
```
**https://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-setup-nfs-server-on-centos-7-rhel-7-fedora-22.html  
https://www.server-world.info/en/note?os=Fedora_28&p=nfs&f=1  
https://www.server-world.info/en/note?os=Fedora_28&p=nfs&f=2  
https://linuxconfig.org/how-to-configure-a-nfs-file-server-on-ubuntu-18-04-bionic-beaver#h7-2-configure-your-exports  
https://www.tecmint.com/how-to-setup-nfs-server-in-linux/  
https://blackcatsoftware.us/fedora-27-configure-nfs-server-and-client/  

domain name info:
https://www.lifewire.com/everything-you-need-to-know-about-the-domainname-command-4066531

gvfs-nfs
nfs://dubserv.home:/storage/share
 
# Samba
### Windows to *nix fileshare protocol
### Server:
**Fedora**  
`dnf install samba samba-client samba-common`  

**openSUSE**  
[[ samba guide ](https://forums.opensuse.org/content.php/199-Configure-Samba-for-Local-Lan-Workgroup)]  
[ https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.samba.html ]

**Configure**  
(backup original conf file)  
/etc/samba/smb.conf  
```
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
`firewall-cmd --permanent --add-service=samba `  
`firewall-cmd --permanent --add-service=samba-client`  
`firewall-cmd --reload`  

**SEManage the shared directory**  
`dnf install policycoreutils-python-utils`  
`semanage fcontext -a -t samba_share_t '/path/to/goods(/.*)?'`  
`restorecon -Rv /path/to/goods`  

**If shared volume is NTFS partition: edit NTFS fstab entry**  
`context=system_u:object_r:samba_share_t:s0`  

#### Users, groups, & permissions
**User:**  
`groupadd samba` #Create a new group  
`usermod -a -G samba cyril` #add secondary group to existing user  
`useradd cyril -G samba` #Create a new user & add to smbgrp  
`smbpasswd -a cyril` #Create a Samba password for the user  
`smbpasswd -e cyril` #Enable Samba user  

**Filesystem:**  
`chmod -R 0770 /path/to/goods` #Change the permissions of the folder  
`chown -R root:samba /path/to/goods` #Change the ownership of the folder  

**Test the newly saved entry & restart samba services**  
`testparm`  
`systemctl restart smb nmb`  

**Works? then enable both smb & nmb services**  
`systemctl enable smb nmb`  

**nmb service is avc denied when selinux is enforcing ?**  
`ausearch -c 'nmbd' --raw | audit2allow -M my-nmbd`  
`semodule -i my-nmbd.pp`  
`systemctl restart nmb`  

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

