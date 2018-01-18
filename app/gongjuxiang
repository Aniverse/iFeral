#!/bin/bash
#
#########################################################
##### Basic Info Start ##################################
#########################################################
#
# Script Author: Dedsec
#
# 
#
# License: This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License. https://creativecommons.org/licenses/by-sa/4.0/
#
# Bash Command for easy reference:
#
# wget -qO ~/Toolkit.sh https://git.io/v2anV  && bash ~/Toolkit.sh
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
    # put your version changes in the single quotes and then uncomment the line.
    #
    echo 'v1.1.5 auth group removed'
    echo 'v1.1.4 template updated'
    echo 'v1.1.2 template updated'
    echo '1.1.1 nginx rcp specific options for default and multple instances. tweaked the way option 18 works.'
    echo '1.1.0 Changes to Authname generation to avoid conflict or allow single login'
    echo '1.0.5 multi rtorrent/rutorrent options'
    echo '1.0.4 nginx /links and apache /links options added'
    echo '1.0.3 Updater included.'
    echo '1.0.2 Better checks for option 1 with explanations on htaccess'
    echo '1.0.1 wgets itself and puts it in the ~/bin with 700. Added files exist checks for all htpasswd calls. Cosmetics'
    echo '1.0.0 A working and functional script.'
    echo 'v0.5.0 Main options created and refined producing a usable script'
    echo 'v0.0.1 - 0.0.1 Initial Version'
    #
    echo
    exit
fi
#
############################
### Version History Ends ###
###########################
#
############################
###### Variable Start #######
############################
#
# Script Version number is set here.
scriptversion="2.2"
#
# Script name goes here. Please prefix with install.
scriptname="Feral-Toolkit"
#
# Author name goes here.
scriptauthor="Dedsec"
#
# Contributor's names go here.
contributors="None credited"
#
# Set the http://git.io/ shortened URL for the raw github URL here:
gitiourl="http://git.io/eJySww"
#
# Don't edit: This is the bash command shown when using the info option.
gitiocommand="wget -qO ~/$scriptname $gitiourl && bash ~/$scriptname"
#
# This is the raw github url of the script to use with the built in updater.
scripturl="https://raw.githubusercontent.com/Dedsec1/feral/master/mainmenu.sh"
#
# This will generate a 20 character random passsword for use with your applications.
apppass="$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)"
# This will generate a random port for the script between the range 10001 to 49999 to use with applications. You can ignore this unless needed.
appport="$(shuf -i 10001-49999 -n 1)"
#
# This wil take the previously generated port and test it to make sure it is not in use, generating it again until it has selected an open port.
while [[ "$(netstat -ln | grep ':'"$appport"'' | grep -c 'LISTEN')" -eq "1" ]]; do appport="$(shuf -i 10001-49999 -n 1)"; done
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
makeissue=".makeissue $scriptname A description of the issue"
ticketurl="https://www.feralhosting.com/manager/tickets/new"
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
##########################
#
############################
###### Function Start ######
############################
#
showMenu () 
{
    echo -e "\033[32m""Feral Toolkit Menus""\e[0m"
    #
    echo -e "\033[31m""1""\e[0m" "Slot Diagnosis Tools" "\033[36m""""\e[0m" """\e[0m"
    #
    echo -e "\033[31m""2""\e[0m" "Software Installation Tools" "\033[36m""""\e[0m" ""
    #
    echo -e "\033[31m""3""\e[0m" "Htpasswd toolkit Menu" "\033[36m""""\e[0m"
    #
    echo -e "\033[31m""4""\e[0m" "Rutorrent Tools Menu" "\033[36m""""\e[0m"
    #
    echo -e "\033[31m""5""\e[0m" "Quit" "\033[36m""""\e[0m" "" "\033[36m""""\e[0m"
    #   
    #echo -e "\033[31m""6""\e[0m" "Rutorrent Client Configuration Tools" "\033[36m""""\e[0m" ""
    #
    #echo -e "\033[32m""Torrent Client Configuration""\e[0m"
    #
    #echo -e "\033[31m""7""\e[0m" "\033[1;30m""RuTorrent:""\e[0m" "Change the existing Rutorrent .htaccess to use" "\033[36m""~/private/.htpasswd""\e[0m"
    #
    #echo -e "\033[31m""8""\e[0m" "\033[1;30m""RuTorrent:""\e[0m" "Add or edit a user in the existing Rutorrent .htpasswd"
    #
    #echo -e "\033[31m""9""\e[0m" "\033[1;30m""RuTorrent:""\e[0m" "Delete a user in the existing Rutorrent .htpasswd"
    #
    #echo -e "\033[31m""10""\e[0m" "\033[1;30m""RuTorrent:""\e[0m" "Protect the" "\033[36m""/links""\e[0m" "directory using" "\033[36m""/rutorrent/.htpasswd""\e[0m"
    #
    #echo -e "\033[31m""11""\e[0m" "\033[1;30m""RuTorrent:""\e[0m" "List" "\033[36m""/rutorrent/.htpasswd""\e[0m" "users and their order"
    #
    #echo -e "\033[32m""Other tools section""\e[0m"
    #
    #echo -e "\033[31m""12""\e[0m" "Change all" "\033[36m""public_html""\e[0m" ".htaccess to use the" "\033[36m""~/private/.htpasswd""\e[0m" "AuthFile path" "\033[33m""(if present)""\e[0m"
    #
    #echo -e "\033[31m""13""\e[0m" "Change all" "\033[36m""public_html""\e[0m" ".htaccess to use the" "\033[36m""/rutorrent/.htpasswd""\e[0m" "AuthFile path" "\033[33m""(if present)""\e[0m"
    #
    #echo -e "\033[31m""14""\e[0m" "Change all" "\033[36m""public_html""\e[0m" ".htaccess to use a custom AuthFile path" "\033[33m""(if present)""\e[0m"
    #
    #echo -e "\033[32m""Nginx specific options section""\e[0m"
    #
    #echo -e "\033[31m""15""\e[0m" "Protect the" "\033[36m""/links""\e[0m" "directory using the" "\033[36m""~/private/.htpasswd""\e[0m"
    #
    #echo -e "\033[31m""16""\e[0m" "Protect the" "\033[36m""/links""\e[0m" "directory using the" "\033[36m""/rutorrent/.htpasswd""\e[0m"
    #
    #echo -e "\033[31m""17""\e[0m" "Change the rpc password only for the user \"rutorrent\" linked to your default rutorrent installation"
    #
    #echo -e "\033[32m""Multi Rtorrent/Rutorrent specific options section""\e[0m"
    #
    #echo -e "\033[31m""18""\e[0m" "\033[1;30m""Multi Rtorrent/Rutorrent:""\e[0m" "Add or edit a user in the existing Rutorrent-suffix .htpasswd/nginx rpc"
    #
    #echo -e "\033[31m""19""\e[0m" "\033[1;30m""Multi Rtorrent/Rutorrent:""\e[0m" "Delete a user in the existing Rutorrent .htpasswd"
    #
    #echo -e "\033[31m""20""\e[0m" "\033[1;30m""Multi Rtorrent/Rutorrent:""\e[0m" "List" "\033[36m""/rutorrent/.htpasswd""\e[0m" "users and their order"
    #
    #echo -e "\033[31m""21""\e[0m" "Change the rpc password only for the user \"rutorrent\" on the specified instance"
    #
    #echo -e "\033[31m""22""\e[0m" "\033[32m""Quit""\e[0m"
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
    echo -e "Put your help instructions or script guidance here"
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
    echo -e "These are the recommended ways to report bugs for scripts in the FAQs:"
    echo
    echo -e "1: In IRC you can use wikibot to create a github issue by using this command format:"
    echo
    echo -e "\033[36m""$makeissue""\e[0m"
    echo
    echo -e "2: You could open a ticket describing the problem with details of which script and what the problem is."
    echo
    echo -e "\033[36m""$ticketurl""\e[0m"
    echo
    echo -e "3: You can create an issue directly on github using your github account."
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
# Quick Run option part 1: If qr is used it will create this file. Then if the script also updates, which would reset the option, it will then find this file and set it back.
if [[ ! -z "$1" && "$1" = 'qr' ]] || [[ ! -z "$2" && "$2" = 'qr' ]];then echo -n '' > ~/.quickrun; fi
#
# No Update option: This disables the updater features if the script option "nu" was used when running the script.
if [[ ! -z "$1" && "$1" = 'nu' ]] || [[ ! -z "$2" && "$2" = 'nu' ]]
then
    echo
    echo "The Updater has been temporarily disabled"
    echo
    scriptversion="$scriptversion-nu"
else
    #
    # Check to see if the variable "updaterenabled" is set to 1. If it is set to 0 the script will bypass the built in updater regardless of the options used.
    if [[ "$updaterenabled" -eq "1" ]]
    then
        [[ ! -d ~/bin ]] && mkdir -p ~/bin
        [[ ! -f ~/bin/"$scriptname" ]] && wget -qO ~/bin/"$scriptname" "$scripturl"
        #
        wget -qO ~/.000"$scriptname" "$scripturl"
        #
        if [[ "$(sha256sum ~/.000"$scriptname" | awk '{print $1}')" != "$(sha256sum ~/bin/"$scriptname" | awk '{print $1}')" ]]
        then
            echo -e "#!/bin/bash\nwget -qO ~/bin/$scriptname $scripturl\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.111"$scriptname"
            bash ~/.111"$scriptname"
            exit
        else
            if [[ -z "$(pgrep -fu "$(whoami)" "bash $HOME/bin/$scriptname")" && "$(pgrep -fu "$(whoami)" "bash $HOME/bin/$scriptname")" -ne "$$" ]]
            then
                echo -e "#!/bin/bash\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.222"$scriptname"
                bash ~/.222"$scriptname"
                exit
            fi
        fi
        cd && rm -f .{000,111,222}"$scriptname"
        chmod -f 700 ~/bin/"$scriptname"
        echo
    else
        echo
        echo "The Updater has been disabled"
        echo
        scriptversion="$scriptversion-DEV"
    fi
fi
#
# Quick Run option part 2: If quick run was set and the updater section completes this will enable quick run again then remove the file.
if [[ -f ~/.quickrun ]];then updatestatus="y"; rm -f ~/.quickrun; fi
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
    echo -e "\033[32m""Hello $(whoami).""\e[0m" "Welcome to the Feral Toolkit." "\e[0m"
    echo -e "\033[33m""This toolkit is designed to help users doing various tasks quickly and efficiently.""\e[0m"
    echo
    #
    ###
    #
    ###### Start of functions attached to menu items
    while [ 1 ]
    do
        showMenu
        echo
        read -ep "Enter the number of the action you wish to complete: " CHOICE
        echo
        case "$CHOICE" in
    ##########
            "1") # Create a new ~/private/.htpasswd and user only
            wget -qO ~/submenu.sh https://git.io/v2as4  && bash ~/submenu.sh
                ;;
    ##########
            "2") # Create a new ~/private/.htpasswd,user and .htaccess.
               wget -qO ~/install-menu.sh https://git.io/v2oEw  && bash ~/install-menu.sh
                ;;
    ##########
            "3") # Add a new user or update an existing user, in your ~/private/.htpasswd
                wget -qO ~/htpasswdtk.sh http://git.io/eJySww && bash ~/htpasswdtk.sh
                ;;
    ##########
            "4") # Delete a user from your ~/private/.htpasswd
                wget -qO ~/Rutorrent-tools.sh https://git.io/v2Vug && bash ~/Rutorrent-tools.sh
                ;;
    ##########
            "5") # Protect the /links directory using ~/private/.htpasswd
                exit
                break
                ;;
    ##########
            "6") # Load the RuTorrent Configuration Tools Menu
                wget -qO ~/RuTorrent-Menu.sh  https://git.io/v2Vug  && bash ~/RuTorrent-Menu.sh
                ;;
    ##########
            "7") # RuTorrent: Change the existing Rutorrent .htaccess to use ~/private/.htpasswd
                if [[ -f $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htaccess ]]
                then
                    echo -e "\033[32m""This will change where the rutorrent htaccess looks for the htpasswd file""\e[0m"
                    read -ep "Are you sure you want to change this [y] or quit back to the menu [q] : " confirm
                    if [[ $confirm =~ ^[Yy]$ ]]; then
                        sed -i "s|AuthUserFile .*|AuthUserFile \"$HOME/private/.htpasswd\"|g" $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htaccess
                        sed -i "s|AuthName .*|AuthName \"Please Login\"|g" $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htaccess
                        echo -e "The path has been changed to:" "\033[36m""$HOME/private/.htpasswd""\e[0m"
                        sleep 2
                    fi
                else
                    echo -e "\033[31m" "The file does not exist." "\033[32m""Is RuTorrent installed?""\e[0m"
                    sleep 2
                fi
                ;;
    ##########
            "8") # RuTorrent: Add or edit a user in the existing Rutorrent .htpasswd
                if [[ -f $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd ]]
                then
                    echo -e "\033[1;32m""Note: Use a good password manager like keepass so you can easily manage good passwords.""\e[0m"
                    echo -e "\033[32m""Here is a list of the usernames and their order in your" "\033[36m""/rutorrent/.htpasswd""\e[0m"
                    echo -e "\033[1;31m"
                    cat $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd | cut -d: -f1
                    echo -e "\e[0m"
                    echo -e "\033[33m""Enter an existing username to update or a new one to create an entry.""\e[0m"
                    read -ep "What is the username you wish to create, if they are not listed above, or edit if they exist?: " username
                    htpasswd -m $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd $username
                    sleep 2
                else
                    echo -e "\033[31m" "The file does not exist." "\033[32m""Is RuTorrent installed?""\e[0m"
                    sleep 2
                fi
                ;;
    ##########
            "9") # RuTorrent: Delete a user in the existing Rutorrent .htpasswd
                if [[ -f $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd ]]
                then
                    echo -e "\033[32m""Here is a list of the usernames and their order in your" "\033[36m""/rutorrent/.htpasswd""\e[0m"
                    echo -e "\033[1;31m"
                    cat $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd | cut -d: -f1
                    echo -e "\e[0m"
                    echo -e "\033[33m""Enter username from the list to delete them.""\e[0m"
                    read -ep "What is the username you wish to remove?: " username
                    htpasswd -D $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd $username
                    sleep 2
                else
                    echo -e "\033[31m" "The file does not exist." "\033[32m""Is RuTorrent installed?""\e[0m"
                    sleep 2
                fi
                ;;
    ##########
            "10") #RuTorrent: Protect the /links directory using /rutorrent/.htpasswd
                if [[ -d $HOME/www/$(whoami).$(hostname -f)/public_html/links ]]
                then
                    echo -e "######\nAuthUserFile \"$HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd\"\nAuthName \"$(whoami)\"\nAuthType Basic\n#####\nRequire valid-user\n####\nSatisfy All\n###" > $HOME/www/$(whoami).$(hostname -f)/public_html/links/.htaccess
                    echo -e "The" "\033[36m""/links""\e[0m" "directory has been protected using the" "\033[36m""/rutorrent/.htpasswd""\e[0m"
                else
                    echo -e "The" "\033[36m""$HOME/www/$(whoami).$(hostname -f)/public_html/links""\e[0m" "does not exist"
                fi
                sleep 2
                ;;
    ##########
            "11") # RuTorrent: List .htpasswd users and their order
                if [[ -f $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd ]]
                then
                    echo -e "\033[32m""Here is a list of the usernames and their order in your" "\033[36m""/rutorrent/.htpasswd""\e[0m"
                    echo -e "\033[1;31m"
                    cat $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd | cut -d: -f1
                    echo -e "\e[0m"
                    sleep 4
                else
                    echo -e "\033[31m" "The file does not exist." "\033[32m""Is RuTorrent installed?""\e[0m"
                    sleep 2
                fi
                ;;
    ##########
            "12") # Change all public_html .htaccess to use the ~/private/.htpasswd AuthFile path (if present)
                echo -e "\033[31m""Warning: This will edit EVERY" "\033[36m"".htaccess""\e[0m" "\033[31m""in your WWW""\e[0m"
                echo -e "This will change all" "\033[31m"".htaccess""\e[0m" "files AuthFile line if it is present"
                read -ep "Do you wish to do this? [y] yes or [n] no: " confirm
                echo
                if [[ $confirm =~ ^[Yy]$ ]]
                then
                    if [[ -f $HOME/private/.htpasswd ]]
                    then
                        find $HOME/www/$(whoami).$(hostname -f)/public_html -type f -name ".htaccess" -exec sed -i "s|AuthUserFile .*|AuthUserFile \"$HOME/private/.htpasswd\"|g" {} \; -exec chmod 644 {} \;
                        find $HOME/www/$(whoami).$(hostname -f)/public_html -type f -name ".htaccess" -exec sed -i "s|AuthName .*|AuthName \"Please Login\"|g" {} \; -exec chmod 644 {} \;
                        echo "Job done."
                        sleep 2
                    else
                        echo "The file does not exist. Make sure the path is correct"
                        sleep 2
                    fi
                fi
                ;;
    ##########
            "13") # Change all public_html .htaccess to use the ~/rutorrent/.htpasswd AuthFile path (if present)
                echo -e "\033[31m""Warning: This will edit EVERY" "\033[36m"".htaccess""\e[0m" "\033[31m""in your WWW""\e[0m"
                echo -e "This will change all" "\033[31m"".htaccess""\e[0m" "files AuthFile line if it is present"
                read -ep "Do you wish to do this? [y] yes or [n] no: " confirm
                echo
                if [[ $confirm =~ ^[Yy]$ ]]
                then
                    if [[ -f $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd ]]
                    then
                        find $HOME/www/$(whoami).$(hostname -f)/public_html -type f -name ".htaccess" -exec sed -i "s|AuthUserFile .*|AuthUserFile \"$HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd\"|g" {} \; -exec chmod 644 {} \;
                        find $HOME/www/$(whoami).$(hostname -f)/public_html -type f -name ".htaccess" -exec sed -i "s|AuthName .*|AuthName \"$(whoami)\"|g" {} \; -exec chmod 644 {} \;
                        echo "Job done."
                        sleep 2
                    else
                        echo "The file does not exist. Make sure the path is correct"
                        sleep 2
                    fi
                fi
                ;;
    ##########
            "14") # Change all public_html .htaccess to use a custom AuthFile path (if present)
                echo -e "\033[31m""Warning: This will edit EVERY" "\033[36m"".htaccess""\e[0m" "\033[31m""in your WWW""\e[0m"
                echo -e "Please include" "\033[31m"".htpasswd""\e[0m" "in your path"
                echo -e "For example" "\033[31m""private/.htpasswd""\e[0m" "will work"
                read -ep "Please enter the relative path to your .htpasswd: ~/" path
                echo
                if [[ -f $HOME/$path ]]
                then
                    find $HOME/www/$(whoami).$(hostname -f)/public_html -type f -name ".htaccess" -exec sed -i "s|AuthUserFile .*|AuthUserFile \"$HOME/$path\"|g" {} \; -exec chmod 644 {} \;
                    find $HOME/www/$(whoami).$(hostname -f)/public_html -type f -name ".htaccess" -exec sed -i "s|AuthName .*|AuthName \"Please Login\"|g" {} \; -exec chmod 644 {} \;
                    echo "Job done."
                    sleep 2
                else
                    echo "The file ~/$path does not exist. Make sure the path is correct"
                    sleep 2
                fi
                ;;
    ##########
            "15") # Protect the /links directory using the ~/private/.htpasswd
                if [[ -f ~/private/.htpasswd && -d ~/.nginx/conf.d  ]]
                then
                echo -e 'location /links {\n    index  index.html  index.php  /_h5ai/server/php/index.php;\n    auth_basic "Please log in";\n    auth_basic_user_file '"$HOME"'/private/.htpasswd;\n}' > ~/.nginx/conf.d/000-default-server.d/links.conf
                /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                echo "Done. You may need to clear your browser cache to see the changes"
                echo
                sleep 2
                else
                    echo -e "\033[31m""required files and the folder" "\033[36m""~/.nginx/conf.d""\e[0m" "\033[31m""do not exist""\e[0m"
                    echo
                    sleep 2
                fi
                ;;
    ##########
            "16") # Protect the /links directory using the /rutorrent/.htpasswd
                if [[ -f ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd && -d ~/.nginx/conf.d ]]
                then
                echo -e 'location /links {\n    index  index.html  index.php  /_h5ai/server/php/index.php;\n    auth_basic "'"$(whoami)"'";\n    auth_basic_user_file '"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/rutorrent/.htpasswd;\n}' > ~/.nginx/conf.d/000-default-server.d/links.conf
                /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                echo "Done. You may need to clear your browser cache to see the changes"
                echo
                sleep 2
                else
                    echo -e "\033[31m""required files and the folder" "\033[36m""~/.nginx/conf.d""\e[0m" "\033[31m""do not exist""\e[0m"
                    echo
                    sleep 2
                fi
                ;;
    ##########
            "17") # change the rpc password for the user rutorrent
                if [[ -f ~/.nginx/conf.d/000-default-server.d/scgi-htpasswd ]]
                then
                    htpasswd -m "$HOME"/.nginx/conf.d/000-default-server.d/scgi-htpasswd rutorrent
                    sed -ri '/^rutorrent:(.*)/! s/(.*)//g' ~/.nginx/conf.d/000-default-server.d/scgi-htpasswd
                    sed -ri '/^$/d' ~/.nginx/conf.d/000-default-server.d/scgi-htpasswd
                    echo
                    sleep 2
                else
                    echo -e "\033[31m""required file " "\033[36m""~/.nginx/conf.d/000-default-server.d/scgi-htpasswd""\e[0m" "\033[31m""does not exist""\e[0m"
                    echo -e "Make sure rutorrent is installed and you have then updated to nginx"
                    echo
                    sleep 2
                fi
                ;;
    ##########
            "18") # Multi Rtorrent/RuTorrent: Add or edit a user in the existing Rutorrent .htpasswd
                echo -e "Where you have" "\033[32m""rutorrent-4""\e[0m" "then" "\033[31m""4""\e[0m" "is the suffix."
                read -ep "Please state the suffix of the instance you wish to modify: " suffix
                echo
                if [[ -f $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd ]]
                then
                    echo -e "\033[1;32m""Note: Use a good password manager like keepass so you can easily manage good passwords.""\e[0m"
                    echo -e "\033[32m""Here is a list of the usernames and their order in your" "\033[36m""/rutorrent-$suffix/.htpasswd""\e[0m"
                    echo -e "\033[1;31m"
                    cat $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd | cut -d: -f1
                    echo -e "\e[0m"
                    echo -e "\033[33m""Enter an existing username to update or a new one to create an entry.""\e[0m"
                    read -ep "What is the username you wish to create, if they are not listed above, or edit if they exist?: " username
                    htpasswd -m $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd $username
                    echo
                    read -ep "Do you want to use this user's password for the rpc: [y]es or [n]o ?" rpcchoice
                    if [[ $rpcchoice =~ ^[Yy]$ ]]
                    then
                        if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                        then
                            if [[ -s $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd ]]
                            then
                                cp -f ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd ~/.nginx/conf.d/000-default-server.d/scgi-$suffix-htpasswd
                                sed -ri "s/$username:(.*)/rutorrent:\1/g" ~/.nginx/conf.d/000-default-server.d/scgi-$suffix-htpasswd
                                sed -ri '/^rutorrent:(.*)/! s/(.*)//g' ~/.nginx/conf.d/000-default-server.d/scgi-$suffix-htpasswd
                                sed -ri '/^$/d' ~/.nginx/conf.d/000-default-server.d/scgi-$suffix-htpasswd
                                echo -e "This user's password has been used for the" "\033[36m""/rutorrent-$suffix/rpc""\e[0m"
                                echo
                                sleep 2
                            else
                                echo "The rutorrent-$suffix htpasswd is empty. Re run option 18 to create a user first."
                                echo
                                sleep 2
                            fi
                        else
                            echo "nginx is not installed. You will have to update to nginx first."
                        fi
                    fi
                    sleep 2
                else
                    echo -e "\033[31m" "The file does not exist at rutorrent-$suffix." "\033[32m""Check the suffix was correct""\e[0m"
                    sleep 2
                fi
                ;;
    ##########
            "19") # Multi Rtorrent/RuTorrent: Delete a user in the existing Rutorrent .htpasswd
                echo -e "Where you have" "\033[32m""rutorrent-4""\e[0m" "then" "\033[31m""4""\e[0m" "is the suffix."
                read -ep "Please state the suffix of the instance you wish to modify: " suffix
                echo
                if [[ -f $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd ]]
                then
                    echo -e "\033[32m""Here is a list of the usernames and their order in your" "\033[36m""/rutorrent-$suffix/.htpasswd""\e[0m"
                    echo -e "\033[1;31m"
                    cat $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd | cut -d: -f1
                    echo -e "\e[0m"
                    echo -e "\033[33m""Enter username from the list to delete them.""\e[0m"
                    read -ep "What is the username you wish to remove?: " username
                    htpasswd -D $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd $username
                    sleep 2
                else
                    echo -e "\033[31m" "The file does not exist at rutorrent-$suffix." "\033[32m""Is RuTorrent installed?""\e[0m"
                    sleep 2
                fi
                ;;
    ##########
            "20") # Multi Rtorrent/RuTorrent: List .htpasswd users and their order
                echo -e "Where you have" "\033[32m""rutorrent-4""\e[0m" "then" "\033[31m""4""\e[0m" "is the suffix."
                read -ep "Please state the suffix of the instance you wish to modify: " suffix
                echo
                if [[ -f $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd ]]
                then
                    echo -e "\033[32m""Here is a list of the usernames and their order in your" "\033[36m""/rtorrent-$suffix/.htpasswd""\e[0m"
                    echo -e "\033[1;31m"
                    cat $HOME/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix/.htpasswd | cut -d: -f1
                    echo -e "\e[0m"
                    sleep 4
                else
                    echo -e "\033[31m" "The file does not exist at rutorrent-$suffix." "\033[32m""Is RuTorrent installed?""\e[0m"
                    sleep 2
                fi
                ;;
    ##########
            "21") # change the rpc password for the user rutorrent-suffix of choice
                read -ep "Please state the suffix of the instance you wish to modify: " suffix
                echo
                if [[ -f ~/.nginx/conf.d/000-default-server.d/scgi-$suffix-htpasswd ]]
                then
                    htpasswd -m $HOME/.nginx/conf.d/000-default-server.d/scgi-$suffix-htpasswd rutorrent
                    sed -ri '/^rutorrent:(.*)/! s/(.*)//g' ~/.nginx/conf.d/000-default-server.d/scgi-$suffix-htpasswd
                    sed -ri '/^$/d' ~/.nginx/conf.d/000-default-server.d/scgi-$suffix-htpasswd
                    echo
                    sleep 2
                else
                    echo -e "\033[31m""required file " "\033[36m""~/.nginx/conf.d/000-default-server.d/scgi-htpasswd-$suffix""\e[0m" "\033[31m""does not exist""\e[0m"
                    echo -e "Does this custom instance exist? Was it installed after you had updated to nginx (a requirement)?"
                    echo
                    sleep 2
                fi
                ;;
    ##########
            "22") # Quit
                exit
                ;;
    ##########
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
