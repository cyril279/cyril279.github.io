# Quadlets! podman strikes *for real* this time.
Quadlets are a native Podman feature that allow users to manage containers as systemd services without manually writing complex unit files.  
They function by using declarative configuration files (ending in .container, .pod, etc.)  
The podman-system-generator automatically converts these high-level declarative files into standard systemd .service files during boot or when systemctl daemon-reload is executed.  

### Docker (nope)
Because Quadlets integrate directly with the systemd init system, they eliminate the need for Docker’s daemon or wrapper tools like podman-compose.  
This allows management of container lifecycles (auto-start on boot, restart on failure, logging) using native Linux service management commands like systemctl,  
making Docker a completely optional dependency.  

### Benefits:
- This is a systemd linker, which makes the implementation ultimately feel a lot more native and intuitive.
- No need to know/remember docker-compose commands
- No need to have docker installed at all!

### Drawbacks:
- One needs to understand how service files work (which I struggle with)  
- The guides (and all of the momentum) are all aimed at docker, so 

search.brave.com: "how to use quadlet to create systemd service"
overall process:
1.	Create the quadlet file
2.	Place the file in: /etc/containers/systemd/
3.	Reload & start the service  
    - systemctl daemon-reload  
    - systemctl start whatever.service  
    - systemctl enable whatever.service  
     ^^ Attempts to `enable` the service are currently resulting in the following error:  
     ```Failed to enable unit: Unit /blah/blah/blah.service is transient or generated```

### The user way (unprivileged is safest)
Assuming that:  
1. "vernon" is our unprivileged user dedicated to system tasks  
2. `service.container` files are stored at `/srv/serverus/containers`  

- The `service.container` files MUST contain:  
  ```ini
  [Install]
  # Start by default on boot
  WantedBy=default.target
  ```  
- The `service.container` files get symlinked to:  
  `/srv/serverus/.config/containers/systemd` (instead of /etc/containers/...)  
- User must have privileges granted by a privileged user  
  `loginctl enable-linger vernon`  
- Reload & start the service  
  `systemctl --user daemon-reload`  
  `systemctl --user start {serviceName}.service`  
- Enable podman auto-updates via systemd timer  
  `systemctl --user enable --now podman-auto-update.timer`  

## Configs (Working):
### Jellyfin
```sh
vi /srv/containers/jellyfin.container  
```
contents:  

```ini
[Unit]
Description=Podman - Jellyfin
Wants=network-online.target
After=network-online.target

[Container]
Image=docker.io/jellyfin/jellyfin:latest
AutoUpdate=registry
ContainerName=jellyfin
Environment=PUID=1011 
Environment=PGID=100
Environment=TZ=America/Denver
Volume=/srv/cfg/containers/jellyfin-config:/config:Z
Volume=/srv/cfg/containers/jellyfin-cache:/cache:Z
Volume=/srv/media/video:/data/video:z
Volume=/srv/media/music:/data/music:z
Volume=/srv/media/pictures:/data/pictures:z
Volume=/srv/media/books:/data/books:z
PublishPort=8096:8096/tcp
PublishPort=7359:7359/udp
PublishPort=1900:1900/udp
StopTimeout=60

[Service]
Restart=always
TimeoutStartSec=900
TimeoutStopSec=70
# Inform systemd of additional exit status
SuccessExitStatus=0 143

[Install]
# Start by default on boot
WantedBy=default.target   
```

### Transmission
```sh
vi /srv/serverus/containers/transmission.container  
```
contents:  
```ini
[Unit]
Description=Transmission BitTorrent Client
After=network-online.target
Wants=network-online.target

[Container]
Image=lscr.io/linuxserver/transmission:latest
AutoUpdate=registry
ContainerName=transmission
PublishPort=9091:9091
PublishPort=51419:51419
PublishPort=51419:51419/udp
Volume=/srv/serverus/containers/transmission-config:/config:Z
Volume=/srv/media:/media:z
Volume=/srv/watch:/watch:z
Environment=PUID=1011
Environment=PGID=1011
Environment=TZ=America/Denver
Environment=WHITELIST=127.0.0.1,192.168.9.*
Environment=PEERPORT=51419
Environment=HOST_WHITELIST=serverus

[Service]
Restart=always
TimeoutStartSec=900
TimeoutStopSec=70

[Install]
# Start by default on boot
WantedBy=default.target 
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
