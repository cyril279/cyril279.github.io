# budgie 10.5 on openSUSE Tumbleweed | 2019/Mar
A slightly modified version of the **Solus-project** [build-instructions], for a working Budgie desktop on openSUSE-TW

### Process Modifications
- A build-dependency list tailored for openSUSE
- Use [Ubuntu-Budgie's "mutter330reduxII" branch] for libmutter-3 compatibility
- Setting the build flag `-Dwith-desktop-icons=none` is necessary to prevent **budgie-desktop-settings** from crashing  
(Solus and Ubuntu are configured to use desktop icons)

### Install build dependencies  
`sudo zypper in accountsservice-devel git glib2-devel gnome-bluetooth-devel gnome-menus-devel gnome-settings-daemon-devel gobject-introspection-devel gsettings-desktop-schemas-devel gtk-doc gtk3-devel ibus-devel intltool json-glib-devel libgnome-desktop-3-devel libupower-glib-devel libuuid-devel libX11-devel libXtst-devel libpeas-devel libwnck-devel meson mutter-devel polkit-devel sassc vala`  

### Clone [Ubuntu-Budgie's "mutter330reduxII" branch]  
`git clone --branch mutter330reduxII --single-branch https://github.com/UbuntuBudgie/budgie-desktop.git`  

`cd budgie-desktop`  

### Configure, build, install
`meson build --prefix=/usr --sysconfdir=/etc --buildtype plain -Dwith-desktop-icons=none`  

`ninja -j$(($(getconf _NPROCESSORS_ONLN)+1)) -C build`

`sudo ninja install -C build`

## Now to address the insistance of the maximize and minimize buttons:  

There's the bandaid:

>_ gsettings set org.gnome.settings-daemon.plugins.xsettings overrides 
"{'Gtk/ShellShowsAppMenu': <0>, 'Gtk/DecorationLayout': <'menu:close'>}"

**But to the core of the issue...**  
I have found definitions for `left` and `traditional` which override all of the button layouts defined in `/usr/share/glib-2/schemas`  

[github shows me](https://github.com/solus-project/budgie-desktop/search?q=traditional&unscoped_q=traditional) three files that involve the string `traditional`  
The `left|traditional` selection (named "right (standard)" and "left")is made in [settings_wm.vala]  
the `left|traditional` override occurs as a 'case argument' in [settings.vala]  
The `left|traditional` option is chosen in [com.solus-project.budgie-wm.ButtonPosition]  


methinks that an additional `case argument` named `gnome` is appropriate, but perhaps must be defined prior to the build?  
I can't find it in the OS  

****** or re-define one of these existing (useless) cases******  

_settings_wm.vala_  
```
        /* Button layout  */
        var model = new Gtk.ListStore(3, typeof(string), typeof(string), typeof(string));
        Gtk.TreeIter iter;
        model.append(out iter);
        model.set(iter, 0, "gnome", 1, _("Minimal (GNOME)"), -1);
        model.append(out iter);
        model.set(iter, 0, "traditional", 1, _("Right (traditional)"), -1);
        model.append(out iter);
        model.set(iter, 0, "left", 1, _("Left"), -1);
        combo_layouts.set_model(model);
        combo_layouts.set_id_column(0);
```

_settings.vala_  
```
public enum ButtonPosition {
    LEFT = 1 << 0,
    TRADITIONAL = 1 << 1,
    GNOME = 1 << 2,
}

[ ... ]

    /**
     * Set the button layout to one of left or traditional
     */
    void set_button_style(ButtonPosition style)
    {
        Variant? xset = null;
        string? wm_set = null;

        switch (style) {
        case ButtonPosition.LEFT:
            xset = this.new_filtered_xsetting("close,minimize,maximize:menu");
            wm_set = "close,minimize,maximize:appmenu";
            break;
        case ButtonPosition.TRADITIONAL:
        default:
            xset = this.new_filtered_xsetting("menu:minimize,maximize,close");
            wm_set = "appmenu:minimize,maximize,close";
            break;
        case ButtonPosition.GNOME:
        default:
            xset = this.new_filtered_xsetting("menu:close");
            wm_set = "appmenu:close";
            break;
        }

        this.xoverrides.set_value("overrides", xset);
        this.wm_settings.set_string("button-layout", wm_set);
        this.gnome_wm_settings.set_string("button-layout", wm_set);
    }

```

_com.solus-project.budgie.wm.gschema.xml_  
'''
  <enum id="com.solus-project.budgie-wm.ButtonPosition">
      <value nick="left" value="1" />
      <value nick="traditional" value="2" />
      <value nick="gnome" value="3" />
  </enum>

 [ ... ]

    <key name="button-layout" type="s">
      <default>'appmenu:close'</default>
      <summary>Arrangement of buttons on the titlebar</summary>
      <description>
        Arrangement of buttons on the titlebar. The value should be a string,
        such as  "menu:minimize,maximize,spacer,close"; the colon separates
        the  left corner of the window from the right corner, and  the button
        names are comma-separated. Duplicate buttons are not allowed. Unknown
        button names are silently ignored so that buttons can be added in
        future metacity versions  without breaking older versions. A special
        spacer tag can be used to insert some space between
        two adjacent buttons.
      </description>
    </key>

    <key enum="com.solus-project.budgie-wm.ButtonPosition" name="button-style">
      <default>'gnome'</default>
      <summary>Button layout style</summary>
      <description>Which layout to use for window buttons</description>
    </key>
  </schema>
'''



[build-instructions]:https://github.com/solus-project/budgie-desktop/wiki/Building-Budgie-Desktop  
[Arch mail-archive/commit]:https://www.mail-archive.com/arch-commits@archlinux.org/msg465529.html  
[Ubuntu-Budgie's "mutter330reduxII" branch]:https://github.com/UbuntuBudgie/budgie-desktop/tree/mutter330reduxII  
[settings.vala]:https://github.com/solus-project/budgie-desktop/blob/fdf8d629adf870b8b66386f4523826dc5d04ddc1/src/daemon/settings.vala#L212
[com.solus-project.budgie-wm.ButtonPosition]:https://github.com/solus-project/budgie-desktop/blob/fdf8d629adf870b8b66386f4523826dc5d04ddc1/src/wm/com.solus-project.budgie.wm.gschema.xml#L4
[settings_wm.vala]:https://github.com/solus-project/budgie-desktop/blob/b6df16668eed6d0bdb940d65ae148857f328cd64/src/panel/settings/settings_wm.vala#L82
