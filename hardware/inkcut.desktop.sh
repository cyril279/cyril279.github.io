#!/bin/bash
cat >/home/$USER/.local/share/applications/inkcut.desktop <<EOL
[Desktop Entry]
Name=Inkcut
GenericName=Terminal entering Inkcut
Comment=Terminal entering Inkcut
Categories=Distrobox;System;Utility
Exec=/usr/bin/distrobox-enter --name inkcutBox -- .local/bin/inkcut
Icon=/home/$USER/.local/share/icons/inkcut.svg
Keywords=distrobox;
NoDisplay=false
Terminal=false
Type=Application
EOL

cp \
/home/$USER/distrobox/inkcutBox/.local/share/pipx/venvs/inkcut/lib/python3.12/site-packages/inkcut/res/media/inkcut.svg \
/home/$USER/.local/share/icons/

echo ""
cat /home/$USER/.local/share/applications/inkcut.desktop
echo ""
echo "Two actions were performed:"
echo ""
echo "1. 'inkcut.desktop' (configured as shown above) was created at the following path:"
echo "/home/$USER/.local/share/applications/inkcut.desktop"
echo ""
echo "2. 'inkcut.svg' was copied from the inkcut container to"
echo "/home/$USER/.local/share/icons/"
echo ""
echo "The inkcut icon should now be available from your desktop launcher"
echo ""

