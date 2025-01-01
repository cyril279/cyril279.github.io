# microOS server
(2024/12 update)  

During OS installation, ensure:  
systemd-boot  

layered packages  
```sh
transactional-update pkg in -t pattern file_server
transactional-update pkg in samba docker{,-compose}
usermod -aG docker cyril #or whomever will need to test and run docker containers
```

## Container life:  
```sh
docker create --name transmission lscr.io/linuxserver/transmission:latest
docker create --name jelyfin jellyfin/jellyfin:latest
```

`/etc/docker/docker-compose.yml` #config file for starting/running containers
```
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
      - PEERPORT= #optional
      - HOST_WHITELIST=serverus
    volumes:
      - /etc/transmission/config:/config
      - /var/storage/media:/media
      - /var/storage/watch:/watch
    ports:
      - 9091:9091
      - 51413:51419 #must manually forward port in router software
      - 51413:51419/udp #must manually forward port in router software
    restart: unless-stopped
```
