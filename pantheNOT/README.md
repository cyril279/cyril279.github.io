# If I was into UBUNTU, this document would not exist
This is (well, was) about an attempt (several actually), to use Elementary's Pantheon on Fedora and openSUSE (and Manjaro)

For a while, Pantheon was difficult (for me) to get right on a non-ubuntu distro.    
Now (2023) there are distributions that deliver Pantheon on a silver(blue) platter, so the remaining content of this document is irrelevant ((soon to be reduced, archived or deleted)).  

2023/12 edit:  
**Pantheon on Fedora can be enjoyed painlessly via [SodaliteOS](https://github.com/sodaliterocks/sodalite) or [Ultramarine linux](https://ultramarine-linux.org/).**  
I tried it, but still ended up back on GNOME.  
Everything worked swimmingly on both distributions, and I love how pantheon looks, but I simply prefer the GNOME workflow.  

2019/11/25 edit:  
**Apparently I was doing it wrong.**  
[openSUSE's pantheon](200~https://en.opensuse.org/Portal:Pantheon) is well enough developed to work aside (or instead of) a GNOME installation.  
There are three flavors, choose wisely. (hint:Stable)  
```
zypper addrepo https://download.opensuse.org/repositories/X11:Pantheon:Branch/openSUSE_Tumbleweed/X11:Pantheon:Branch.repo
zypper refresh

#for full elementary experience (plus some gnome tweakability):
zypper install -t pantheon gnome_basis
zypper install libreoffice-gtk3 gnome-tweaks gnome-online-accounts

#for fully functional pantheon-session over full-fat gnome installation: 
zypper install -t pattern pantheon_basis
```

>INFO: Please add a local user to the lightdm group to change the wallpaper  
INFO: using the Pantheon desktop settings (switchboard).  
INFO: You can change the font size, gtk theme, icon theme etc  
INFO: using /etc/gtk-3.0/settings.ini file.  

>This project is a fork of Pantheon repository to avoid depending on GNOME with some patches, using the gsettings under org.opensuse.pantheon.wrap.gnome instead of org.gnome, etc.  

```
cyril@localhost:/usr/share/glib-2.0/schemas> grep -iR "close:" ./
./pantheon-settings-daemon-openSUSE-branding.gschema.override:overrides={'Gtk/DialogsUseHeader': <0>, 'Gtk/EnablePrimaryPaste': <0>, 'Gtk/ShellShowsAppMenu': <0>, 'Gtk/DecorationLayout': <'close:menu,maximize'>}
pantheon-settings-daemon-openSUSE-branding.gschema.override
pantheon-desktop-schemas-openSUSE-branding.gschema.override
```

## I love (the idea of) pantheon

- Graphically well designed
- Comprehensive (like Gnome)
- Embraces the minimalist CSD-app <=> approach
- Feels snappier than Gnome (perception matters)

## Reality

Pantheon, a gnome-dependent desktop-environment, works brilliantly with its parent distribution 'Elementary OS'. <- no surprise there  
I don't like ubuntu-based anything, so I would rather eat beets than run Elementary.  
The inherent challenges of this type of upstream dependency (budgie, deepin, pantheon) result in a product that is significantly less distribution-agnostic than independent DE's (xfce, gnome, plasma).  
Hence the lack of an official Pantheon 'spin' on any of my favorite Distributions.

## Gnome apps over a Pantheon session on an unintended distribution

Pros
- Fluid, beautiful and gentle on the resources
- Circumvents the settings-restricted elementary-app-verse
- The non-traditional button layout and session-specific theming can be easily covered by Gschema override(s)

Cons
- Pantheon shell-theme compatibility issues
- lightdm and light-locker clumsily work as a session locker
- non-functional media/specialty keys (with no easy workaround)
- non-functional links and buttons

## The turning-point
The increasing tweak:usage ratio still leaves several non-functional bits, along with the realization that gnome can be made more responsive by reducing it's searchable apps

- The media/specialty-key issue is a gala/gnome-settings-daemon incompatibility that is somewhat petty, but still presents the need for yet another workaround
- It mostly works just fine. It's totally daily drivable. Spousal acceptance factor? not high enough...  

In the end, I would rather handicap gnome, or simply deal with the occasional (perceived) sluggish shell, or dress-the-hell-out-of xfce, than continue pretending that this implementation of Pantheon is a reliable, fully-functional solution.

### My problem with gnome is not gnome.
I find the gnome-shell defaults (as a starting point) preferrable to any other DE, which consistently results in a very low tweak:usage ratio.  
I stray from gnome primarily because my (elder) hardware exhibits difficulty handling gnome's thorough-ness.  

## Notes
[PantheNOT](panthenot.md)  
[i3lock](i3lock.md)  
