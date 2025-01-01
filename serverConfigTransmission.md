# Torrent | Transmission
1. [Docker container installation](#docker-container-installation) (For use on immutable OS)
2. [Traditional linux installation](#traditional-linux-installation)

## Docker container installation

Setup the directory structure
```sh
mkdir -p /etc/transmission/config
mkdir -p /var/storage/watch
```

### Create Docker entry  
Defines core transmission-server parameters  
and maps host ports & directories to the container  

`/etc/docker/docker-compose.yml`  

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

### Notes:  
- `Systemctl daemon-reload` for each edit of `transmission.service`
- Am able to set webUI torrent location to `/any/path/I/choose`, and it will create the directories as needed on the host OS under `/var/storage` (as defined by the `docker-compose.yml`)
- Ref: https://docs.linuxserver.io/images/docker-transmission/

## Traditional linux installation
192.168.9.13:9091 :: dubserv:9091 :: [ref_Transmission_Docs_headless](https://github.com/transmission/transmission/blob/main/docs/Headless-Usage.md) :: [ref_Fedora-spec](https://ask.fedoraproject.org/en/question/67980/how-do-i-use-transmission-from-server-21/) :: [ref_ubuntu-inst](https://help.ubuntu.com/community/TransmissionHowTo) ::  

-------------

### Installation:
**Fedora:**  
`dnf install transmission-cli transmission-daemon transmission-common`  

**openSUSE:**  
`zypper in transmission transmission-daemon`  

**fire it up:**  
`systemctl start transmission-daemon`  
`systemctl enable transmission-daemon`  

-------------

### Configuration:
**!! stop service before changing any files !!**  
`systemctl stop transmission-daemon`  

_/var/lib/transmission/.config/transmission-daemon/settings.json:_  
```
"download-dir": "/storage/media/transmission/Downloads",
"incomplete-dir": "/storage/media/transmission/Downloads",
"rpc-host-whitelist": "dubserv",
"rpc-host-whitelist-enabled": true,
"rpc-whitelist": "127.0.0.1,192.168.9.*"
```
**firewall**  
`firewall-cmd --permanent --add-port=9091/tcp`  
`firewall-cmd --reload`  
`systemctl restart transmission-daemon`  

### Transmission@client  
server-ip:9091  
server-hostname:9091  

or use the remote client application:  
_transmission-remote-gtk_  
