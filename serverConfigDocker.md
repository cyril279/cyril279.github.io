# Docker / docker-compose

With Compose, a YAML file is used to configure each application’s services.  
Then, a single command creates and starts all the services from the YAML configuration.

### Benefits:
- Configuration of each app is easy to track & modify (docker-compose entry)
- All entries are in one file ( /etc/docker-compose.yml )
- Keeps the app (& dependencies & issues) isolated from other apps and the OS
- Updates independently from the OS

### Drawbacks:
- The benefit of app-isolation inherently adds a layer of complexity to installation/operation.  
This is mostly mitigated by the friendliness of the docker ecosystem.
- Updates independently from the OS

### Commonly used commands
`docker-compose` commands must be executed from the `/etc/docker-compose` directory  

`docker` commands can be executed from anywhere in the filesystem

```sh
#start or restart all containers in detached mode
docker-compose up -d

#start or restart specific container in detached mode
docker-compose up -d <container-name>

#update all docker images
docker-compose pull

#update specific docker image
docker-compose pull <container-name>

#stop "container name"
docker stop <container-name>

#list all running containers
docker ps
```

# BOINC

```yaml
---
services:
  boinc:
    image: lscr.io/linuxserver/boinc:latest
    container_name: boinc
    security_opt:
      - seccomp:unconfined #optional
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - PASSWORD= #optional
    volumes:
      - /etc/boinc/config:/config
    ports:
      - 8080:8080
      - 8181:8181
    devices:
      - /dev/dri:/dev/dri #optional
    restart: unless-stopped
   ```

# Jellyfin

```yaml
---
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    # user: 1000:100
    network_mode: 'host'
    volumes:
      - /etc/jellyfin/config:/config
      - /etc/jellyfin/cache:/cache
      - /var/storage/media/video:/data/video
      - /var/storage/media/music:/data/music
      - /var/storage/media/pictures:/data/pictures
      - /var/storage/media/books:/data/books
    # Optional - alternative address used for autodiscovery
    environment:
      - PUID=1000
      - PGID=100
      - JELLYFIN_PublishedServerUrl=192.168.9.40
      - TZ=America/Denver
    # Optional - may be necessary for docker healthcheck to pass if running in host network mode
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    devices: #optional, see 'hardware acceleration'
      - /dev/dri:/dev/dri
    restart: 'unless-stopped'
```

# Transmission

/etc/docker/docker-compose.yml

```yaml
---
services:
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    environment:
      - PUID=1000
      - PGID=100
      - TZ=America/Denver
      - TRANSMISSION_WEB_HOME= #optional
      - USER= #optional
      - PASS= #optional
      - WHITELIST=127.0.0.1,192.168.9.*
      - PEERPORT=51419 #must manually forward port in router software
      - HOST_WHITELIST=serverus #must have defined by router ip-reservation
    volumes:
      - /etc/transmission/config:/config
      - /var/storage/media:/media
      - /var/storage/watch:/watch
    ports:
      - 9091:9091
      - 51419:51419 #must manually forward port in router software
      - 51419:51419/udp #must manually forward port in router software
    restart: unless-stopped
```

# TVHeadend

/etc/docker/docker-compose.yml

```yaml
---
services:
  tvheadend:
    image: lscr.io/linuxserver/tvheadend:latest
    container_name: tvheadend
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Denver
      - RUN_OPTS= #optional
    volumes:
      - /etc/tvheadend/config:/config
      - /var/storage/media/video/tv:/recordings
    ports:
      - 9981:9981
      - 9982:9982
    devices:
      - /dev/dri:/dev/dri #optional
      - /dev/dvb:/dev/dvb #optional
    restart: unless-stopped
```
