# MDADM@dubnet (2017)

### [A guide to madam](https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm)

[Re-name](#rename-an-array)  
[Shrink](#shrink-intact-array--shrink-degraded-array-)  
[Disk removal & cleanup](#removal-of-disk-from-mdadm-array--disk-wipe)  

## Raid 1 (mirror)

[https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-16-04)  
[how-to](https://www.tecmint.com/create-raid1-in-linux/) , except [use parted (not fdisk) to gpt-format disk](https://askubuntu.com/a/463813)(s) or gdisk.  
[cheat-sheet](http://www.ducea.com/2009/03/08/mdadm-cheat-sheet/)  
[email-alert](https://serverfault.com/questions/539293/how-to-get-email-alert-if-one-of-raid-1-disks-fails)  

## Re-use (large volume) existing disk:
**[create (degraded) raid1, to transfer existing data](https://unix.stackexchange.com/a/63935)** :: [ref_01](https://zackreed.me/adding-an-extra-disk-to-an-mdadm-array/)  

1.  create an empty (broken) mirror with the new disk
2.  copy the existing data onto it
3.  VERIFY USEABLE DATA
4.  create mountpoint
5.  edit fstab to use new array
6.  VERIFY USEABLE DATA
7.  format old drive
8.  add old drive to array

**Tools**
`du -sh file_path`  
du command estimates file_path space usage  
The options -sh are (from man du):  
```
-s, --summarize  
display only a total for each argument

-h, --human-readable  
print sizes in human readable format (e.g., 1K 234M 2G)
```
### Prepare disk:

1.  Install disk &...
    1.  Identify the device names of your new hard drives  
`sudo fdisk -l` or `lsblk`
    2.  Determine whether there is any existing raid configuration  
`mdadm -E /dev/sd[x,y]`  
2.  Create partition.
    1.  The partition table needs to be GPT because desired volume > 2TB; use parted, not fdisk.  
`parted /dev/sd(x)`  
    2.  At the (parted) prompt, create the partition table:  
`mklabel gpt`  
    3.  Check the free space on the drive by typing  
`print free`
    4.  Create the partition  
`mkpart primary 1M 3001GB`
This starts the partition at 1M offset giving a 4096 byte alignment. This may or may not be necessary, but won't hurt if its not.  
    3.  `p` #displays partition setup    
    6.  `q` #quit

### Create Raid array:
3.  initialize array /dev/md(#) using /dev/sd(x#) and a missing disk  
`sudo mdadm --create --verbose /dev/md0 --level=raid1 --raid-devices=2 /dev/sd(x#) missing`
4.  Create a file system on the array:  
`sudo mkfs.ext4 /dev/md0`
5.  Create a mountpoint for the array, & mount volumes  
`sudo mkdir -p /storage/share`
`mount /dev/md0 /mnt/zero`  
6.  & copy old stuff to new /dev/md0 :: [rsync_01](https://serverfault.com/a/505758) :: [rsync_if_again](https://serverfault.com/a/43019)
`rsync -avhW --progress --no-compress /src/ /dst/`

### USE the (degraded) array
7.  Mount it  
`sudo mount /mnt/md0`
2.  Next, save the raid configuration manually to ‘mdadm.conf‘ file using the below command.  
`mdadm --detail --scan --verbose >> /etc/mdadm.conf`  
2.  All good? Add entry to /etc/fstab: [dev/ID]  
`/dev/md0 /storage/share auto defaults 0 0`
2.  All good? Add entry to /etc/fstab: [UUID]  
    1.  find device  
`cat /proc/mdstat`
    2.  find uuid of device  
`sudo blkid /dev/md0`
    3.  add entry to fstab  
`UUID=4a2b3c6d-0ada-4228-8043-7a2f40a13d4a /storage/share auto defaults 0 0`

### data verified?
perform 1a through 2f on the old (3tb wd black)

22.  let’s add the other drive...  
`mdadm /dev/md0 --add /dev/sd(y#)`
12.  Save the raid configuration manually to _/etc/mdadm.conf_    
`mdadm --detail --scan --verbose >> /etc/mdadm.conf`
13.  Now you can start using your array. Bear in mind, however, that before it is fully operational it will need to complete its initial sync.  
14.  Track/Watch sync progress:  
`watch -n1 sudo mdadm --detail /dev/md0`  
`cat /proc/mdstat`

## removal of disk from mdadm array (& disk wipe):

- fail disk  
`sudo mdadm /dev/md0 --fail --remove /dev/sdb1`
- stop array  
`sudo mdadm --stop md0`
- wipe the filesystem  
`wipefs -a /dev/sd(x#)`

## [shrink intact array](https://www.howtoforge.com/how-to-resize-raid-partitions-shrink-and-grow-software-raid#-intact-array) :: [shrink degraded array](https://www.howtoforge.com/how-to-resize-raid-partitions-shrink-and-grow-software-raid-p2#-degraded-array) ::

[shrink intact array:](https://superuser.com/q/469117)

1.  Shrink (Resize) filesystem to just larger than the space used by the content resize2fs /dev/md# [size]
2.  since intact, spends time rebuilding `watch -n1 cat /proc/mdstat`
3.  Reshape RAID volume to just larger than than the (shrunken) filesystem  
`mdadm --grow /dev/md# --size [size+]`
5.  Modify partition(s) as needed
6.  Grow the RAID volume to fill the re-worked/new partition  
`mdadm --grow /dev/md# -z max`
7.  Resize filesystem to occupy entire RAID volume restore filesystem to full raid vol?  
`resize2fs /dev/md#`  

shrink filesystem: resize2fs to-size  
shrink (reshape) raid vol: mdadm --grow  
shrink partition by delete/recreation: gdisk  

## (Re)name an array
Helps to communicate array purpose/function/intent.
Links the array to `/dev/md/newname`, and applies `newname` to its listing in yast and elsewhere.

1. unmount, then stop the array  
  `umount /dev/md#`  
  `mdadm --stop /dev/md#` or `mdadm --stop --scan`

2. Define & use "newname"  
  `mdadm --assemble /dev/md/newname --name=newname --update=name /dev/sd[xy]#`  
  edit _/etc/mdadm.conf_; change `oldname` to `newname`

2. Make persistent across reboots  
  `dracut -f`

## System on RAID-0
This is somewhat faster, but forfeits grub-rollbacks (thumbs-down).

>System (root) on a raid-0 volume seems to have exposed a limitation of the
Dell optiplex 3010 UEFI firmware.  
Corresponding efi and boot partitions are expected to be on the same physical disk.

If the root is on soft-raid0, then /boot may need to be on a separate partition, because of firmware limitations similar to that experienced above.  
EFI and /boot cannot share a partition because EFI needs to have a 'FAT' filesystem, and '/boot' needs a posix compliant filesystem (which 'FAT' is NOT).  

Config used:

partition	| sdX	| sdY	| raid-0
-:	| :-:	| :-:	| :-:
1	|260M [FAT] /boot/efi	| 260M	| -
3	|500M [XFS] /boot	| 500M	| -
4	| 20G ->	| 20G ->	| [Btrfs]  /
5	| remainder ->	| remainder ->	| [XFS]  /home
2	| 2G ->	| 2G ->	| [swap]

[Add & grow an array](https://superuser.com/questions/1061516/extending-raid-1-array-with-different-size-disks)  

