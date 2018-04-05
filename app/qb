#!/usr/bin/env bash
set -euo pipefail
#
# Copyright (c) 2017 Feral Hosting. This content may not be used elsewhere without explicit permission from Feral Hosting.
#
# This script can be used to install qBittorrent and run initial configuration. It can also restart it and uninstall it.

# Functions

qbittorrentMenu ()
{
    echo -e "\033[36m""qBittorrent""\e[0m"
    echo "1 Install qBittorrent"
    echo "2 Restart qBittorrent"
    echo "3 Uninstall qBittorrent"
    echo "q Quit the script"
}

binCheck () # checks for ~/bin
{
    if [[ ! -d ~/bin ]]
    then
        echo "Creating ~/bin first"
        mkdir -p ~/bin
    fi
}

cronAdd () # creates a temp cron to a variable, makes the necessary files. Each software to then check to see if job exists and add if not.
{
    tmpcron="$(mktemp)"
    mkdir -p ~/.cronjobs/logs
}

portGenerator () # generates a port to use with software installs
{
    portGen=$(shuf -i 10001-32001 -n 1)
}

portCheck () # runs a check to see if the port generated can be used
{
    while [[ "$(netstat -ln | grep ':'"$portGen"'' | grep -c 'LISTEN')" -eq "1" ]];
    do
        portGenerator;
    done
}

while [[ 1 ]]
do
    echo
    qbittorrentMenu
    echo
    read -ep "Enter the number of the option you want: " CHOICE
    echo
    case "$CHOICE" in
        "1") # install qbittorent
            binCheck
            echo "Getting the necessary files and extracting them..." # need to get a lot of .debs for this...
            wget -q http://ftp.nl.debian.org/debian/pool/main/b/boost1.62/libboost-chrono1.62.0_1.62.0+dfsg-4_amd64.deb
            dpkg -x libboost-chrono1.62.0_1.62.0+dfsg-4_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/b/boost1.62/libboost-random1.62.0_1.62.0+dfsg-4_amd64.deb
            dpkg -x libboost-random1.62.0_1.62.0+dfsg-4_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/b/boost1.62/libboost-system1.62.0_1.62.0+dfsg-4_amd64.deb
            dpkg -x libboost-system1.62.0_1.62.0+dfsg-4_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/libt/libtorrent-rasterbar/libtorrent-rasterbar9_1.1.1-1+b1_amd64.deb
            dpkg -x libtorrent-rasterbar9_1.1.1-1+b1_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/p/pcre3/libpcre16-3_8.39-3_amd64.deb
            dpkg -x libpcre16-3_8.39-3_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.0f-3+deb9u1_amd64.deb
            dpkg -x libssl1.1_1.1.0f-3+deb9u1_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/d/double-conversion/libdouble-conversion1_2.0.1-4_amd64.deb
            dpkg -x libdouble-conversion1_2.0.1-4_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/q/qtbase-opensource-src/libqt5core5a_5.7.1+dfsg-3+b1_amd64.deb
            dpkg -x libqt5core5a_5.7.1+dfsg-3+b1_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/q/qtbase-opensource-src/libqt5dbus5_5.7.1+dfsg-3+b1_amd64.deb
            dpkg -x libqt5dbus5_5.7.1+dfsg-3+b1_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/q/qtbase-opensource-src/libqt5network5_5.7.1+dfsg-3+b1_amd64.deb
            dpkg -x libqt5network5_5.7.1+dfsg-3+b1_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/q/qtbase-opensource-src/libqt5xml5_5.7.1+dfsg-3+b1_amd64.deb
            dpkg -x libqt5xml5_5.7.1+dfsg-3+b1_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/q/qbittorrent/qbittorrent-nox_3.3.7-3_amd64.deb
            dpkg -x qbittorrent-nox_3.3.7-3_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/g/gcc-6/libstdc++6_6.3.0-18+deb9u1_amd64.deb
            dpkg -x libstdc++6_6.3.0-18+deb9u1_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/i/icu/libicu57_57.1-6+deb9u1_amd64.deb
            dpkg -x libicu57_57.1-6+deb9u1_amd64.deb ~/deb-temp
            wget -q http://ftp.nl.debian.org/debian/pool/main/libp/libproxy/libproxy1_0.4.11-4+b2_amd64.deb 
            dpkg -x libproxy1_0.4.11-4+b2_amd64.deb ~/deb-temp
            echo "Making the directories, configuring..."
            rm -rf ~/lib/qt5 ~/lib/engines-1.1 #removing any remnants of a previous install to avoid errors if users reinstall
            mkdir -p ~/lib
            mv ~/deb-temp/usr/lib/x86_64-linux-gnu/* ~/lib/
            mv ~/deb-temp/usr/bin/* ~/bin/
            rm -rf ~/*.deb ~/deb-temp
            mkdir -p ~/.config/qBittorrent
            echo "[LegalNotice]
Accepted=true

[Preferences]
General\Locale=en_GB
WebUI\Port=8080
Downloads\SavePath=private/qBittorrent/data" > ~/.config/qBittorrent/qBittorrent.conf # sets an initial configuration
            portGenerator
            portCheck
            sed -i "s|Port=8080|Port=$portGen|g" ~/.config/qBittorrent/qBittorrent.conf
            screen -dmS qBittorrent /bin/bash -c 'export LD_LIBRARY_PATH=~/lib:/usr/lib; ~/bin/qbittorrent-nox'
            echo "Adding cron task to autostart on server reboot..."
            cronAdd
            if [[ "$(crontab -l 2> /dev/null | grep -oc "^\@reboot screen -dmS qBittorrent /bin/bash -c 'export LD_LIBRARY_PATH=~/lib:/usr/lib; ~/bin/qbittorrent-nox'$")" == "0" ]]
            then
                crontab -l 2> /dev/null > "$tmpcron"
                echo "@reboot screen -dmS qBittorrent /bin/bash -c 'export LD_LIBRARY_PATH=~/lib:/usr/lib; ~/bin/qbittorrent-nox'" >> "$tmpcron"
                crontab "$tmpcron"
                rm "$tmpcron"
                echo
            else
                echo "This cron job already exists in the crontab"
                echo
            fi
            echo "$(/bin/bash -c 'export LD_LIBRARY_PATH=~/lib:/usr/lib; ~/bin/qbittorrent-nox -v') has been installed - access it on the URL below:"
            echo
            echo "http://$(whoami).$(hostname -f):$(sed -rn 's|WebUI\\Port=||p' ~/.config/qBittorrent/qBittorrent.conf)"
            echo
            echo -e "The default username is" "\033[36m""admin""\e[0m""\n""The default password is" "\033[36m""adminadmin""\e[0m"
            echo
            echo "You should change these as soon as possible:"
            echo -e "1. In qBittorrent click on the" "\033[36m""preferences""\e[0m" "icon."
            echo -e "2. Click the" "\033[36m""webUI""\e[0m" "tab."
            echo -e "3. Scroll down to the" "\033[36m""Authentication""\e[0m" "section."
            echo -e "4. Make the changes to the username and password you want then scroll down and click \033[36m""Save""\e[0m""."
            ;;
            "q") # quit the script entirely
            exit
            ;;
        "2") # restart qBittorrent
            if [[ ! -f ~/.config/qBittorrent/qBittorrent.conf ]]
            then
                echo "You don't have a config file for qBittorrent - you need to (re)install it"
                break
            fi
            echo "Stopping any instances of qBittorrent..."
            pkill -fxu $(whoami) 'SCREEN -dmS qBittorrent /bin/bash -c export LD_LIBRARY_PATH=~/lib:/usr/lib; ~/bin/qbittorrent-nox' || true
            sleep 3
             echo "Starting it back up..."
            screen -dmS qBittorrent /bin/bash -c 'export LD_LIBRARY_PATH=~/lib:/usr/lib; ~/bin/qbittorrent-nox'
            sleep 3
            if pgrep -fu "$(whoami)" 'SCREEN -dmS qBittorrent' > /dev/null 2>&1
            then
                echo "qBittorrent has been restarted."
            else
                echo
                echo "Failing to start up qBittorrent:"
                /bin/bash -c 'export LD_LIBRARY_PATH=~/lib:/usr/lib; ~/bin/qbittorrent-nox'
            fi
            ;;
        "3") # uninstall
            echo -e "Uninstalling qBittorrent will" "\033[31m""remove the qBittorrent software, the associated torrents, their data and the software settings""\e[0m"
            read -ep "Are you sure you want to uninstall? [y] yes or [n] no: " CONFIRM
            if [[ $CONFIRM =~ ^[Yy]$ ]]
            then
                pkill -9 -fu "$(whoami)" 'SCREEN -dmS qBittorrent' || true
                rm -rf ~/.config/qBittorrent ~/private/qBittorrent
                crontab -u $(whoami) -l | grep -v "@reboot screen -dmS qBittorrent /bin/bash -c 'export LD_LIBRARY_PATH=~/lib:/usr/lib; ~/bin/qbittorrent-nox'" | crontab -u $(whoami) - # remove from crontab
                echo "qBittorrent has been removed."
                echo
                break
            else
                echo "Taking no action..."
                echo
            fi
            ;;
        "q") # quit the script entirely
            exit
            ;;
    esac
done