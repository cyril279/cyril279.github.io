- [Tvheadend](#pvr-backend--tvheadend)
- [EPG Data](#epg-data-other-than-ota)

# PVR (backend) | Tvheadend

hostname:9981 :: [ref_01](https://www.linuxserver.io/2017/02/19/how-to-set-up-tvheadend-with-your-dvb-t2-receiver/) :: [ref_02](http://www.wetekforums.com/v/index.php?p=/discussion/27451/tutorial-how-to-install-tvheadend-and-scan-atsc-north-america-channels) :: [ref_03](https://forum.kodi.tv/showthread.php?tid=270385)  


----------------

## Installation:

**Hardware (capture card):**  
-   ensure capture-card firmware files are in /lib/firmware  
-   reboot & `lspci` or `dmesg | grep dvb` to check for presence/recognition of card  

**Fedora:**  
`dnf install tvheadend`  

**openSUSE:**  
`zypper in  tvheadend`  

---------
  
## Post-intallation instructions:  

>Updating /etc/sysconfig/tvheadend ...  
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

**Grant tcp access to tvheadend ports**
`firewall-cmd --permanent --add-port=9981/tcp`  
`firewall-cmd --permanent --add-port=9982/tcp`  
`firewall-cmd --reload`
`systemctl enable tvheadend`  
`systemctl restart tvheadend`  

## Manual configuration:

_/etc/sysconfig/tvheadend_:  
```
#Configuration file for the tvheadend service.  
MALLOC_ARENA_MAX=4

OPTIONS="-c /var/lib/tvheadend/config -u tvheadend -g video -6 -C --http_port 9981 --htsp_port 9982"
```
**Run as daemon, and see realtime logging:**  
- Stop the service  
`systemctl stop tvheadend`  
- Run from the command line as configured in _/etc/sysconfig/tvheadend_  
`tvheadend -c /var/lib/tvheadend/config -u tvheadend -g video -6 -C --http_port 9981 --htsp_port 9982`  
- exit the cli comand, then restart the service  
`systemctl restart tvheadend`  

**!! Must stop the service before changing any config files !!**  
- config file for each user:  
*/var/lib/tvheadend/config/accesscontrol/\<each-entry>*
- remove to clear epg database:  
_/var/lib/tvheadend/config/epgdb.v2_  

### Notes:
-   `usermod -aG smbgrp tvheadend` #gives tvheadend access to alt storage path  
-   `usermod -aG video <username>` #add tvheadend, cyril, & kodi to video group  
-   timeshift path: /storage/share/Video/.tv_timeshift  
-   recording path: /storage/share/Video/tv  

# EPG data (other than ota)
tvheadend looks at a ***grab_file*** to determine where to get its epg data.

The grab_file may:
-   point directly to a specific site (sd_json)
-   point to a local epg-data file (ex: xmltv.xml)
-   activate a scan, to populate a local epg-data file

looking at it another way:  
EPG data from the interwebs is compiled into a xmltv.xml file, which is referenced by the grab_file that tvheadend is pointed to.

**installation**

1.  setup & test scraper
2.  add (or symbolically link) tv_grab_file to /usr/bin, and configure as needed
3.  systemctl restart tvheadend #to see new tv_grab_file
4.  enable tv_grab_file in tvheadend [ configuration > channel/epg > EPG Grabber Modules ]
    
**tvheadend**

1. Configuration > channel/epg > channels > epg source :: enter/select grab_file_channel  
2. configure frequency  
3. re-run internal epg grabbers  

## zap2epg

[zap2epg setup/guide](https://github.com/edit4ever/script.module.zap2epg/wiki).

Following the recommended path in the wiki, I did initial setup through kodi (password is in the clear!), tells me access denied.

[found github issue instructing to run http://YOUR.IP.ADDRESS:9981/api/mpegts/service/grid](https://github.com/edit4ever/script.module.zap2epg/issues/1#issuecomment-351146771)

this request was denied until I used a tvheadend account with administrative privilege.

On the kodi device, a successful setup&scan generates settings & configuration files in a userdata folder under:  
*~/.kodi/userdata/../addon_data*  
or  
*~/.var/app/tv.kodi.Kodi/data/userdata/addon_data*

Migrating the setup to be managed by a (headless) tvheadend backend/server involves two steps:

1.  Copying the kodi-configured (& tested) addon for tvheadend server usage
    1. Copy the contents of .kodi/addons/script.module.zap2epg (core addon files) to user@serverip:/var/lib/tvheadend/script.module.zap2epg
    2. Copy the contents of .kodi/userdata/../addon_data/script.module.zap2epg (configuration and settings) to user@serverip:/var/lib/tvheadend/script.module.zap2epg

3.  Setting up the tv_grab_file  
    1. ***settings.xml***:  
Assuming that `<setting id="tvhurl">dubserv</setting>` in *settings.xml*, be sure that `dubserv` is defined in */etc/hosts*, and that the appropriate network range is configured for the kodi user via the tvheadend web interface.  
    2. ***script.module.zap2epg/bin/tv_grab_zap2epg***:  
ADDON_HOME & ADDON_DIR: Modify to the actual location of the addon files  
/var/lib/tvheadend  
    2. `ln -s` (or copy) to */usr/bin/*  
    2. test to verify functionality. Success:=new xmltv.xml generated   
`. tv_grab_zap2epg`  
    2. `Systemctl restart tvheadend` #make tvheadend notice grabber additions/changes
    2. Enable tv_grab_zap2epg in tvheadend [ configuration > channel/epg > EPG Grabber Modules ]
    2. Edit cron frequency [ configuration > channel/epg > EPG Grabber > Internal Grabber ]  

`ssh -A -t kodi@kodibox scp -r /home/kodi/.kodi/addons/script.module.zap2epg cyril@192.168.0.13:/home/tvheadend/`  
`ssh -A -t kodi@kodibox scp -r /home/kodi/.kodi/userdata/profiles/kids/addon_data/script.module.zap2epg/* cyril@192.168.0.13:/home/tvheadend/script.module.zap2epg/`

`userdata/profiles/kids/addon_data/script.module.zap2epg/*`

## schedules direct
Seems nice

First, from web-interface:

configuration > channel/epg > epg grabber modules

on left side, lots of red circles, look for:

internal: XMLTV: Schedules Direct JSON API

  

present? then check the parameters for the grab_file path, grab some terminal:

sudo -u tvheadend /path/to/tv_grab_zz_sdjson --configure

  

follow the prompts, then restart tvheadend

systemctl restart tvheadend

  

go back to the web-interface > modules menu, disable the OTA module, enable the appropriate schedules direct JSON, [save], profit.

## Icons?

try the %C thing :: [ref_01](https://www.linuxserver.io/2017/02/19/how-to-set-up-tvheadend-with-your-dvb-t2-receiver/) :: [ref_02](https://github.com/rocky4546/script.xmltv.tvheadend/wiki/Guide:-How-to-Setup-XMLTV-for-TVHeadEnd#using-icons-with-xmltvxml) :: [ref_03](http://docs.tvheadend.org/webui/config_misc/#picons)

  

works:

Configuration > General > Base

-   Picon
-   Channel icon path: file:///home/tvheadend/.xmltv/icons/%C.png
-   Channel icon name scheme: Service name picons
-   Picon path: BLANK
-   Picon name scheme: Standard
-   Channel (re)name:
-   Channel_name : filename ? auto-fills-in
-   IconTest : icontest.png
-   Channel 1 : channel1.png
-   3.4 name : 34name.png

great source of logo png (& svg) images:  
https://logos.fandom.com/wiki/
