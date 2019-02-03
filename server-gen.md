# Gnu/Linux Generic bringup

**Display Attached** (Workstation):  
- Install (& configure)  
- upgrade/update installation  
- Establish/verify ssh connectivity  
  - no? firewall? mismatched host keys?
  - `rm -f /etc/ssh/ssh_host_*` #hostkey cleanup  
  - `firewall-cmd --add-port=22/tcp --zone=external --permanent`
  - `firewall-cmd reload`
- Server bringup? proceed to [Headless Management](#headless-management-).  
Else, ...  

#### Headless Management:
- [filesharing](fileshare.md)
  - Users/Groups
  - ACL
  - Samba
  - NFS
- [Tvheadend](server-tvh.md)
- [Transmission](server-trans.md)

#### _info:_
```
192.168.9.1 #nighthawk router
192.168.9.0/24 #cidr notation
255.255.255.0 #subnet mask
```
#### _/etc/hosts:_
```
192.168.9.11 attic11 attic11.dubnet  
192.168.9.13 media13 media13.dubnet dubserv dubserv.dubnet  
192.168.9.12 kodi12 kodi12.dubnet  
192.168.9.14 kodi14 kodi14.dubnet  
192.168.9.212 hp60504a envy212 envy212.dubnet  
```
### Gateway # changed?

Adjust :
1.  [static ip#]
2.  /etc/hosts    
3.  /etc/sysconfig/network-scripts/ifcfg-enp3s0    
4.  /var/lib/tvheadend/config/acesscontrol/<each-entry>    
5.  [/etc/samba/smb.conf](fileshare.md#anchor-name) :: hosts allow = 127.0.0.1 192.168.1.0/24 192.168.0.0/24    
6.  [Transmission whitelist](https://docs.google.com/document/d/132OtnNEct4Tq5RttY6y-o7q-nbPIiA0URXFTSBOZFmc/edit#heading=h.nincxsovj0c4): /var/lib/transmission/.config/transmission-daemon/settings.json      
7.  nfs config: /etc/exports

### Netmask CIDR Notation

-   [explanation](http://blog.michaelhamrah.com/2015/05/networking-basics-understanding-cidr-notation-and-subnets-whats-up-with-16-and-24/)
-   [cheatsheet](https://oav.net/mirrors/cidr.html)

[Add & grow an array](https://superuser.com/questions/1061516/extending-raid-1-array-with-different-size-disks)  


## Backup

Duplicity

[ref_05](https://www.tecmint.com/create-encrypted-linux-file-system-backups-using-duplicity/2/) :: [ref_01](http://www.ifdattic.com/howto-encrypted-backup-with-duplicity/) :: [ref_02](https://www.vultr.com/docs/creating-incremental-and-encrypted-backups-with-duplicity) :: [ref_03](https://help.ubuntu.com/community/DuplicityBackupHowto) :: [ref_backblaze](https://help.backblaze.com/hc/en-us/articles/115001518354-How-to-configure-Backblaze-B2-with-Duplicity-on-Linux) :: [ref_06](https://fedoramagazine.org/taking-smart-backups-duplicity/)  

Backblaze b2
https://secure.backblaze.com/user_signin.htm  

backup across network
```
rsync -ave ssh user@server:/path/to/file /home/user/path/to/file
rsync -avHe ssh cyril@192.168.0.13:/storage/share/Pictures /storage/backup/Pictures --delete
```

# Client

## Interface

(from other networked PC)

**Web interface:**  
```
192.168.1.13:9090 #Cockpit server management
192.168.1.13:9091 #transmission torrent client
192.168.1.13:9981 #tvheadend pvr backend
```

**Terminal:**  
`ssh <userQ>@192.168.1.13` #ssh to terminal session as "userQ"  
`ssh 192.168.x.y` #ssh as current user

**File browser**  
```
smb://<hostname>/<share_name> #Linux Access samba share
smb://<ip_address>/<share_name> #Linux Access samba share

\\<hostname>\<share_name> #Windows browse to samba share
\\<ip_address>\<share_name> #Windows browse to samba share
```
