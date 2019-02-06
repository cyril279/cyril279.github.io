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

### laptop fstab entries (unexplored)  
append to mount options:  
`nofail,x-systemd.device-timeout=1`

or use noauto so that the mount isn't attempted at boot at all  
`noauto,x-systemd.automount,x-systemd.device-timeout=10,timeo=14,x-systemd.idle-timeout=1min`  

ref:  
https://wiki.archlinux.org/index.php/Fstab#External_devices  
https://wiki.archlinux.org/index.php/samba#As_systemd_unit  

### fstab archive:
--------------
**[cyril@kodibox ~]**$ cat /etc/fstab  
```
#
# /etc/fstab
# Created by anaconda on Tue Nov 13 19:51:34 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
UUID=6eb4b0d6-ae28-45c0-b47c-bb34cab12ff9 / xfs defaults 0 0
UUID=47f029ca-da8a-4b0c-a94f-f341d669607b swap swap defaults 0 0
dubserv:/storage/share /storage/share nfs defaults 0 0
dubserv:/storage/workshop /storage/workshop nfs defaults 0 0
```  
-------
**[cyril@kodibox ~]**$ cat /etc/fstab  
``` 
#
# /etc/fstab
# Created by anaconda on Tue Mar 27 14:22:27 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=726d68c4-3536-4c1a-af39-1621ac81f592 / ext4  defaults 1 1
UUID=86a747d2-9a1a-452f-b1ea-58cf647a966f /boot ext4  defaults 1 2
UUID=B010-9763 /boot/efi vfat  umask=0077,shortname=winnt 0 2
UUID=9ff07fcf-0488-41fe-a965-a4c40f84ebcd swap swap  defaults 0 0
//192.168.0.13/share /storage cifs credentials=/root/.cifscred,file_mode=0775,dir_mode=0775,gid=1002,x-systemd.automount 0 0
```
----
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
UUID=e033ab5a-d35f-469a-a634-fdf3c8a907f4 /storage/workshop auto defaults 0 0
```
-----------
**[kodi@dubserv ~]**$ cat /etc/fstab
```
#
# /etc/fstab
# Created by anaconda on Fri Sep 8 06:01:32 2017
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=44b4bbc0-466e-4bc8-9150-fc20b03c836c /  xfs  defaults  0 0
UUID=2402c1f0-e35d-477d-b9da-20f76d46a999 /boot  ext4  defaults  1 2
UUID=A75A-D9E0  /boot/efi  vfat  umask=0077,shortname=winnt  0 2
UUID=e9f50c5e-e197-4097-9f7b-bc3e595e956e /storage/dubstuff  ext4  defaults  1 2
UUID=0d633305-1486-470e-97ff-d6a9b082830a /storage/backup  ext4  defaults  1 2
UUID=F4B2B47CB2B444C0 /storage/share ntfs uid=0,gid=1001,umask=007,nosuid,nodev,nofail,x-gvfs-show,context=system_u:object_r:samba_share_t:s0 0 0
UUID=74495b5c-ba26-4b31-b06c-0d28a5ed8399 swap  swap  defaults  0 0
```
--------
**[cyril@nine ~]**$ cat /etc/fstab
```
#
# /etc/fstab
# Created by anaconda on Mon Jan 22 20:19:54 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=ea757132-a8fe-4b00-a330-1572aa5d631f swap swap  defaults 0 0
UUID=810775f8-9edd-487d-bfb1-035ed3852cb9 / ext4  defaults 1 1
UUID=fb3ccb29-0b73-41ef-a480-cbaefa93436e /data ext4  errors=remount-ro 0 2
```
------------
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
