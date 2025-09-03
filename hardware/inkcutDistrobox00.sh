#!/bin/bash
set -e #exit if processes fail
# define variables
CONTAINER_NAME=inkcutBox # Name of distrobox & of distrobox definition file
CONTAINER_HOME=$HOME/$CONTAINER_NAME #Path where $HOME of distrobox will be located
PIPX_HOME=$CONTAINER_HOME/.local/share
PIPX_INKCUT=venvs/inkcut/lib/python*/site-packages/inkcut
#
MANIFEST_INI=$(cat << EOF
[$CONTAINER_NAME]
image=docker.io/library/alpine:3.22
home=$CONTAINER_HOME
pull=true
additional_packages="gcc cups-dev musl-dev linux-headers"
additional_packages="python3-dev pipx py3-qt5"
exported_bins="/usr/bin/pipx"
exported_bins_path="\$HOME/.local/bin"
EOF
)
# Display configuration for user verification
echo ""
echo "       description | variable name  | value"
echo "-------------------+----------------+----------------"
echo " name of container | CONTAINER_NAME | $CONTAINER_NAME"
echo "container HOME dir | CONTAINER_HOME | $CONTAINER_HOME"
echo "container manifest |  MANIFEST_INI  | (see below)"
echo ""
echo "$MANIFEST_INI"
echo ""
echo "manifest file will be written to the following path:"
echo "$CONTAINER_HOME/$CONTAINER_NAME.ini"
echo ""
echo "To adjust these values, edit the variable definitions"
echo "'CONTAINER_NAME' &/or 'CONTAINER_HOME'"
echo "at the beginning of the script"
echo ""
# Pause for user input to proceed or exit
read -p "Are you ready to proceed with the installation? (yes/no): " input_user
case $input_user in
    [Yy]|[Yy][Ee][Ss])
    ;;
    [Nn]|[Nn][Oo])
    echo ""
    echo "Okay, exiting script."
    echo ""
    exit
    ;;
esac
# create directory to isolate our distrobox $HOME files
mkdir -p $CONTAINER_HOME
# create distrobox.ini file
echo "$MANIFEST_INI" > $CONTAINER_HOME/$CONTAINER_NAME.ini
# Assemble the container per the variables & declarative ini file
distrobox-assemble create --file $CONTAINER_HOME/$CONTAINER_NAME.ini
# Install inkcut into the distrobox container using pipx
pipx install inkcut --system-site-packages
echo ""
echo "Take a moment to verify that the following command launches inkcut"
echo ""
echo "distrobox-enter --name $CONTAINER_NAME -- sh -c '\$HOME/.local/bin/inkcut'"
echo ""
echo "The next step is to copy an icon into the local directory, and create a desktop file so that inkcut can be launched like any other graphical app on the system"
echo ""
read -p "Type 'yes' when ready to proceed, or 'no' to exit the script: " input_user
case $input_user in
    [Yy]|[Yy][Ee][Ss])
    ;;
    [Nn]|[Nn][Oo])
    echo ""
    echo "exiting script now..."
    echo ""
    exit
    ;;
esac
# copy source icon for system use
distrobox-enter --name $CONTAINER_NAME -- cp $PIPX_HOME/$PIPX_INKCUT/res/media/inkcut.svg /home/$USER/.local/share/icons
# Create 'inkcut.desktop' (configured as shown below)
cat >$HOME/.local/share/applications/inkcut.desktop <<EOL
[Desktop Entry]
Name=Inkcut
GenericName=Terminal entering Inkcut
Comment=Terminal entering Inkcut
Categories=Distrobox;System;Utility
Exec=/usr/bin/distrobox-enter $CONTAINER_NAME -- sh -c '\$HOME/.local/bin/inkcut'
Icon=$HOME/.local/share/icons/inkcut.svg
Keywords=distrobox;
NoDisplay=false
Terminal=false
Type=Application
EOL
# Clear/reset all variables
unset CONTAINER_HOME
unset CONTAINER_NAME
unset PIPX_HOME
unset PIPX_INKCUT
unset MANIFEST_INI
