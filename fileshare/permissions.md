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

group | gid | cyril | kodi | tvheadend
---:	|:---:|:---:|:---:|---
docs | 1305 | x | x | -
media | 1306 | x | x | x
samba | 1307 | x | - | -
keeper	| 1308 | x | - | -

# posix + gid-bit

Each directory can only involve one group, so the **share-ability is managed only by appending groups to users**  

### Important:  
When the bit is set for a directory, the set of files in that directory will have the same group as the group of the parent directory, and not that of the user who created those files. This is used for file sharing since they can be now modified by all the users who are part of the group of the parent directory.


To set or remove the setgid bit, use the following commands.  
```
chmod g+s
chmod g-s
```
To locate/verify the setgid bit, look for an ‘s’ in the group section of the file permissions, as shown in the example below.  
```
-rwxrwsr-x root root 1427 Aug 2 2019 sample_file
```

### group ownership:
`chown -R :group path/to/directory`  

### directory gid-bit:
**chmod directories only:**  
`find /path/to/dir -type d -exec echo chmod g+s {} \;`  
`find /path/to/dir -type d -exec chmod g+s {} \;`  
**chmod all:**  
`chmod -R g+rws` # recursively sets group permissions to rwx, where 's' indicates that the gid bit has been set.  
append groups to users as needed (test)

# ACL

Allows appending multiple users or groups to one directory, each with different permissions, greatly increasing flexibility.  
Not as apparent/convenient/readable (locally over a network connection) as posix options.  

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

