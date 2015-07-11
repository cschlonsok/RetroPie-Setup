#!/usr/bin/env bash

# This file is part of RetroPie.
# 
# (c) Copyright 2012-2015  Florian Müller (contact@petrockblock.com)
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="moonlight"
rp_module_desc="MoonLight (LimeLight) Game Streaming"
rp_module_menus="4+"

function depends_moonlight() {
    echo "deb http://archive.itimmer.nl/raspbian/moonlight wheezy main" > /etc/apt/sources.list.d/itimmer_moonlight.list
}



function install_moonlight() {
    #force the installation
    aptInstall moonlight-embedded --force-yes
}

function configure_moonlight() {
    # Create romdir moonlight
    mkRomDir "moonlight"

    # Download moonlight simple theme
    wget https://github.com/cschlonsok/retropie-moonlight-installer/archive/1.0.zip

    unzip 1.0.zip
    cd retropie-moonlight-installer-1.0


    #install moonlight Theme
    ./install.sh


    cd ..
    rm 1.0.zip


    # Run moonlight configuration
#    pushd "$md_inst"
#    clear
#    echo "Discovering GeForce PCs, when found you can press ctrl+c to stop the search, or it will take a long time"
#    # discover IP-addresses of Geforce pc:s
#    moonlight discover
#    echo
#    # ask user for IP-number input for pairing
#    local ip
#    read -p $'Input ip-address given above (if no IP is shown, press CTRL+C and check host connection) :\n> ' ip
#    # pair pi with geforce experience
#    moonlight pair $ip
#    read -n1 -s -p "Press any key to continue after you have given the passcode to the Host PC..."
#    read -n1 -s -p "Please ensure that your gamepad is connected to the PI for device selection (number only!), press any key to continue..."
#    clear
#    # print eventID-numbers and device names with lsinput
#    lsinput | grep -e "/dev/input/event" -e "name"
#    # ask user for eventID number for keymapping
#    local usbid
#    echo
#    echo "Input device event ID-number that corresponds with your gamepad from above for keymapping"
#    read -p $'(if the gamepad is missing, press CTRL+C and reboot the PI with the game pad attached) :\n> ' usbid
#    # run moonlight keymapping
#    moonlight map -input /dev/input/event$usbid mapfile.map
#    popd




    # Remove existing scripts if they exist & Create scripts for running moonlight from emulation station
    cat > "$romdir/moonlight/moonlight720p60fps.sh" << _EOF_
#!/bin/bash
pushd "$md_inst"
moonlight stream -720 -60fps "IP" -app Steam -mapping mapfile.map
popd
_EOF_

    cat > "$romdir/moonlight/moonlight1080p30fps.sh" << _EOF_
#!/bin/bash
pushd "$md_inst"
moonlight stream -1080 -30fps "IP" -app Steam -mapping mapfile.map
popd
_EOF_

    cat > "$romdir/moonlight/moonlight1080p60fps.sh" << _EOF_
#!/bin/bash
pushd "$md_inst"
moonlight stream -1080 -60fps "IP" -app Steam -mapping mapfile.map
popd
_EOF_

    # Chmod scripts to be runnable
    chmod +x "$romdir/moonlight/"*.sh

    # Add System to es_system.cfg
    setESSystem 'moonlight Game Streaming' 'moonlight' '~/RetroPie/roms/moonlight' '.sh .SH' '%ROM%' 'pc' 'moonlight'

    echo "##########################"
    echo "##########################"
    echo "Please do this by yourself:"
    echo "";
    echo "Discover your PC:"
    echo "moolight discover"
    echo "";
    echo "Pair with your PC:"
    echo "moolight pair <IP>"
    echo "";
    echo "get your controller event id (/dev/input/eventX):"
    echo "";
    echo "";
    echo "Map your controller"
    echo "moolight map -input /dev/input/eventX mapfile.map"
    echo "";
    echo "put the mapfile.map file in $md_inst"
    echo "";
    echo "edit the files in the roms/moonlight folder. Add your IP there"
    sleep 10;



    echo -e "\nEverything done! Now reboot the Pi and you are all set \n"
}
