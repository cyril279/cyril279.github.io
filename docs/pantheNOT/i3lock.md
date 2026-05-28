# i3lock

https://wiki.archlinux.org/index.php/Power_management#Sleep_hooks  
https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Specifiers  

Sleep can be handled by local script or program. Suspend hook is the bigger issue.  
Want suspend to call the locker.
```
[Unit]
Description=User suspend actions
Before=suspend.target

[Service]
User=%I
Type=forking
Environment=DISPLAY=:0
ExecStart=/usr/local/bin/i3lock -c 313131
#ExecStartPost=/usr/bin/sleep 1

[Install]
WantedBy=suspend.target
```

### Locking: Remaining issue as of 2019/06/27:
automatic suspend does not trigger the screen to lock.  
xscreensaver is used to sleep/lock the screen & suspend the machine by-timeout, and works as expected.  
Automatic suspend (lid-close,power-button) does not trigger any locking device, so the desktop is not secured when the lid is openned.  
Resolution? :  
https://unix.stackexchange.com/a/174837

i3lock? https://github.com/i3/i3lock : https://i3wm.org/i3lock/ : https://www.reddit.com/r/unixporn/comments/7iddwn/i3lock_faster_and_better_lockscreen/  
configure: https://www.reddit.com/r/i3wm/comments/26c4mf/how_do_i_configure_i3lock/  
use with xautolock https://unix.stackexchange.com/questions/149959/how-to-run-systemd-user-service-to-trigger-on-sleep-aka-suspend-hibernate : https://www.reddit.com/r/i3wm/comments/ak8fjy/how_do_you_guys_suspend_xautolocki3lock_when/ :  

try:
https://github.com/ruudud/i3wm-scripts#lock-on-suspend-when-closing-laptop-lid  
>Lock on suspend (when closing laptop lid)
The following requires that you're using systemd-logind. Add the file /etc/systemd/system/i3lock.service with the following contents, replacing USERNAME with your user:
```
[Unit]
Description=i3lock on suspend
Before=sleep.target

[Service]
Group=users
Type=forking
Environment=DISPLAY=:0
ExecStart=/usr/bin/i3lock -c 313131

[Install]
WantedBy=sleep.target
```

try:
```
zypper in i3lock xautolock
i3lock -c 000000 (-i /path/to/pic.png)
xautolock -time 10 -notify 60 -locker 'i3lock -c 000000'
```

try: xidlehook? (instead of xautolock):
https://gitlab.com/jD91mZM2/xidlehook
`zypper in cargo libXss-devel`
here's a lock using i3lock, with screen dim support:
```
#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 60 seconds, undim if user becomes active` \
  --timer normal 60 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness .1' \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
  `# Undim & lock after 10 more seconds` \
  --timer primary 10 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; i3lock' \
    '' \
  `# Finally, suspend an hour after it locks` \
  --timer normal 3600 \
    'systemctl suspend' \
    ''
```
```
#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 180 seconds, undim if user becomes active` \
  --timer normal 10 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness .5' \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
  `# Dim (more) the screen after 5 more seconds, undim if user becomes active` \
  --timer normal 2 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness .2' \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
  `# Undim & lock after 5 more seconds` \
  --timer primary 2 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; xset dpms force off && i3lock -c 313131' \
    ''
```
