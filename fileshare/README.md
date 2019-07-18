# File Sharing
- Permissions
  - [Users/Groups](permissions.md#usersgroups)
  - [Posix + gid-bit](permissions.md#posix--gid-bit)  
  - [ACL](permissions.md#acl)  
- Network Filesharing
  - [autofs](autofs.md)  
  - [NFS](fileshare.md#nfs)  
  - [Samba](fileshare.md#samba)  

## Users/groups
Useful filesharing/permission scheme starts with good group/filesystem scheme.  
I have settled on grouping for functionality (not location), and am leaning toward ACL to manage permissions.  

Whichever method, the relevant groups/user assignments must exist on both server and client for NFSv4.  

 name	| gid	| cyril	| kodi	| tvheadend
---:	|:---:	|:---:	|:---:	|---
docs	| 1305	| x	| x	| -
media	| 1306	| x	| x	| x
samba	| 1307	| x	| -	| -
keeper	| 1308	| x	| -	| -

## posix + gid-bit
Each directory can only involve one group, so the **share-ability is managed only by appending groups to users**  

## ACL
Allows appending multiple users or groups to one directory, each with different permissions, greatly increasing flexibility.  
Not as apparent/convenient/readable (locally over a network connection) as posix options, but lacks the reduction of security brought by umask edits.  
