## Client via autofs

### indirect
_/etc/auto.master_
```
/mnt /etc/auto.mnt
```
_/etc/auto.mnt_
```
mediaShare -fstype=nfs dubserv:/storage/share
```

### direct
_/etc/auto.master_
```
/- /etc/auto.mediaShare
```
_/etc/auto.mediaShare_
```
/mnt/mediaShare -fstype=nfs dubserv:/storage/share
```

### Tip
create a symbolic link from some useful, logical place to the mount point (facilitates [browseability])
```
ln -s /nfs/mediashare /home/
```
### Use it
```
systemctl start autofs #inspect for functionality
systemctl enable autofs #make it real
```
This mounts the remote filesystem at /mnt/mediaShare, and is linked at /home/mediaShare

### Browseability
Without a symbolic link to a subdirectory of the mount, the share is not as easily found when browsing from file-browser or commandline.  
To make the mount point browseable:  
_/etc/auto.master_
```
/mnt /etc/auto.mnt browse
```

Enabling `browse` (or the deprecated --ghost) in auto.master  
https://wiki.gentoo.org/wiki/AutoFS/en#Useful_options
>can be useful for indirect mounts. It causes AutoFS to create the directory on which something would be mounted when the automount daemon starts up, rather than only when the directory is accessed.

http://www.linuxfromscratch.org/blfs/view/svn/general/autofs.html
>The --ghost option tells the automounter to create “ghost” versions (i.e. empty directories) of all the mount points listed in the configuration file regardless whether any of the file systems are actually mounted or not. This is very convenient and highly recommended, because it will show you the available auto-mountable file systems as existing directories, even when their file systems aren't currently mounted. Without the --ghost option, you'll have to remember the names of the directories. As soon as you try to access one of them, the directory will be created and the file system will be mounted. When the file system gets unmounted again, the directory is destroyed too, unless the --ghost option was given. 

>An alternative method would be to specify another automount location such as /nfs/mediaShare and create a symbolic link from /home/mediaShare to the automount location. 

Specifically useful for tab auto-completion and GUI file browsers.
Without the browse flag (or a symbolic link to the mount point), the user must explicitly type the full path of the share directory or target file.

https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/4/html/System_Administration_Guide/Mounting_NFS_File_Systems-Mounting_NFS_File_Systems_using_autofs.html  
https://opensource.com/article/18/6/using-autofs-mount-nfs-shares  
https://wiki.manjaro.org/index.php?title=Using_autofs_(automount)_with_NFS  
https://wiki.archlinux.org/index.php/Autofs  

[browseability](#browseability)
