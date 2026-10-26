# Quadlets! podman strikes *for real* this time.
Quadlets are a native Podman feature that allow users to manage containers as systemd services without manually writing complex unit files.  
They function by using declarative configuration files (ending in .container, .pod, etc.)  
The podman-system-generator automatically converts these high-level declarative files into standard systemd .service files during boot or when systemctl daemon-reload is executed.  

### [(( jump to configs ))](#configs-working)

### Docker (un-needed)
Because Quadlets integrate directly with the systemd init system, they eliminate the need for Docker’s daemon or wrapper tools like podman-compose.  
This allows management of container lifecycles (auto-start on boot, restart on failure, logging) using native Linux service management commands like systemctl,  
making Docker a completely optional dependency.  

### Benefits:
- This is a systemd linker, which makes the implementation ultimately feel a lot more native and intuitive.
- No need to know/remember docker-compose commands
- No need to have docker installed at all!

### Drawbacks:
- One needs to understand how service files work (which I struggle with)  
- Most guides are aimed at docker, although the conversion from docker-compose file to service.container is not difficult

### The user way (unprivileged is safest)
#### System setup
- 'containers': Unprivileged user dedicated to system tasks  
- `/home/containers`: containers's home directory; dedicated to user/local container files  
  (`service.container` files, `container-config` directories, etc)  

#### filesystem structure
```
/home/containers/ # constant write config data on ssd or nvme
  ├── .config/
  │   └── containers/
  │       └── systemd/ # symbolically link the unit files directory
  │           ├── immich -> ../../../immich/quadlets
  │           ├── jellyfin -> ../../../jellyfin/quadlets
  │           └── transmission -> ../../../transmission/quadlets
  │
  ├── immich/
  │    ├── backups/
  │    ├── postgres/
  │    ├── model-cache/
  │    └── quadlets/
  │        ├── immich.pod
  │        ├── immich-server.container
  │        ├── immich-machine-learning.container
  │        ├── immich-database.container
  │        ├── immich-valkey.container
  │        └── immich.env
  │
  ├── jellyfin/
  │    ├── backups/
  │    ├── cache/
  │    ├── config/
  │    └── quadlets/
  │        └── jellyfin.container
  │
  └── transmission/
       ├── backups/
       ├── config/
       └── quadlets/
           └── transmission.container


/srv/media/ # for storage data on spinning platter disks
  ├── pictures/          existing photo collection
  └── immich/            media uploaded and managed by Immich
```

#### Process
- The `service.container` files MUST contain:  
  ```ini
  [Install]
  # Start by default on boot
  WantedBy=default.target
  ```  
- The `service.container` files get symlinked to:  
  `/home/containers/.config/containers/systemd`  
- User must have privileges granted by a privileged user  
  `loginctl enable-linger containers`  
- Reload the user-defined services to the daemon & start the service  
  `systemctl --user daemon-reload`  
  `systemctl --user start {serviceName}.service`  
- Enable podman auto-updates via systemd timer  
  `systemctl --user enable --now podman-auto-update.timer`  

Some services need a password, and instead of typing the password into one of the quadlet INI's, we will store it as a "podman secret"  
```sh
printf 'password' | podman secret create immich_db_pass -
```
Then add a line in the particular service that needs the password (ex:)   
```ini
Secret=immich_db_pass,type=env,target=POSTGRES_PASSWORD
```

## Configs (Working):
[Jellyfin](https://github.com/cyril279/cyril279.github.io/blob/master/configs/jellyfin.container)  

[Samba](https://github.com/cyril279/cyril279.github.io/blob/master/configs/samba.container)

[Transmission](https://github.com/cyril279/cyril279.github.io/blob/master/configs/transmission.container)  

[immich-pod](https://github.com/cyril279/cyril279.github.io/tree/master/configs/immich)  
```sh
printf 'password' | podman secret create immich_db_pass -
```

## Configs (unconfirmed):

### Samba:Server Containers
Config straight from Bazzite!  (but looks to be missing some bits)  
https://docs.bazzite.gg/Installing_and_Managing_Software/Quadlet/?h=samba#samba-server  
```ini
[Container]
ContainerName=samba
Environment=ACCOUNT_username=password
Environment=UID_username=1011
#Environment=GROUPS_username=users
# Protected share with write access
Environment="SAMBA_VOLUME_CONFIG_dublife=[DubLife]; path=/srv; valid users = username; guest ok = no; read only = no; browseable = yes"
# Open share with readonly access
Environment="SAMBA_VOLUME_CONFIG_media=[Media Share]; path=/srv/media; guest ok = yes; read only = no; browseable = yes"
Image=ghcr.io/servercontainers/samba:smbd-only-latest
AutoUpdate=registry
Network=host
Volume=/path/to/protected:/shares/dublife:z
Volume=/path/to/guest:/shares/media:z

# Remove if you don't want autostart
[Install]
WantedBy=default.target
```
https://hub.docker.com/r/servercontainers/samba #for info only, use below to actually pull image  
docker pull ghcr.io/servercontainers/samba:latest  
```yml
  samba:
    image: docker.io/servercontainers/samba:latest
    container_name: samba
    restart: unless-stopped
    # user: samba
    # network_mode: host
    # hostname: smb-server
    environment:
      ACCOUNT_samba: test
      UID_samba: 1000
      SAMBA_GLOBAL_STANZA: vfs objects = catia fruit streams_xattr
      SAMBA_VOLUME_CONFIG_shared_home: |
        [home];
        path=/shares/home
        valid users = samba
        browsable = yes
        writeable = yes 
```

### Samba:dockurr
dockurr is recently updated & well regarded  
https://hub.docker.com/r/dockurr/samba  
search.brave.com:dockur samba example  
Quadlet:  
`docker pull dockurr/samba:latest`  

```ini
# ~/.config/containers/systemd/samba.container
#https://hub.docker.com/r/dockurr/samba

[Unit]
Description=Samba SMB Server

[Container]
ContainerName=samba
Image=docker.io/dockurr/samba
PublishPort=445:445
Volume=/path/to/local/data:/storage
Environment=USER=samba
Environment=PASS=secret
Environment=NAME=Media
Network=host
# Note: If using default bridge network, ensure port mapping is correct
# and no conflicting services are on port 445.

[Install]
WantedBy=default.target   
```

docker-compose:  
```yml
services:
  samba:
    image: dockurr/samba
    container_name: samba
    environment:
      NAME: "Data"
      USER: "samba"
      PASS: "secret"
      RW: true
      UID: 1000
      GID: 1000
    ports:
      - 445:445
    volumes:
      - ./samba:/storage
    restart: always   
```
