# If I was into UBUNTU, this document would not exist
This is about an attempt (several actually), to use Elementary's Pantheon on Fedora and openSUSE (and Manjaro)

2019/11/25 edit:  
Apparently I was doing it wrong.  
[openSUSE's pantheon](https://en.opensuse.org/Portal:Pantheon) is well enough developed to work aside (or instead of) a GNOME installation.  
See [openSUSE@tumbleweed](../pantheon-oS.md)

## I love (the idea of) pantheon

- Graphically well designed
- Comprehensive (like Gnome)
- Embraces the minimalist CSD-app <=> approach
- Feels snappier than Gnome (perception matters)

## Reality

Pantheon, a gnome-dependent desktop-environment, works brilliantly with its parent distribution 'Elementary OS'. <- no surprise there  
I don't like ubuntu-based anything, so I would rather eat beets than run Elementary.  
GNOME-based Pantheon is not as distribution-agnostic as other DE's (xfce, gnome, plasma).  

## A Pantheon session over a GNOME base, on an unintended distribution

Pros
- Fluid, beautiful and gentle on the resources
- Circumvents the settings-restricted elementary-app-verse
- The non-traditional button layout and session-specific theming can be easily covered by Gschema override(s)

Cons
- Pantheon shell-theme compatibility issues/limitations
- lightdm and light-locker clumsily work as a session locker

Outsanding issues
- the session is often left in this pseudo-locked state, that the user has to `loginctl-unlock` to get out of.

It mostly works just fine, and is definitely daily-drivable. Spousal acceptance factor? increasing...  

### I like GNOME
I find the gnome-shell defaults (as a starting point) preferrable to any other DE, which consistently results in a very low tweak:usage ratio.  
I stray from gnome primarily because my (elder) hardware exhibits difficulty handling gnome's thorough-ness.  

## Notes
[budgie-10.5@openSUSE](budgieSUSE.md)  
