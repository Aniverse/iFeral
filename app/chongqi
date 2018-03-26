#!/bin/bash
#
############################
##### Basic Info Start #####
############################
#
# Script Author: randomesessence
#
# Script Contributors: none
#
# Bash Command for easy reference:
#
# wget -qO ~/restart http://git.io/5Uw8Gw && bash ~/restart
#
# The MIT License (MIT)
#
# Copyright (c) 2016 randomessence
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
############################
###### Basic Info End ######
############################
#
############################
#### Script Notes Start ####
############################
#
##
#
############################
##### Script Notes End #####
############################
#
############################
## Version History Starts ##
############################
#
if [[ ! -z "$1" && "$1" = 'changelog' ]]
then
    echo
    #
    echo 'v1.1.6 - And he tooketh the holy hammer and hit it until it wath fixeth.'
    echo 'v1.0.9 - deluge restart'
    echo 'v1.0.8 - tweak to rtorrent restart to check for orphaned lock file.'
    echo 'v1.0.7 - rtorrent and deluge will no longer kill custom instances from the multirtru script. Transmision restart timer imeplemented. Other minor tweaks'
    echo 'v1.0.6 - Template updated'
    echo 'v1.0.5 - Template updated'
    #
    echo
    exit
fi
#
############################
### Version History Ends ###
############################
#
############################
###### Variable Start ######
############################
#
# Script Version number is set here.
scriptversion="1.1.7"
#
# Script name goes here. Please prefix with install.
scriptname="restart"
#
# Author name goes here.
scriptauthor="randomessence"
#
# Contributor's names go here.
contributors="None credited"
#
# Set the http://git.io/ shortened URL for the raw github URL here:
gitiourl="http://git.io/5Uw8Gw"
#
# Don't edit: This is the bash command shown when using the info option.
gitiocommand="wget -qO ~/$scriptname $gitiourl && bash ~/$scriptname"
#
# This is the raw github url of the script to use with the built in updater.
scripturl="https://raw.github.com/feralhosting/feralfilehosting/master/Feral%20Wiki/Installable%20software/Restarting%20-%20rtorrent%20-%20Deluge%20-%20Transmission%20-%20MySQL/scripts/restart.sh"
#
# This will generate a 20 character random passsword for use with your applications.
apppass="$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)"
# This will generate a random port for the script between the range 10001 to 32001 to use with applications. You can ignore this unless needed.
appport="$(shuf -i 10001-32001 -n 1)"
#
# This wil take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(netstat -ln | grep ':'"$appport"'' | grep -c 'LISTEN')" -eq "1" ]]; do appport="$(shuf -i 10001-32001 -n 1)"; done
#
# Script user's http www URL in the format http://username.server.feralhosting.com/
host1http="http://$(whoami).$(hostname -f)/"
# Script user's https www URL in the format https://username.server.feralhosting.com/
host1https="https://$(whoami).$(hostname -f)/"
# Script user's http www url in the format https://server.feralhosting.com/username/
host2http="http://$(hostname -f)/$(whoami)/"
# Script user's https www url in the format https://server.feralhosting.com/username/
host2https="https://$(hostname -f)/$(whoami)/"
#
# feralwww - sets the full path to the default public_html directory if it exists.
[[ -d ~/www/"$(whoami)"."$(hostname -f)"/public_html ]] && feralwww="$HOME/www/$(whoami).$(hostname -f)/public_html/"
# rtorrentdata - sets the full path to the rtorrent data directory if it exists.
[[ -d ~/private/rtorrent/data ]] && rtorrentdata="$HOME/private/rtorrent/data"
# deluge - sets the full path to the deluge data directory if it exists.
[[ -d ~/private/deluge/data ]] && delugedata="$HOME/private/deluge/data"
# transmission - sets the full path to the transmission data directory if it exists.
[[ -d ~/private/transmission/data ]] && transmissiondata="$HOME/private/transmission/data"
#
# Bug reporting varaibles.
gitissue="https://github.com/feralhosting/feralfilehosting/issues/new"
#
############################
## Custom Variables Start ##
############################
#
##
#
############################
### Custom Variables End ###
############################
#
# Disables the built in script updater permanently by setting this variable to 0.
updaterenabled="0"
#
############################
####### Variable End #######
############################
#
############################
###### Function Start ######
############################
#
showMenu () 
{
    echo "1"": Restart rtorrent"
    echo "2"": Restart Deluge"
    echo "3"": Restart Tranmission"
    echo "4"": Restart MySQL"
    echo "5"": quit"
}
#
############################
####### Function End #######
############################
#
############################
#### Script Help Starts ####
############################
#
if [[ ! -z "$1" && "$1" = 'help' ]]
then
    echo
    echo -e "\033[32m""Script help and usage instructions:""\e[0m"
    echo
    #
    ###################################
    ##### Custom Help Info Starts #####
    ###################################
    #
    echo "To troubleshoot rtorrent not starting you should do this:"
    echo
    echo -e "Use the command: rtorrent"
    #
    ###################################
    ###### Custom Help Info Ends ######
    ###################################
    #
    echo
    exit
fi
#
############################
##### Script Help Ends #####
############################
#
############################
#### Script Info Starts ####
############################
#
# Use this to show a user script information when they use the info option with the script.
if [[ ! -z "$1" && "$1" = 'info' ]]
then
    echo
    echo -e "\033[32m""Script Details:""\e[0m"
    echo
    echo "Script version: $scriptversion"
    echo
    echo "Script Author: $scriptauthor"
    echo
    echo "Script Contributors: $contributors"
    echo
    echo -e "\033[32m""Script options:""\e[0m"
    echo
    echo -e "\033[36mhelp\e[0m = See the help section for this script."
    echo
    echo -e "Example usage: \033[36m$scriptname help\e[0m"
    echo
    echo -e "\033[36mchangelog\e[0m = See the version history and change log of this script."
    echo
    echo -e "Example usage: \033[36m$scriptname changelog\e[0m"
    echo
    echo -e "\033[36minfo\e[0m = Show the script information and usage instructions."
    echo
    echo -e "Example usage: \033[36m$scriptname info\e[0m"
    echo
    echo -e "\033[31mImportant note:\e[0m Options \033[36mqr\e[0m and \033[36mnu\e[0m are interchangeable and usable together."
    echo
    echo -e "For example: \033[36m$scriptname qr nu\e[0m or \033[36m$scriptname nu qr\e[0m will both work"
    echo
    echo -e "\033[36mqr\e[0m = Quick Run - use this to bypass the default update prompts and run the main script directly."
    echo
    echo -e "Example usage: \033[36m$scriptname qr\e[0m"
    echo
    echo -e "\033[36mnu\e[0m = No Update - disable the built in updater. Useful for testing new features or debugging."
    echo
    echo -e "Example usage: \033[36m$scriptname nu\e[0m"
    echo
    echo -e "\033[32mBash Commands:\e[0m"
    echo
    echo -e "\033[36m""$gitiocommand""\e[0m"
    echo
    echo -e "\033[36m""~/bin/$scriptname""\e[0m"
    echo
    echo -e "\033[36m""$scriptname""\e[0m"
    echo
    echo -e "\033[32m""Bug Reporting:""\e[0m"
    echo
    echo -e "You can create an issue directly on github using your github account."
    echo
    echo -e "\033[36m""$gitissue""\e[0m"
    echo
    echo -e "\033[33m""All bug reports are welcomed and very much appreciated, as they benefit all users.""\033[32m"
    #
    echo
    exit
fi
#
############################
##### Script Info Ends #####
############################
#
############################
#### Self Updater Start ####
############################
#
# Checks for the positional parameters $1 and $2 to be reset if the script is updated.
[[ ! -z "$1" && "$1" != 'qr' ]] || [[ ! -z "$2" && "$2" != 'qr' ]] && echo -en "$1\n$2" > ~/.passparams
# Quick Run option part 1: If qr is used it will create this file. Then if the script also updates, which would reset the option, it will then find this file and set it back.
[[ ! -z "$1" && "$1" = 'qr' ]] || [[ ! -z "$2" && "$2" = 'qr' ]] && echo -n '' > ~/.quickrun
# No Update option: This disables the updater features if the script option "nu" was used when running the script.
if [[ ! -z "$1" && "$1" = 'nu' ]] || [[ ! -z "$2" && "$2" = 'nu' ]]; then
    scriptversion="$scriptversion-nu"
    echo -e "\nThe Updater has been temporarily disabled\n"
else
    # Check to see if the variable "updaterenabled" is set to 1. If it is set to 0 the script will bypass the built in updater regardless of the options used.
    if [[ "$updaterenabled" -eq "1" ]]; then
        [[ ! -d ~/bin ]] && mkdir -p ~/bin
        [[ ! -f ~/bin/"$scriptname" ]] && wget -qO ~/bin/"$scriptname" "$scripturl"
        wget -qO ~/.000"$scriptname" "$scripturl"
        if [[ "$(sha256sum ~/.000"$scriptname" | awk '{print $1}')" != "$(sha256sum ~/bin/"$scriptname" | awk '{print $1}')" ]]; then
            echo -e "#!/bin/bash\nwget -qO ~/bin/$scriptname $scripturl\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.111"$scriptname" && bash ~/.111"$scriptname"; exit
        else
            if [[ -z "$(pgrep -fu "$(whoami)" "bash $HOME/bin/$scriptname")" && "$(pgrep -fu "$(whoami)" "bash $HOME/bin/$scriptname")" -ne "$$" ]]; then
                echo -e "#!/bin/bash\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.222"$scriptname" && bash ~/.222"$scriptname"; exit
            fi
        fi
        cd && rm -f .{000,111,222}"$scriptname" && chmod -f 700 ~/bin/"$scriptname"
        echo
    else
        scriptversion="$scriptversion-DEV"
        echo -e "\nThe Updater has been disabled\n"
    fi
fi
# Quick Run option part 2: If quick run was set and the updater section completes this will enable quick run again then remove the file.
[[ -f ~/.quickrun ]] && updatestatus="y"; rm -f ~/.quickrun
# resets the positional parameters $1 and $2 post update.
[[ -f ~/.passparams ]] && set "$1" "$(sed -n '1p' ~/.passparams)" && set "$2" "$(sed -n '2p' ~/.passparams)"; rm -f ~/.passparams
#
############################
##### Self Updater End #####
############################
#
############################
#### Core Script Starts ####
############################
#
if [[ "$updatestatus" = "y" ]]
then
    :
else
    echo -e "Hello $(whoami), you have the latest version of the" "\033[36m""$scriptname""\e[0m" "script. This script version is:" "\033[31m""$scriptversion""\e[0m"
    echo
    read -ep "The script has been updated, enter [y] to continue or [q] to exit: " -i "y" updatestatus
    echo
fi
#
if [[ "$updatestatus" =~ ^[Yy]$ ]]
then
#
############################
#### User Script Starts ####
############################
#
while [ 1 ]
do
    showMenu
    echo
    read -ep "Enter the number of the action you wish to complete: " CHOICE
    case "$CHOICE" in
        "1")
            echo
            if [[ -d ~/private/rtorrent ]]
            then
                echo -e "\033[31m""Killing all instances of rtorrent""\e[0m"
                echo
                kill -9 "$(screen -ls rtorrent | sed -rn 's/(.*).rtorrent[^-](.*)/\1/p')" > /dev/null 2>&1
                screen -wipe > /dev/null 2>&1
                echo "Restarting rtorrent"
                echo
                # Test to see if rtorrent is running, if the result is null and the respective lock file exists then delete the lock file. Otherwise do nothing.
                [[ -z "$(pgrep -fu "$(whoami)" "/opt/rtorrent/current/bin/rtorrent")" && -f ~/private/rtorrent/work/rtorrent.lock ]] && rm -f ~/private/rtorrent/work/rtorrent.lock
                #
                screen -fa -dmS rtorrent rtorrent
                sleep 2
                echo -e "\033[33m""Checking if the process is running:""\e[0m"
                echo
                echo "$(ps x | grep "/opt/rtorrent/current/bin/rtorrent" | grep -v grep)"
                echo
                echo -e "\033[33m""Checking if the screen is running""\e[0m"
                echo
                echo "$(screen -ls | grep rtorrent)"
                echo
                echo -e "\033[32m""For troubleshooting refer to the FAQ:""\e[0m" "\033[36m""https://www.feralhosting.com/faq/view?question=158""\e[0m"
                echo
                echo -e "To restart other instances of rtorrent/rutorrent installed by the script check this file:" "\033[36m""~/multirtru.restart.txt""\e[0m"
                echo
                sleep 2
            else
                echo -e "\033[31m""rTorrent is not installed. Nothing to do""\e[0m"
                echo
            fi
            ;;
        "2")
            ##
            echo
            if [[ -d ~/private/deluge ]]
            then
                echo -e "\033[31m""Restarting Deluge""\e[0m"
                echo
                killall -9 -u $(whoami) deluged deluge-web > /dev/null 2>&1
                rm -rf ~/.config/deluge/deluged.pid
                deluged > /dev/null 2>&1
                sleep 4
                if [[ -f ~/.config/deluge/deluged.pid ]] 
                then
                    echo -e "Deluged was started\n"
                else   
                    echo -e "Please open a ticket labelled\n\n""Deluge port in use - $(hostname)\n\n""https://www.feralhosting.com/manager/tickets/new\n"
                    sleep 2
                    exit
                fi
                if [[ "$(date +%-M)" -le '4' ]] && [[ "$(date +%-M)" -ge '0' ]]; then time="$(( 5 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '9' ]] && [[ "$(date +%-M)" -ge '5' ]]; then time="$(( 10 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '14' ]] && [[ "$(date +%-M)" -ge '10' ]]; then time="$(( 15 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '19' ]] && [[ "$(date +%-M)" -ge '15' ]]; then time="$(( 20 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '24' ]] && [[ "$(date +%-M)" -ge '20' ]]; then time="$(( 25 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '29' ]] && [[ "$(date +%-M)" -ge '25' ]]; then time="$(( 30 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '34' ]] && [[ "$(date +%-M)" -ge '30' ]]; then time="$(( 35 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '39' ]] && [[ "$(date +%-M)" -ge '35' ]]; then time="$(( 40 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '44' ]] && [[ "$(date +%-M)" -ge '40' ]]; then time="$(( 45 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '49' ]] && [[ "$(date +%-M)" -ge '45' ]]; then time="$(( 50 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '54' ]] && [[ "$(date +%-M)" -ge '50' ]]; then time="$(( 55 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '59' ]] && [[ "$(date +%-M)" -ge '55' ]]; then time="$(( 60 * 60 ))"; fi
                #
                while [[ "$(pgrep -cfu $(whoami) "deluge-web -f$")" -eq "0" ]]
                do
                    countdown="$(( $time-$(($(date +%-M) * 60 + $(date +%-S))) ))"
                    printf '\rDeluge-web will restart in approximately: %dm:%ds ' $(($countdown%3600/60)) $(($countdown%60))
                done
                echo -e '\n'
                #
                echo -e "\033[31m""$(ps x | grep -v grep | grep 'deluge')""\e[0m"
                echo
                echo -e "\033[32m""For troubleshooting refer to the FAQ:""\e[0m" "\033[36m""https://www.feralhosting.com/faq/view?question=158""\e[0m"
                echo
            else
                echo -e "\033[31m""Deluge is not installed. Nothing to do""\e[0m"
                echo
            fi
            ;;
        "3")
            echo
            if [[ -d ~/private/transmission ]]
            then
                echo -e "\033[31m""Restarting Transmission""\e[0m"
                echo
                killall -9 -u "$(whoami)" transmission-daemon > /dev/null 2>&1
                sleep 2
                echo "Waiting for Transmission to reload. It loads every 5 minutes starting from 00 of the hour"
                echo
                #
                if [[ "$(date +%-M)" -le '4' ]] && [[ "$(date +%-M)" -ge '0' ]]; then time="$(( 5 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '9' ]] && [[ "$(date +%-M)" -ge '5' ]]; then time="$(( 10 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '14' ]] && [[ "$(date +%-M)" -ge '10' ]]; then time="$(( 15 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '19' ]] && [[ "$(date +%-M)" -ge '15' ]]; then time="$(( 20 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '24' ]] && [[ "$(date +%-M)" -ge '20' ]]; then time="$(( 25 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '29' ]] && [[ "$(date +%-M)" -ge '25' ]]; then time="$(( 30 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '34' ]] && [[ "$(date +%-M)" -ge '30' ]]; then time="$(( 35 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '39' ]] && [[ "$(date +%-M)" -ge '35' ]]; then time="$(( 40 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '44' ]] && [[ "$(date +%-M)" -ge '40' ]]; then time="$(( 45 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '49' ]] && [[ "$(date +%-M)" -ge '45' ]]; then time="$(( 50 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '54' ]] && [[ "$(date +%-M)" -ge '50' ]]; then time="$(( 55 * 60 ))"; fi
                if [[ "$(date +%-M)" -le '59' ]] && [[ "$(date +%-M)" -ge '55' ]]; then time="$(( 60 * 60 ))"; fi
                #
                while [[ "$(pgrep -cfu "$(whoami)" 'transmission-daemon -e /dev/null')" -eq "0" ]]
                do
                    countdown="$(( $time-$(($(date +%-M) * 60 + $(date +%-S))) ))"
                    printf '\rTransmission will restart in approximately: %dm:%ds ' $(($countdown%3600/60)) $(($countdown%60))
                done
                echo -e '\n'
                #
                echo -e "\033[31m""$(ps x | grep -v grep | grep 'transmission-daemon -e /dev/null')""\e[0m"
                echo
                echo -e "\033[32m""For troubleshooting refer to the FAQ:""\e[0m" "\033[36m""https://www.feralhosting.com/faq/view?question=158""\e[0m"
                echo
                sleep 2
            else
                echo -e "\033[31m""Transmission is not installed. Nothing to do""\e[0m"
                echo
            fi
            ;;
        "4")
            echo
            if [[ -d ~/private/mysql ]]
                then
                echo -e "\033[31m""Restarting MySQL""\e[0m"
                echo
                killall -u "$(whoami)" mysqld mysqld_safe  > /dev/null 2>&1
                bash ~/private/mysql/launch.sh > /dev/null 2>&1
                echo "Mysql has been restarted"
                echo
                echo -e "\033[32m""For troubleshooting refer to the FAQ:""\e[0m" "\033[36m""https://www.feralhosting.com/faq/view?question=158""\e[0m"
                echo
                sleep 2
            else
                echo -e "\033[31m""Mysql is not installed, nothing to restart. Please install it first""\e[0m"
                echo
            fi
            ;;
        "5")
            echo
            echo -e "\033[31m""You chose to quit this script""\e[0m"
            echo
            exit
            ;;
    esac
done
#
############################
##### User Script End  #####
############################
#
else
    echo -e "You chose to exit after updating the scripts."
    echo
    cd && bash
    exit
fi
#
############################
##### Core Script Ends #####
############################
#