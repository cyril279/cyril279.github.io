Most of this information is directly from [brad-x.com](https://www.brad-x.com/2017/08/07/quick-tip-setting-the-color-space-value-in-wayland/)  
When "putting it all together", Brad opted to copy and alter an existing unit-file.

My primary issue with this approach is that I am not a fan of depending on a non-associative copy of a vendor-configured unit-file.  
Instead, we will create a unit file specifically to configure the gpu output.

Take it away Brad!
# Quick Tip: Setting the Color Space Value in Wayland
Some televisions and monitors are limited to the “broadcast RGB” color range. This is a subset of an 8-bit range of levels from 0-255 – in this case, 16-235. You’ll find this referred to as 16:235 in some cases.

You can find a lot more on this here: http://kodi.wiki/view/Video_levels_and_color_space

If you’re using Xorg this can be adjusted using the xrandr with something along the lines of:  
`xrandr --output HDMI-0 --set output_csc tvrgb` (Radeon)  
  or  
`xrandr --output HDMI-0 --set "Broadcast RGB" "Limited 16:235"` (Intel)

So – if you’ve noticed your colors are washed out and were wondering why, the above is a good starting point for you.  
But wait! There’s more.

## Wayland
Maybe you’re like me, and you switched to Wayland. You had solved the above problem in Xorg, but you can’t find a way to do the same thing with Wayland.

The short answer: Wayland protocol itself doesn’t provide a facility for this, and the developers are leaving that up to the compositor to manage[1], and this hasn’t been implemented yet[2].

The way to do this is with the `proptest` utility, a test suite built with libdrm. 


-----------------------
Brad builds libdrm, but we can get it from libdrm-tools  
`zypper in libdrm-tools`

Back to you, Brad.

-----------------------
### Proptest
If you run the proptest command without arguments you’ll receive a list of connectors and properties.
```
Usage:
  /root/libdrm-2.4.82/tests/proptest/.libs/proptest [options]
  /root/libdrm-2.4.82/tests/proptest/.libs/proptest [options] [obj id] [obj type] [prop id] [value]

options:
  -D DEVICE  use the given device
  -M MODULE  use the given driver

The first form just prints all the existing properties. The second one is
used to set the value of a specified property. The object type can be one of
the following strings:
  connector crtc

Example:
  proptest 7 connector 2 1
will set property 2 of connector 7 to 1
```
Among these properties will be the specific one controlling output colorspace.  
For Intel cards this will be `Broadcast RGB` and for Radeon it will be `output_csc`.  
Nouveau may or may not have a property for this, don’t know.  

Sample output from my laptop below:
```
trying to open device 'i915'...done
Connector 48 (eDP-1)
    1 EDID:
        flags: immutable blob
        blobs:

        value:
            00ffffffffffff004d103e1400000000
            28190104a52313780effb3a85334b825
            0c4d5500000001010101010101010101
            0101010101014dd000a0f0703e803020
            35005ac2100000180000000000000000
            00000000000000000000000000fe0037
            50485054824c51313536443100000000
            0002410328001200000b010a20200019
    2 DPMS:
        flags: enum
        enums: On=0 Standby=1 Suspend=2 Off=3
        value: 0
    5 link-status:
        flags: enum
        enums: Good=0 Bad=1
        value: 0
    52 audio:
        flags: enum
        enums: force-dvi=18446744073709551614 off=18446744073709551615 auto=0 on=1
        value: 0
    53 Broadcast RGB:
        flags: enum
        enums: Automatic=0 Full=1 Limited 16:235=2
        value: 0
    54 scaling mode:
        flags: enum
        enums: None=0 Full=1 Center=2 Full aspect=3
        value: 3
```
In my case, property 53 is the `Broadcast RGB` property. These numbers will vary on your own system.

Based on all of the above, you’d need to run:
`proptest -M i915 -D /dev/dri/card0 48 connector 53 2`

### Caveat(s)

This doesn’t seem to take effect while Wayland is running, it has to be run beforehand.

---------------------
**Thank you Brad!** This has been marvelously helpful.  

I also found that the proptest command seems to conflict with the plymouth boot splash sequence, and would fail if the boot-animation was running during startup.  
So I edited my grub sequence to **NOT** have `splash=silent quiet` in the grub entry.  
This results in some verbose reboots and shutdowns, just in case that offends you.  

### Putting it all together
Create a systemd-unit that executes your proptest command automatically on-boot

The unit file, tvRGB.service, in _/etc/systemd/system/_
```
[Unit]
Description=Force tv-RGB (16:235) output
DefaultDependencies=no
After=sysinit.target

[Service]
Type=oneshot
ExecStart=/usr/bin/proptest -M radeon 48 connector 40 1

[Install]
WantedBy=sysinit.target
```

To explain each line:  
`DefaultDependencies=no` - Removes some un-needed dependencies so that the `ExecStart` line can be run/completed sooner than later  
`After=sysinit.target` - Orders the `ExecStart` line to be run only after `sysinit.target` has completed  

`Type=oneshot` - Defines the expectations of the process so that systemd can treat/report the unit appropriately  
`ExecStart=/usr/bin/proptest -M radeon 48 connector 40 1` - Upon the start of this unit, this command will be executed

`WantedBy=sysinit.target` - Defines the unit that will trigger tvRGB.service to be run.

-----------------
Remember to enable your unit  
`systemctl enable tvRGB.service`

