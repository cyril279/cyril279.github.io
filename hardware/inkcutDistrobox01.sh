#!/bin/bash
set -e #exit if processes fail

# define variables
CONTAINER_NAME=inkcutBox # Name of distrobox & of distrobox definition file
CONTAINER_HOME=$HOME/$CONTAINER_NAME #Path where $HOME of distrobox will be located
PIPX_INKCUT_SRC=$CONTAINER_HOME/.local/share/pipx/venvs/inkcut/lib/python*/site-packages/inkcut
APP_ICON_DIR=$HOME/.local/share/icons

# Verify values of variables with user
echo "Current configuration:"
echo ""
echo "Name of container: $CONTAINER_NAME"
echo "Home directory of container: $CONTAINER_HOME"
echo ""
read -p "Are you ready to proceed with these names as shown above? (yes/no): " input_user
case $input_user in
	[Yy]|[Yy][Ee][Ss])
    	echo ""
        echo "Name of container: $CONTAINER_NAME"
        echo "Home directory of container: $CONTAINER_HOME"
	;;
    [Nn]|[Nn][Oo])
        echo ""
        echo "Which would you like to change?"
    	select response in "Container name" "Container home directory" "Both name & home directory"; do
    		case $response in
    	        "Container name" )
    			read -p "Enter desired container name: " CONTAINER_NAME
    			echo ""
    			echo "new container name: $CONTAINER_NAME"
    	        echo "Home directory of container: $CONTAINER_HOME"
    		    ;;
    	        "Container home directory" )
    			read -p "Enter desired home directory (full absolute path): " CONTAINER_HOME
    			echo ""
        	    echo "Name of container (& directory): $CONTAINER_NAME"
    			echo "new container home path: $CONTAINER_HOME"
    		    ;;
    	        "Both name & home directory" )
    			read -p "Enter desired container name: " CONTAINER_NAME
    			read -p "Enter desired home directory (full absolute path): " CONTAINER_HOME
    			echo ""
    			echo "new container name: $CONTAINER_NAME"
    			echo "new container home path: $CONTAINER_HOME"
    		    ;;
                * )
                echo ""
                echo "Invalid option selected"
                echo "Name of container: $CONTAINER_NAME"
                echo "Home directory of container: $CONTAINER_HOME"
                ;;
    	    esac
            read -p "Are you ready to proceed with these variables as defined above? (yes/no): " input_user
            case $input_user in
        	    [Yy]|[Yy][Ee][Ss])
                break
    	        ;;
                [Nn]|[Nn][Oo])
                # Reset variables before re-starting prompt-loop
                echo ""
                echo "Resetting variables to default values"
                CONTAINER_NAME=inkcutBox
                CONTAINER_HOME=$HOME/$CONTAINER_NAME
                # Let's ask again
                echo ""
                echo "Which would you like to change?"
                echo ""
                echo "1) Container name"
                echo "2) Container home directory"
                echo "3) Both name & home directory"
                # Without a break, this returns to the select prompt
                ;;
            esac
	    done
    ;;
esac

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

# Verify container-assembly & filesystem criteria
echo ""
echo "distrobox-assemble definition file:"
echo "$CONTAINER_HOME/$CONTAINER_NAME.ini" 
echo ""
echo "$MANIFEST_INI"
echo ""

read -p "Are you ready to proceed with the installation? (yes/no): " input_user
case $input_user in
    [Yy]|[Yy][Ee][Ss])
    ;;
    [Nn]|[Nn][Oo])
    echo ""
    echo "Okay, then let's not"
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
echo ""
echo "pipx install inkcut --system-site-packages"
pipx install inkcut --system-site-packages

echo ""
echo "inkcut can be launched using the following command:"
echo ""
echo "distrobox-enter --name $CONTAINER_NAME -- sh -c '\$HOME/.local/bin/inkcut'"
echo "Time: $(date -Iminutes) :: $1" >> timestamp.log
echo ""
echo "Take a moment to verify that the above command launches inkcut"
echo ""
echo "The next step is to copy an icon into the local directory, and create a desktop file so that inkcut can be launched like any other graphical app on the system"
echo ""
read -p "Type 'yes' when ready to proceed, or 'no' if things aren't right: " input_user
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
distrobox-enter --name $CONTAINER_NAME -- cp $PIPX_INKCUT_SRC/res/media/inkcut.svg $APP_ICON_DIR

# Create 'inkcut.desktop' (configured as shown below)
cat >$HOME/.local/share/applications/inkcut.desktop <<EOL
[Desktop Entry]
Name=Inkcut
GenericName=Terminal entering Inkcut
Comment=Terminal entering Inkcut
Categories=Distrobox;System;Utility
Exec=/usr/bin/distrobox-enter $CONTAINER_NAME -- sh -c '\$HOME/.local/bin/inkcut'
Icon=$APP_ICON_DIR/inkcut.svg
Keywords=distrobox;
NoDisplay=false
Terminal=false
Type=Application
EOL

# Clear/reset all variables
unset CONTAINER_NAME
unset CONTAINER_HOME
unset MANIFEST_INI
unset PIPX_INKCUT_SRC
unset APP_ICON_DIR