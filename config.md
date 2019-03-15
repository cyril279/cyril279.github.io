### Groups
**_/etc/group:_**  
```
docs:x:1305:cyril
media:x:1306:cyril,kodi,transmission,tvheadend
samba:x:1307:cyril
keeper:x:1308:cyril
```

**list all members of a group**  
`grep 'group-name-here' /etc/group`  

**Config:**
 +	| gid | cyril | kodi | tvheadend
---:	|:---:|:---:|:---:|---
docs | 1305 | x | x | -
media | 1306 | x | x | x
samba | 1307 | x | - | -
keeper	| 1308 | x | - | -

#### Services:
List service & port mapping?
_/etc/services:_
```
???  
```
#### _firewalld:_  
```
network interface; default zone: internal  
tcp: 9981, 9982, 9091 #tvh, tvh, transmission  
service-name: mountd, nfs, samba, samba client, ssh  
```
#### Network info:
```
192.168.9.1 #nighthawk router  
192.168.9.0/24 #cidr notation  
255.255.255.0 #subnet mask  
```
#### _/etc/hosts:_
```
192.168.9.11 attic11 attic11.dubnet  
# 192.168.9.13 media13 media13.dubnet dubserv dubserv.dubnet  
# 192.168.9.12 kodi12 kodi12.dubnet  
192.168.9.14 kodi14 kodi14.dubnet  
192.168.9.15 media15 media15.dubnet dubserv dubserv.dubnet
192.168.9.212 hp60504a envy212 envy212.dubnet  
```
#### _/etc/samba/smb.conf:_  
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

#### _dobackup.sh:_
```
#!/bin/sh

sourceMachine="dubserv"
sshPath="$USER@$sourceMachine:"
sourcePath="/storage/"
destPath="/storage/backup/"

sourceDir=""
destDir=""
allVariablesSet=false
rsyncCommand=""

# define variables per inputs provided
# output message if variable is missing or invalid
if [ -z "$1" ]; then
	allVariablesSet=false
	echo ""
	echo "**Missing input variable**"
	echo "Usage: dobackup.sh [option]"
	echo "Options: docs|pics|diskimg"
	echo ""
elif [ "$1" = "docs" ];	then
	sourceDir="share/Documents/"
	destDir="docs/"
	allVariablesSet=true
elif [ "$1" = "diskImg" ];	then
	sourceDir="diskImg/"
	destDir="diskImg/"
	allVariablesSet=true
elif [ "$1" = "pics" ];	then
	sourceDir="share/Pictures/"
	destDir="pics/"
	allVariablesSet=true
else
	allVariablesSet=false
	echo ""
	echo "Invalid option selected"
	echo "Usage: dobackup.sh [option]"
	echo "Options: docs|pics|diskImg"
	echo ""
fi

# Sync only if all variables are actually defined.
if [ -z "$sourceDir" ] || [ -z "$destDir" ]; then
	allVariablesSet=false
	echo ""
	echo "all necessary variables not defined, exiting script"
	echo "Usage: dobackup.sh [option]"
	echo "Options: docs|pics|diskimg"
	echo ""
elif [ "$allVariablesSet" = true ]; then
	rsyncCommand="sudo rsync -avhz --delete -e ssh $sshPath$sourcePath$sourceDir	$destPath$destDir"
	echo ""
	echo "Syncing: $sourcePath$sourceDir"
	echo "Hostname/IP: $sourceMachine"
	echo "As user: $USER"
	echo ""
	echo $rsyncCommand
	echo "running: $rsyncCommand"
	echo "Time: $(date -Iminutes)" >> timestamp.log
	echo ""
fi

# Clear/reset all variables
sourceMachine=""
sshPath=""
sourcePath=""
destPath=""
allVariablesSet=false
destDir=""
rsyncCommand=""
sourceDir=""
```

