# MicroOS
A rolling-release & immutable OS with a minimal presentation and tumbleweed's package base.  
Out of the box, MicroOS is designed as a foundation for single-purpose server/appliance usage.  
Some tweaks are needed to better suit more standard desktop-PC usage.

- [As a desktop PC](#as-a-desktop-pc)
- [As a server](#as-a-server)

## As a desktop PC
Aeon was the original goal (also rolling-release AND immutable OS), but my older hardware forces Aeon to use "fallback FDE mode" which requires a passphrase on each boot, which is NOT okay for a family-friendly-living-room PC.  
A slightly customized MicroOS is the easy next-best choice.

### Overview
- [Add user-module & parental-controls](#user-controls) to gnome-settings  
- [Change polkit policy](#polkit-policy) from `restrictive` to `standard`

### During OS installation
- Choose GNOME as desktop software (duh)
- Set policy as `standard` (from `restrictive`)
- Choose `systemd-boot` as boot manager  
    (personal preference, not req'd)

### User-controls
Are not integrated into Gnome-settings of MicroOS.  
Specifically, I wanted to be able to apply auto-login to a specific user, and apply parental controls.  

### GUI gnome-controls
```sh
# install gnome-settings 'users' menu & install parental controls gui options
sudo transactional-update pkg install \
gnome-control-center-users \
malcontent{,-control}
```

### CLI auto-login
( If gui packages are not installed )
```sh
# create user
sudo useradd -d /home/username username
```
```sh
# set password for 'username'
passwd username
```
Once user is created, apply username to autologin:  
```sh
/etc/sysconfig/displaymanager
--------------------
DISPLAYMANAGER_AUTOLOGIN="username"
```

## As a server
(2024/12 update)  

During OS installation, ensure:  
systemd-boot  

layered packages  
```sh
transactional-update pkg in -t pattern file_server
```
```sh
transactional-update pkg in samba docker{,-compose}
```
```sh
usermod -aG docker cyril #or whomever will need to test and run docker containers
```

## Container life:  
Apps on a headless & immutable OS are best installed as containers  
Docker (& docker-compose) is the way: [serverConfigDocker.md](serverConfigDocker.md)

Install as desired, configure as needed  
(links to Docker service entries):  
[BOINC](serverConfigDocker#boinc)  
[Jellyfin](serverConfigDocker#jellyfin)  
[Transmission](serverConfigDocker#transmission)  
[tvheadend](serverConfigDocker#tvheadend)  

## Polkit policy
The defualt profile for polkit privilege is set as `restrictive` (the most secure option), which requires authentication for reboot & power-off (among other small-worry items).  
This profile is not ideal for casual or community desktop usage.  

### Solution:  
Change the active polkit profile to `standard`

```sh
/etc/sysconfig/security
--------------------
POLKIT_DEFAULT_PRIVS="standard"
```
Then run:  
```sh
sudo set_polkit_default_privs
```

### Info:  

> There exist three profile types for setting polkit default privileges. The selection of the profile is performed via the setting POLKIT_DEFAULT_PRIVS in /etc/sysconfig/security. The following profile types exist:  
>
> •restrictive: conservative settings that require the root user password for a lot of actions and disable certain actions completely for remote users. This should only be used on systems where security requirements are high and for experienced users. Usability can suffer a bit, especially on desktop systems, so custom tuning of polkit rules might become necessary.  
>
> •standard: balanced settings that restrict sensitive actions to require root authentication but allow less dangerous operations for regular logged in users. This should be used on server systems or multi-user systems.
>
> •easy: settings that are focused on ease of use. This sacrifices security to some degree to allow a more seamless user experience without interruptions in the workflow due to password prompts. This should only be used for single-user desktop systems.
>
> •local: this is a custom profile that can be used on top of the predefined profiles. Configuration items from this profile always take precedence and thus override the predefined profiles. Therefore this profile can be customized to loosen or tighten certain polkit actions.

### Ref  
https://manpages.opensuse.org/Tumbleweed/polkit-default-privs.5.en.html#PROFILE_TYPES  
