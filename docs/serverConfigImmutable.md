# Server-config on immutable os (microos or core-os or derivatives thereof)
Bringup is getting easier and easier as I accept & learn the container way of things.  
Layer nothing, container everything. This is the way.

## The blueprint
1. Add user as an unprivileged "supervisor/keeper" for podman services
    ```sh
    sudo useradd -u 1011 -d /srv/serverus vernon
    sudo passwd vernon
    ```
2. Mount raid array to `/srv`  
    a. `lsblk` to find md# of raid array  
    b. `blkid md#` to get the UUID of the raid array  
    c. Add line `UUID=<foundUUID> /srv auto defaults 0 0` to fstab to mount raid array to `/srv`  
    d. `sudo mount -a` to test auto mounting of raid array  
2. Setup server apps  
    [configure & start/enable containers](serverConfigQuadlets.md)  
    (Transmission, Jellyfin, TVHeadend, etc)  
2. Setup network shares  
    a. Samba quadlet?  
    b. ~~NFS quadlet?~~  Bazzite says don't bother.  
    Essentially just use what works for all, and that's SMB.

## Configs
- [Quadlets](serverConfigQuadlets.md#configs-working)

# WIP

### Setup SMB share