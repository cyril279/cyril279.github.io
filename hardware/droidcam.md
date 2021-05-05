##Because installing droidcam on a secure distro is a bear

during ./install dkms, problem loading unsigned module into service.  
per https://github.com/umlaeute/v4l2loopback/issues/394#issuecomment-813611110  

grab 51-android-udev.rules [from here](https://github.com/M0Rf30/android-udev-rules/blob/master/51-android.rules), and save the file to '/etc/udev/rules.d/'  
https://github.com/M0Rf30/android-udev-rules/blob/master/51-android.rules  
follow the directions on the readme.md  

 1) sudo dnf in dkms rpm-build openssl v4l2loopback-ctl libappindicator-gtk3 v4l-utils android-tools (ffmpeg?)
 2) sudo ./install-client
 3) [grab this script](https://gist.github.com/Underknowledge/78bdf079469f3f5eb4d1dfb9419cc149)
 and run it.
 4) reboot and use the password, like the script output tells you.
 5) run the script again, which signs, builds & loads the module.
 
 now droidcam runs, but what about the video resolution?
 
[forum conversation of my existing struggle with this](https://forums.opensuse.org/showthread.php/545656-v4l2loopback-resolution-How-to-store-configuration-across-reboots)

The complete process, I do not fully grasp.  
There is something about the followup to updating the kernel as well.  
Some module needs to be rebuilt, but then do we have to go through the entire signature thing again?  
