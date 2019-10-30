## Groups
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

name | gid | cyril | kodi | tvheadend
---:	|:---:|:---:|:---:|---
docs | 1305 | x | x | -
media | 1306 | x | x | x
samba | 1307 | x | - | -
keeper	| 1308 | x | - | -

## Firewalld  
```
network interface; default zone: internal  
tcp: 9981, 9982, 9091 #tvh, tvh, transmission  
service-name: mountd, nfs, samba, samba client, ssh  
```
## Network info
```
192.168.9.1 #nighthawk router  
192.168.9.0/24 #cidr notation  
255.255.255.0 #subnet mask  
```
### _/etc/hosts:_
```
192.168.9.11 attic11 attic11.dubnet  
# 192.168.9.13 media13 media13.dubnet dubserv dubserv.dubnet  
# 192.168.9.12 kodi12 kodi12.dubnet  
192.168.9.14 kodi14 kodi14.dubnet  
192.168.9.15 media15 media15.dubnet dubserv dubserv.dubnet
192.168.9.212 hp60504a envy212 envy212.dubnet  
```
### _/etc/exports_
```
/storage/share	192.168.9.0/24(rw,sync,all_squash,anonuid=1001,anongid=1306,subtree_check)
```
### _/etc/samba/smb.conf:_  
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
**Port interface:**  
```
192.168.1.13:9090 #Cockpit server management
192.168.1.13:9091 #transmission torrent client
192.168.1.13:9981 #tvheadend pvr backend
```

**Terminal:**  
`ssh <userQ>@192.168.1.13` #ssh to terminal session as "userQ"  
`ssh 192.168.x.y` #ssh as current user

**File browser:**  
```
smb://<hostname>/<share_name> #Linux Access samba share
smb://<ip_address>/<share_name> #Linux Access samba share

\\<hostname>\<share_name> #Windows browse to samba share
\\<ip_address>\<share_name> #Windows browse to samba share
```

## Boot
**/etc/grub.d/40_custom:**
```
#!/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
#
menuentry "Clonezilla" {
  set root=(hd0,2)
  set livePath=/cnzlla/live-hdd
  set liveUUID=551f7701-27c0-4ca4-b481-ba0afe0adbe7
  linux $livePath/vmlinuz boot=live union=overlay username=user config components quiet noswap nolocales edd=on nomodeset ocs_live_run=\"ocs-live-general\" ocs_live_extra_param=\"\" keyboard-layouts= ocs_live_batch=\"no\" locales= vga=788 ip=frommedia nosplash live-media-path=$livePath bootfrom=/dev/disk/by-partuuid/$liveUUID toram=filesystem.squashfs
  initrd $livePath/initrd.img
  }
menuentry "GParted live" {
  set root=(hd0,2)
  set livePath=/gpartd/live-hdd
  set liveUUID=551f7701-27c0-4ca4-b481-ba0afe0adbe7
  linux $livePath/vmlinuz boot=live config union=overlay username=user components noswap noeject vga=788 ip= net.ifnames=0 live-media-path=$livePath bootfrom=/dev/disk/by-partuuid/$liveUUID toram=filesystem.squashfs
  initrd $livePath/initrd.img
  }
```

## System-on-raid0 partition layout

partition	| sdX	| sdY	| raid-0
-:	| :-:	| :-:	| :-:
1	|260M [FAT] /boot/efi	| 260M	| -
3	|500M [XFS] /boot	| 500M	| -
4	| 20G ->	| 20G ->	| [Btrfs]  /
5	| remainder ->	| remainder ->	| [XFS]  /home
2	| 2G ->	| 2G ->	| [swap]

## Scripture
***batt-status*** (Use `(upower -e | grep BAT)` for single battery scenario)
```
#!/bin/bash
echo \ 
echo "Internal battery (Bat0):"
upower -i $(upower -e | grep BAT0) | grep --color=never -E "state|to\ full|to\ empty|percentage"
echo \ 
echo "External battery (Bat1):" 
upower -i $(upower -e | grep BAT1) | grep --color=never -E "state|to\ full|to\ empty|percentage"
echo \ 
```

***dobackup.sh***
```
#!/bin/sh

sourceMachine="dubserv"
sshPath="$USER@$sourceMachine:"
srcPathPrefix="/storage/"
destPathPrefix="/storage/backup/"
bold=$(tput bold)
normal=$(tput sgr0)

sourceDir=""
destDir=""
response=""
rsyncCommand=""

# define variables per inputs provided
# output message if variable is missing or invalid
# case example: https://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_05.html

case $1 in
	docs )
	sourceDir="share/Documents/"
	destDir="docs/"
	;;
	diskImg )
	sourceDir="diskImg/"
	destDir="diskImg/"
	;;
	music )
	sourceDir="share/Music/"
	destDir="Music/"
	;;
	pics )
	sourceDir="share/Pictures/"
	destDir="pics/"
	;;
	"" )
	echo ""
	echo "**Missing input variable**"
	echo "Usage: dobackup.sh [option]"
	echo "Options: docs|pics|music|diskimg"
	;;
	* )
	echo ""
	echo "Invalid option selected"
	echo "Usage: dobackup.sh [option]"
	echo "Options: docs|pics|music|diskImg"
	;;
esac

# Check if all script internal variables are actually defined
# If all good, prompt for verification, and respond accordingly
if [ -z "$sourceDir" ] || [ -z "$destDir" ]; then
	echo ""
	echo "Script variable(s) not defined, exiting..."
	echo ""
else
	rsyncCommand="rsync -avhz --delete -e ssh $sshPath$srcPathPrefix$sourceDir	$destPathPrefix$destDir"
	echo ""
	echo "Syncing: ${bold}$srcPathPrefix$sourceDir${normal}"
	echo "Hostname/IP: ${bold}$sourceMachine${normal}"
	echo "As user: ${bold}$USER${normal}"
	echo ""
	echo "Do you wish to run:"
	echo "${bold}$rsyncCommand${normal}"
	echo ""
	select response in "Yes" "No"; do
	    case $response in
	        Yes )
		$rsyncCommand
		echo "Time: $(date -Iminutes) :: $1" >> timestamp.log
		break
		;;
	        No )
		echo "Okay, then let's not"
		break
		;;
	    esac
	done
	echo ""
fi

# Clear/reset all variables
response=""
sourceMachine=""
sshPath=""
srcPathPrefix=""
destPathPrefix=""
destDir=""
rsyncCommand=""
sourceDir=""
```

