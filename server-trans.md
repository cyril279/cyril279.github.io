## Torrent | Transmission

### Transmission@server  
192.168.9.13:9091 :: dubserv:9091 :: [ref_Fedora-spec](https://ask.fedoraproject.org/en/question/67980/how-do-i-use-transmission-from-server-21/) :: [ref_ubuntu-inst](https://help.ubuntu.com/community/TransmissionHowTo) ::  

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


