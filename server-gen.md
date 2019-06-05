# Gnu/Linux Generic bringup

**Display Attached** (Workstation):  
- Install (& configure)  
- upgrade/update installation  
- Establish/verify ssh connectivity  
  - no? firewall? mismatched host keys?
  - `rm -f /etc/ssh/ssh_host_*` #hostkey cleanup  
  - `firewall-cmd --add-port=22/tcp --zone=external --permanent`
  - `firewall-cmd reload`
- Server bringup? proceed to [Headless Management](#headless-management-).  
Else, ...  

#### Headless Management:
- [filesharing](fileshare.md)
  - Users/Groups
  - NFS
  - ACL
  - Samba
- [Tvheadend](server-tvh.md)
- [Transmission](server-trans.md)

#### _info:_
```
192.168.9.1 #nighthawk router
192.168.9.0/24 #cidr notation
255.255.255.0 #subnet mask
```
#### _/etc/hosts:_
```
192.168.9.11 attic11 attic11.dubnet  
192.168.9.13 media13 media13.dubnet dubserv dubserv.dubnet  
192.168.9.12 kodi12 kodi12.dubnet  
192.168.9.14 kodi14 kodi14.dubnet  
192.168.9.212 hp60504a envy212 envy212.dubnet  
```
### Gateway # changed?

Adjust :
1.  [static ip#]
2.  /etc/hosts    
3.  /etc/sysconfig/network-scripts/ifcfg-enp3s0    
4.  /var/lib/tvheadend/config/acesscontrol/<each-entry>    
5.  [/etc/samba/smb.conf](fileshare.md#anchor-name) :: hosts allow = 127.0.0.1 192.168.1.0/24 192.168.0.0/24    
6.  [Transmission whitelist](https://docs.google.com/document/d/132OtnNEct4Tq5RttY6y-o7q-nbPIiA0URXFTSBOZFmc/edit#heading=h.nincxsovj0c4): /var/lib/transmission/.config/transmission-daemon/settings.json      
7.  nfs config: /etc/exports

### Netmask CIDR Notation

-   [explanation](http://blog.michaelhamrah.com/2015/05/networking-basics-understanding-cidr-notation-and-subnets-whats-up-with-16-and-24/)
-   [cheatsheet](https://oav.net/mirrors/cidr.html)

## Backup

Duplicity

[ref_05](https://www.tecmint.com/create-encrypted-linux-file-system-backups-using-duplicity/2/) :: [ref_01](http://www.ifdattic.com/howto-encrypted-backup-with-duplicity/) :: [ref_02](https://www.vultr.com/docs/creating-incremental-and-encrypted-backups-with-duplicity) :: [ref_03](https://help.ubuntu.com/community/DuplicityBackupHowto) :: [ref_backblaze](https://help.backblaze.com/hc/en-us/articles/115001518354-How-to-configure-Backblaze-B2-with-Duplicity-on-Linux) :: [ref_06](https://fedoramagazine.org/taking-smart-backups-duplicity/)  

Backblaze b2
https://secure.backblaze.com/user_signin.htm  

backup across network
```
rsync -ave ssh user@server:/path/to/file /home/user/path/to/file
rsync -avHe ssh cyril@192.168.0.13:/storage/share/Pictures /storage/backup/Pictures --delete
```

### Boot to ~~terminal console~~ GUI!
```
systemctl get-default #what's the current target?
systemctl set-default graphical.target #make it be this
systemctl isolate graphical.target #immediately switch thereto
```

# Client

## Interface

(from other networked PC)

**Web interface:**  
```
192.168.1.13:9090 #Cockpit server management
192.168.1.13:9091 #transmission torrent client
192.168.1.13:9981 #tvheadend pvr backend
```

**Terminal:**  
`ssh <userQ>@192.168.1.13` #ssh to terminal session as "userQ"  
`ssh 192.168.x.y` #ssh as current user

**File browser**  
```
smb://<hostname>/<share_name> #Linux Access samba share
smb://<ip_address>/<share_name> #Linux Access samba share

\\<hostname>\<share_name> #Windows browse to samba share
\\<ip_address>\<share_name> #Windows browse to samba share
```

# Firewall(d)
pre-defined zones: https://firewalld.org/documentation/zone/predefined-zones.html  

**usage:** [[via reddit](https://www.reddit.com/r/openSUSE/comments/8pxbae/firewalld_on_leap_15_why_is_it_so_complicated/e0jvlar/)]
>Unfortunately, firewalld and firewall-cmd were built for an enterprise Linux OS (RHEL) and so they seem designed to be used by a sysadmin rather than a user. Here's a quick primer:
>
>**zones:** These are just presets for settings. You define a zone with settings to allow services or ports and then you can assign one or more interfaces to the zone to apply the settings. This makes it easier to apply the same rules to multiple interfaces, or to define a default set of policies to be applied to any new interface (the "default zone"). firewalld ships with a default set of zones, but these are just suggested presets that can be changed. You can also create new zones with names of your choosing, but new users are encouraged to just make changes to the existing zones until they know what they are doing.
>
>**runtime vs. permanent:** firewalld uses two rule sets, runtime and permanent. Basically, the equivalent of Cisco's running-config vs. startup-config. If you add a rule without the --permanent option, it is only added for the current boot. If you reboot, the rule is lost. This allows you to test rules and if they completely hose you up a reboot of the server will put you back to the previous working state. There are a couple of ways to apply firewall rules:
>
>1. Add the same rule twice, once without --permanent to test, and then with --permanent to make the rule persistent.
>
>2. Add a rule once with --permanent and then firewall-cmd --reload to re-apply all permanent rules and discard any non-permanent rules. Just be sure you got the rule right when you entered it.
>
>3. Create your rules without --permanent and then save your current ruleset with firewall-cmd --runtime-to-permanent. This is sort of the equivalent of Cisco's copy run start.
>
>**Typical use case commands:**  
>
>`firewall-cmd --get-default-zone`  
>Show the current default zone for new interfaces rules where --zone= is not specified.
>
>`firewall-cmd --set-default-zone=<zone>`  
>Change the default zone to one of your choosing.
>
>`firewall-cmd --info-zone=<zone>`  
>Show the settings for a zone.
>
>`firewall-cmd --zone=<zone> --change-interface=<interface> [--permanent]`  
>Move an interface from one zone to another.
>
>Most zones (and especially a zone that is shipped as default, like 'public') are pre-configured to deny inbound traffic by default (outbound traffic is allowed by default). If certain inbound network traffic is to be permitted (for example, if you are running a webserver on your box), a rule has to be added explicitly. Typically, this is done by allowing 'services'. The pre-defined service set for the 'public' zone only allows SSH and DHCPv6 client traffic inbound (the basics).
>
>`firewall-cmd --get-services`  
>Show a list of pre-defined rules for common network services. Applying a service to a zone is often the easiest way to allow access to a server application running on your machine (e.g. apache or vsftpd).
>
>`firewall-cmd --info-service=<service>`  
>See the settings of a pre-defined service.
>
>`firewall-cmd --zone=<zone> --add-service=<service> [--permanent]`  
>Add a service to a zone to allow access. You can add multiple services in the same command. For example, if you wanted to allow HTTP and HTTPS to your server you could issue the command:
>
>`firewall-cmd --zone=public --add-service=http --add-service=https --permanent`
>The opposite of `--add-service` is `--remove-service`.  
>
>`firewall-cmd --zone=<zone> --remove-service=<service> [--permanent]`  
>Removes a service from a zone.
>
>Sometimes you may want to allow something that isn't defined in a pre-existing service. You can create your own services if there is a need for multiple ports and/or protocols, but the easiest method for simple rules is to use `--add-port`:
>
>`firewall-cmd --zone=<zone> --add-port=<port>/<proto> [--permanent]`  
>For example, if you needed to allow TCP port 8080 to your server, you might use:
>
>`firewall-cmd --zone=public --add-port=8080/tcp --permanent`  
>As with services, `--remove-port` is the opposite of `--add-port`.
>
>`firewall-cmd --zone=<zone> --remove-port=<port>/<proto> [--permanent]`  
>The above just scratches the surface of what firewalld can do. It's a very powerful and flexible tool, definitely one worth learning.
