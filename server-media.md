## PVR (backend)

### tvheadend-common:

hostname:9981 :: [ref_01](https://www.linuxserver.io/2017/02/19/how-to-set-up-tvheadend-with-your-dvb-t2-receiver/) :: [ref_02](http://www.wetekforums.com/v/index.php?p=/discussion/27451/tutorial-how-to-install-tvheadend-and-scan-atsc-north-america-channels) :: [ref_03](https://forum.kodi.tv/showthread.php?tid=270385)

-   ensure capture-card firmware files are in /lib/firmware  
-   reboot & ( lspci or dmesg | grep dvb to check for presence/recognition of card)  
----------------
**openSUSE:**  
`zypper in  tvheadend` #transmission transmission-daemon  

**Fedora:**  
`dnf install tvheadend` #transmission-cli transmission-daemon transmission-common

---------
  
#### post-intallation instructions:  
```
Updating /etc/sysconfig/tvheadend ...
  ==> IMPORTANT: Post configuration tasks;
  ==> 1. Start the tvheadend service (to create home directory).
  ==> 2. Run tvheadend_super to set default username and password.
  ==> 3. Restart tvheadend service.
  ==>
  ==>
  ==> All further configuration is maintained through the web interface:
  ==>
  ==> http://localhost:9981/
  ==>
```
**? grant tcp access to tvheadend ports ?**  
`firewall-cmd --permanent --add-port=9981/tcp`  
`firewall-cmd --permanent --add-port=9982/tcp`  
`systemctl enable tvheadend`  
`systemctl restart tvheadend`  

---------
- separate page for installation and configuration of each application? in theory, this could cover multiple distributions, because after application installation, coonfiguration is mostly the same (see above).  
- certainly seems to keep pages cleaner, at the cost of page-count.  
