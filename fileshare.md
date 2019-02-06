# File Sharing
[Samba](#samba)  
[NFS](#nfs)  
[ACL](#acl-setup)  
[Notes](#group-manipulation-notes) 

# Samba
### Windows to *nix fileshare protocol
### Server:
**Install**  
`dnf install samba samba-client samba-common`  

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
`groupadd smbgrp` #Create a new group  
`usermod -a -G smbgrp cyril` #add secondary group to existing user  
`useradd cyril -G smbgrp` #Create a new user & add to smbgrp  
`smbpasswd -ae cyril` #Create (& enable) a Samba password for the user  

**Filesystem:**  
`chmod -R 0770 /path/to/goods` #Change the permissions of the folder  
`chown -R root:smbgrp /path/to/goods` #Change the ownership of the folder  

**Test the newly saved entry & restart samba services**  
`testparm`  
`systemctl restart smb nmb`  

**Works? then enable both smb & nmb services**  
`systemctl enable smb nmb`  

**nmb service is avc denied when selinux is enforcing ?**  
`ausearch -c 'nmbd' --raw | audit2allow -M my-nmbd`  
`semodule -i my-nmbd.pp`  
`systemctl restart nmb`  

#### fstab
**Login credentials**  
Should be kept in a separate, more secure file, so NOT world-readable:  

_/ect/fstab_ example-entry:
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
See [fstab archive] for examples that have been used in dubnet  

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

# NFS
### nix to *nix fileshare protocol
#### nfs-share setup, Performed on Fedora 29 server & client

### Server:
**Install**  
`dnf -y install nfs-utils rpcbind `  

**find (or create) domain name, for use in /etc/idmap.conf**  
`hostname -d` #returns domain name if present  
`hostnamectl set-hostname frip.frop` #sets host-name to frip, and domain-name to frop  

**/etc/idmapd.conf**
```
# line 5: uncomment and change to your domain name
Domain = frop
```
**Configure what is exported, and with-whom to share**  

**/etc/exports:**  
`/storage/share 192.168.0.0/24(rw,sync,subtree_check)`  
`/storage/share 192.168.1.0/24(rw,sync,subtree_check)`  

**start (& enable) the service(s)**  
`systemctl start nfs-server rpcbind rpc-statd nfs-idmapd`  
`systemctl enable nfs-server rpcbind`  

**Configure firewall to allow client servers to access NFS shares**  
`firewall-cmd --permanent --add-service nfs`  
`firewall-cmd --permanent --add-service mountd`  
`firewall-cmd --permanent --add-service rpc-bind`  
`firewall-cmd --reload`  

**see shares export correctly**  
`exportfs -rav`  

### Client:
define server host-name&ip in /etc/hosts?  
**install**  
`dnf -y install nfs-utils rpcbind`  

**/etc/idmapd.conf**  
```
# line 5: uncomment and change to your domain name
Domain = home
```
**start (& enable) the service**  
`systemctl start rpcbind`  
`systemctl enable rpcbind`  

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
 
# ACL setup:
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
-x | remove acl  

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

#### Group manipulation notes:
**create the groups that we want, and append them to appropriate users**  
(specific gid not required)  
```
groupadd -g 1301 guests
groupadd -g 1302 royalty
groupadd -g 1303 builder
usermod -aG guests kodi
usermod -aG royalty cyril
```
**remove user from group**  
`usermod -G cyril,wheel cyril` #group for removal is omitted from list  

**list all members of a group**  
`grep 'group-name-here' /etc/group`  

https://www.tecmint.com/secure-files-using-acls-in-linux/
https://www.2daygeek.com/how-to-configure-access-control-lists-acls-setfacl-getfacl-linux/#
https://www.geeksforgeeks.org/access-control-listsacl-linux/

Notes:
nfs4

df -T showed me that the filesystem was mounted as nfs4 which apparently needs to be accessed from the client using nfs4_getfacl tools

[kodi@kodibox storage]$ sudo nfs4_setfacl -R -a A:dfg:builder:RWX workshop --test

decode this shit!
https://www.osc.edu/book/export/html/4523

[fstab archive]:fstab.md