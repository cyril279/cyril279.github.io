# fstab

### Notes:
Asign alias to ip's, so that `alias` can be used throughout system, and any ip changes aren't such a mess.  

_/etc/hosts_
```
192.168.x.y  alias alias2
```
[[ Typical dubnet definitions ]](server-gen.md#-etc-hostname-)  

`lsblk` lists information about all or the specified block devices.  
The command prints all block devices (except RAM disks) in a tree-like format by default.  
Typically used to list all available block devices, and their mount points.  

`blkid` can determine the type of content (e.g. filesystem, swap) a block device holds, and also attributes (tokens, NAME=value pairs) from the content metadata (e.g. LABEL or UUID fields).  
Typically used to list uuid’s for fstab entry  

`df -Th` display’s filesystem and lists mount points -T=filesystem type -h=human-readable filesystem size  

[https://wiki.ubuntu.com/MountWindowsSharesPermanently](https://wiki.ubuntu.com/MountWindowsSharesPermanently)  
<< [for format](https://unix.stackexchange.com/a/276318) >>  
[https://serverfault.com/a/815692](https://serverfault.com/a/815692)  
[http://jensd.be/229/linux/mount-windows-cifs-shares-on-linux-with-credentials-in-a-secure-way](http://jensd.be/229/linux/mount-windows-cifs-shares-on-linux-with-credentials-in-a-secure-way)  

### fstab archive:
--------------
**[cyril@kodibox ~]**$ cat /etc/fstab #useful network connection entries 
```
# nfs, ultra-basic:
dubserv:/storage/share /storage/share nfs defaults 0 0
# nfs, automount:
dubserv:/storage/share  /home/storage/mediaShare     nfs    noauto,x-systemd.automount,x-systemd.device-timeout=10,timeo=14,hard,intr,noatime       0 0
# nfs client/remote automount laptop & kodibox:
dubserv:/storage/share/011010		/mnt/dubserv/011010	nfs    x-systemd.automount,nofail,intr,acl,x-systemd.idle-timeout=90sec       0 0
# samba, automount:
//192.168.0.13/share /storage cifs credentials=/root/.cifscred,file_mode=0775,dir_mode=0775,gid=1002,x-systemd.automount 0 0
# server share of NTFS volume:
UUID=F4B2B47CB2B444C0 /storage/share ntfs uid=0,gid=1001,umask=007,nosuid,nodev,nofail,x-gvfs-show,context=system_u:object_r:samba_share_t:s0 0 0
```  
-------
**[cyril@dubserv ~]**$ cat /etc/fstab
``` 
#
# /etc/fstab
# Created by anaconda on Fri Sep 8 06:01:32 2017
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=44b4bbc0-466e-4bc8-9150-fc20b03c836c / xfs defaults 0 0
UUID=2402c1f0-e35d-477d-b9da-20f76d46a999 /boot ext4  defaults 1 2
UUID=A75A-D9E0 /boot/efi vfat  umask=0077,shortname=winnt 0 2
#mdadm raid1 aray:
#/dev/md3 /storage auto  defaults 0 0
UUID=1851e928-1c87-4741-8ef9-abbdcae84b3a /storage auto defaults 0 0
```
-----------
**[cyril@attic ~]**$ cat /etc/fstab
```
#
# /etc/fstab
# Created by anaconda on Thu Jan 3 19:36:14 1980
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=aa68bfbf-684d-4a2b-9df7-b8b613c2df33 / xfs defaults 0 0
UUID=f6268665-66a6-4c48-8996-bf8e9dfe5662 /boot ext4  defaults 1 2
UUID=4b07e3be-123a-470f-9513-700acacdece3 /storage ext4  defaults 1 2
#/dev/md127 /storage/backup auto defaults 0 0
UUID=4a2b3c6d-0ada-4228-8043-7a2f40a13d4a /storage/backup auto  defaults 0 0
dubserv:/storage/share /storage/share nfs defaults 0 0
```
