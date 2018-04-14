#!/bin/bash
# Author: Aniverse
# https://github.com/Aniverse/iFeral
#
#
iFeralVer=0.4.3
iFeralDate=2018.04.14.6
# 颜色 -----------------------------------------------------------------------------------
black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3);
blue=$(tput setaf 4); magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7);
on_red=$(tput setab 1); on_green=$(tput setab 2); on_yellow=$(tput setab 3); on_blue=$(tput setab 4);
on_magenta=$(tput setab 5); on_cyan=$(tput setab 6); on_white=$(tput setab 7); bold=$(tput bold);
dim=$(tput dim); underline=$(tput smul); reset_underline=$(tput rmul); standout=$(tput smso);
reset_standout=$(tput rmso); normal=$(tput sgr0); alert=${white}${on_red}; title=${standout};
baihuangse=${white}${on_yellow}; bailanse=${white}${on_blue}; bailvse=${white}${on_green};
baiqingse=${white}${on_cyan}; baihongse=${white}${on_red}; baizise=${white}${on_magenta};
heibaise=${black}${on_white}; jiacu=${normal}${bold}
shanshuo=$(tput blink); wuguangbiao=$(tput civis); guangbiao=$(tput cnorm)
error="${baihongse}${bold} 错误 ${jiacu}" ; warn="${baihongse}${bold} 警告 ${jiacu}" ; atte="${baihongse}${bold} 注意 ${jiacu}"
# 调试 -----------------------------------------------------------------------------------
DeBUG=0 ; [[ $1 == -d ]] && DeBUG=1
# 系统检测 -----------------------------------------------------------------------------------
get_opsy() {
[[ -f /etc/redhat-release ]] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release      && return
[[ -f /etc/os-release     ]] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
[[ -f /etc/lsb-release    ]] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release      && return ; }

  if [[ -f /etc/redhat-release ]]; then faxingban="centos"
elif cat /etc/issue | grep -Eqi "debian"; then faxingban="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then faxingban="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then faxingban="centos"
elif cat /proc/version | grep -Eqi "debian"; then faxingban="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then faxingban="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then faxingban="centos" ; fi

DISTRO=`  awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release  `
DISTROL=`  echo $DISTRO | tr 'A-Z' 'a-z'  `
CODENAME=`  cat /etc/os-release | grep VERSION= | tr '[A-Z]' '[a-z]' | sed 's/\"\|(\|)\|[0-9.,]\|version\|lts//g' | awk '{print $2}'  `
[[ $DISTRO == Ubuntu ]] && osversion=`  grep -oE  "[0-9.]+" /etc/issue  `
[[ $DISTRO == Debian ]] && osversion=`  cat /etc/debian_version  `

# 参数检测 -----------------------------------------------------------------------------------

### 计算硬盘大小 ###
function calc_disk() {
local total_size=0 ; local array=$@
for size in ${array[@]} ; do
    [ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
    [ "`echo ${size:(-1)}`" == "K" ] && size=0
    [ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
    [ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
    [ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
    total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
done ; echo ${total_size} ; }

### 是否为 IP 地址 ###
function isValidIpAddress() { echo $1 | grep -qE '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$' ; }

### 是否为内网 IP 地址 ###
function isInternalIpAddress() { echo $1 | grep -qE '(192\.168\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(172\.((1[6-9])|(2\d)|(3[0-1]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(10\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))' ; }

### 端口生成与检查 ###
portGenerator() { portGen=$(shuf -i 10001-32001 -n1) ; } ; portGenerator2() { portGen2=$(shuf -i 10001-32001 -n1) ; }
portCheck() { while [[ "$( ~/iFeral/app/netstat -ln | grep ':'"$portGen"'' | grep -c 'LISTEN')" -eq "1" ]]; do portGenerator ; done ; }
portCheck2() { while [[ "$( ~/iFeral/app/netstat -ln | grep ':'"$portGen2"'' | grep -c 'LISTEN')" -eq "1" ]]; do portGenerator2 ; done ; }

current_disk=`  echo $(pwd) | sed "s/\/$(whoami)//"  `
Seedbox=Unknown ; [[ `  hostname -f | grep feral  ` ]] && Seedbox=FH ; [[ `  hostname -f | grep seedhost  ` ]] && Seedbox=SH

# -----------------------------------------------------------------------------------





# 00. Logo
function _logo() {
cd ; clear ; wget --timeout=7 -qO- https://github.com/Aniverse/iFeral/raw/master/files/iFeral.logo.1
echo -e "${bold}Ver. $iFeralDate    \n"
[[ $Seedbox == Unknown ]] && echo -e "${warn} 你这个似乎不是 FH 或 SH 的盒子，不保证本脚本能正常工作！\n"
[[ $Seedbox == SH ]] && echo -e "${atte} 本脚本主要为 FH 盒子设计，不保证所有功能都能在 SH 盒子上正常工作！\n" ; }






# 00. 初始化
function _init() {  if [[ ! `  ls ~ | grep iFeral  `  ]]; then
git clone --depth=1 https://github.com/Aniverse/iFeral ; chmod -R +x ~/iFeral/app
cd ; clear ; wget --timeout=7 -qO- https://github.com/Aniverse/iFeral/raw/master/files/iFeral.logo.1
echo -e "${bold}Ver. $iFeralDate    \n"
mkdir -p ~/bin ~/lib ~/iFeral/backup ~/iFeral/log ~/.config ~/iSeed
fi
USERPATH=` pwd `
USERPATHSED=$( echo ${USERPATH} | sed -e 's/\//\\\//g' ) ; }







# 00. 导航菜单
function _main_menu() {

echo -e "${bold}${green}(01) ${jiacu}安装 qBittorrent     "
echo -e "${green}(02) ${jiacu}安装 Deluge          "
#echo -e "${green}(03) ${jiacu}安装 Transmission   "
echo -e "${green}(04) ${jiacu}降级 rTorrent        "
echo -e "${green}(05) ${jiacu}配置 ruTorrent       "
echo -e "${green}(06) ${jiacu}安装 flexget         "
echo -e "${green}(07) ${jiacu}安装 ffmpeg          "
echo -e "${green}(08) ${jiacu}查看 系统信息        "
echo -e "${green}(09) ${jiacu}查看 邻居            "
echo -e "${green}(10) ${jiacu}设置 .profile        "
echo -e "${green}(11) ${jiacu}使用 zsh             "
echo -e "${green}(99) ${jiacu}退出脚本             "
echo -e "${normal}"

echo -ne "${yellow}${bold}你想做些什么？ (默认选择退出) ${normal}" ; read -e response

case $response in
    1 | 01) # 安装 qBittorrent
            _install_qb ;;
    2 | 02) # 安装 Deluge
            _install_de ;;
    3 | 03) # 安装 Transmission
            _install_tr ;;
    4 | 04) # 降级 rTorrent
            _rt_downgrade ;;
    5 | 05) # 配置 ruTorrent
            _config_rut ;;
    6 | 06) # 安装 flexget
            _install_flexget ;;
    7 | 07) # 安装 一些工具
            _install_tools ;;
    8 | 08) # 查看 系统信息
            _stats ; _main_menu ;;
    9 | 09) # 查看 所有邻居
            clear
            echo -e "${bold}${cayn}以下是当前和你在同一个硬盘分区上的邻居${normal}\n"
            getent passwd | grep -v $(whoami) | grep $current_disk/ | awk -F ":" '{print $1}' | pr -3 -t ; echo
            echo -e "${bold}${cayn}以下是整个盒子上所有的邻居${normal}\n"
            getent passwd | grep -v $(whoami) | grep -E 'home[0-9]+|media' | awk -F ':' '{print $1}' | sort -u | pr -3 -t ; echo
            _main_menu ;;
        10) _set_profile ; _main_menu ;;
    99| "") clear ; exit 0 ;;
    *     ) clear ; exit 0 ;;
esac

echo ; }





# 01. 安装 qBittorrent

function _install_qb() {

echo ; mkdir -p ~/tmp ~/private/qbittorrent/{data,watch,torrents} ~/.config/{qBittorrent,flexget}

# 关掉可能在运行的 qb
for qbpid in ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep qbittorrent | awk '{print $2}' ` ; do kill -9 $qbpid ; done

# 下载
if [[ ! `  ls ~/iFeral/qb/library  2>/dev/null  `  ]]; then
    echo -e "${bold}${yellow}下载 qbittorrent-nox ...${normal}\n"
    if   [[ $Seedbox == FH ]]; then
         git clone --depth=1 -b master --single-branch https://github.com/Aniverse/qBittorrent-nox ~/iFeral/qb
    elif [[ $Seedbox == SH ]]; then
         git clone --depth=1 -b trusty --single-branch https://github.com/Aniverse/qBittorrent-nox ~/iFeral/qb
    else
         echo -e "${bold}${yellow}暂时不支持 FH/SH 以外的盒子 ...${normal}\n" ; exit 1
    fi
    chmod +x -R ~/iFeral/qb ; echo
fi

# 询问版本
[[ $Seedbox == FH ]] && QB_supported_versions="3.3.0-3.3.16，4.0.0-4.0.4"
[[ $Seedbox == SH ]] && QB_supported_versions="3.3.0-3.3.16"
while [[ $QBVERSION = "" ]]; do
    echo -ne "${bold}${yellow}请输入你要安装的 qBittorrent 版本，只支持 $QB_supported_versions: ${normal}" ; read -e QBVERSION
    [[ ! ` ls ~/iFeral/qb | grep $QBVERSION ` ]] && { echo -e "${error} 你输入的版本不可用，请重新输入！" ; unset QBVERSION ; }
done

# 询问是否覆盖原配置信息
if [[ -e ~/.config/qBittorrent/qBittorrent.conf ]]; then
    echo -e "${atte} 你以前装过 qBittorrent，那时的配置文件还留着，包含着 qBittorrent 的账号、密码、端口、下载路径等信息"
    echo -ne "你现在要使用以前留下的配置文件吗？${normal} [${cyan}Y${normal}]es or [N]o: " ; read -e responce
    case $responce in
        [yY] | [yY][Ee][Ss] | "" ) qbconfig=old ;;
        [nN] | [nN][Oo]          ) qbconfig=new ;;
        *                        ) qbconfig=old ;;
    esac
else
    qbconfig=new
fi

# 新建配置文件
if [[ $qbconfig == new ]]; then
    read -ep "${bold}${yellow}请输入你要用于 qBittorrent WebUI 的密码：${normal}" PASSWORD
    QBPASS=`  echo -n $PASSWORD | md5sum | awk '{print $1}'  `
    [[ -e ~/.config/qBittorrent/qBittorrent.conf ]] && { rm -rf ~/.config/qBittorrent/qBittorrent.conf.backup ; mv -f ~/.config/qBittorrent/qBittorrent.conf ~/.config/qBittorrent/qBittorrent.conf.backup ; }
    portGenerator && portCheck
    portGenerator2 && portCheck2
    cat > ~/.config/qBittorrent/qBittorrent.conf <<EOF
[Application]
FileLogger\Enabled=true
FileLogger\Age=6
FileLogger\DeleteOld=true
FileLogger\Backup=true
FileLogger\AgeType=1
FileLogger\Path=~/iFeral/log
FileLogger\MaxSize=20

[LegalNotice]
Accepted=true

[Preferences]
Bittorrent\AddTrackers=false
Bittorrent\DHT=false
Bittorrent\Encryption=1
Bittorrent\LSD=false
Bittorrent\MaxConnecs=-1
Bittorrent\MaxConnecsPerTorrent=-1
Bittorrent\MaxRatioAction=0
Bittorrent\PeX=false
Bittorrent\uTP=false
Bittorrent\uTP_rate_limited=false
Connection\GlobalDLLimitAlt=0
Connection\GlobalUPLimitAlt=0
Connection\PortRangeMin=$portGen2
General\Locale=zh
Queueing\QueueingEnabled=false
Downloads\SavePath=${USERPATH}/private/qBittorrent/data

WebUI\Port=$portGen
WebUI\Password_ha1=@ByteArray($QBPASS)
WebUI\Username=$(whoami)
EOF
fi

# 检查端口与用户名
QBPORT=` grep "WebUI.Port" ~/.config/qBittorrent/qBittorrent.conf | grep -Po "\d+" `
QBUSERNAME=` grep "WebUI.Username" ~/.config/qBittorrent/qBittorrent.conf | awk -F "=" '{print $NF}' `

# 运行 qBittorrent-nox
TMPDIR=~/tmp LD_LIBRARY_PATH=~/iFeral/qb/library ~/iFeral/qb/qbittorrent-nox.$QBVERSION -d

# 输出结果
if [[ ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep qbittorrent ` ]]; then
    echo -e "\n${bold}${green}qBittorrent 已安装完成！${jiacu}\n"
    echo -e "网址  ${cyan}http://$(hostname -f):$QBPORT${jiacu}"
    echo -e "账号  ${cyan}$QBUSERNAME${jiacu}"
    [[ $qbconfig == new ]] &&
    echo -e "密码  ${cyan}$PASSWORD${normal}"
    [[ $qbconfig == old ]] &&
    echo -e "密码  ${cyan}(和以前一样)${normal}"
else
    echo -e "${error} qBittorrent 安装完成，但无法正常运行。\n不要问我为什么和怎么办，你自己看着办吧！${normal}"
fi ; }





# 02. 安装 第二个 Deluge
# https://www.feralhosting.com/wiki/software/deluge

function _install_de() {

echo ; cd

# 关掉可能在运行的第二个 deluged
for depid in ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep de2 | awk '{print $2}' ` ; do kill -9 $depid ; done

while [[ $DEVERSION = "" ]]; do
    echo -ne "${bold}${yellow}请输入你要安装的第二个 Deluge 的版本 : ${normal}" ; read -e DEVERSION
    wget -qO ~/deluge-"${DEVERSION}".tar.gz http://download.deluge-torrent.org/source/deluge-"${DEVERSION}".tar.gz || { echo -e "${error} 下载 Deluge 源码失败，可能是这个版本不可用！" ; unset DEVERSION ; }
done

# 安装
tar zxf ~/deluge-"${DEVERSION}".tar.gz && cd ~/deluge-"${DEVERSION}"
sed -i "s/SSL.SSLv3_METHOD/SSL.SSLv23_METHOD/g" deluge/core/rpcserver.py
sed -i "/        ctx = SSL.Context(SSL.SSLv23_METHOD)/a\        ctx.set_options(SSL.OP_NO_SSLv2 & SSL.OP_NO_SSLv3)" deluge/core/rpcserver.py
python setup.py install --user >/dev/null 2>&1
cd && rm -rf ~/deluge-"${DEVERSION}" ~/deluge-"${DEVERSION}".tar.gz

mv -f ~/.local/bin/deluged ~/bin/de2 >/dev/null 2>&1
mv -f ~/.local/bin/deluge-web ~/bin/dew2 >/dev/null 2>&1
chmod 700 ~/bin/{de2,dew2}
[[ ! -e ~/bin/dew2 ]] && { echo -e "${error} 第二个 Deluged 安装失败！\n不要问我为什么和怎么办，你自己看着办吧！${normal}" ; exit 1 ; }

# 询问是否覆盖原配置信息
if [[ -e ~/.config/deluge2/core.conf ]]; then
    echo -e "${atte} 你以前装过第二个 Deluge，那时的配置文件还留着，包含着 Deluge 的账号、密码、端口、下载路径等信息"
    echo -ne "你现在要使用以前留下的配置文件吗？${normal} [${cyan}Y${normal}]es or [N]o: " ; read -e responce
    case $responce in
        [yY] | [yY][Ee][Ss] | "" ) deconfig=old ;;
        [nN] | [nN][Oo]          ) deconfig=new ;;
        *                        ) deconfig=old ;;
    esac
else
    deconfig=new
fi

# 新建配置文件
if [[ $deconfig == new ]]; then
    read -ep "${bold}${yellow}请输入你要用于 Deluge DAEMON 的密码：${normal}" DEPASS
    DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n1)
    DWP=$(python "$USERPATH/iFeral/app/deluge.userpass.py" ${DEPASS} ${DWSALT})
    [[ -d ~/.config/deluge2 ]] && { rm -rf ~/.config/deluge2.backup ; mv -f ~/.config/deluge2 ~/.config/deluge2.backup ; }
    cp -rf ~/iFeral/template/deluge2 ~/.config
    portGenerator && portCheck

    sed -i 's|"daemon_port":.*,|"daemon_port": '$portGen',|g' ~/.config/deluge2/core.conf

  # 直接 sed 路径无法替换，需要用这种方式来实现，比较蛋疼
    cat ~/.config/deluge2/core.conf | sed -e "s/USERPATH/${USERPATHSED}/g" > ~/.config/deluge2/core2.conf
    cat ~/.config/deluge2/core2.conf
    mv ~/.config/deluge2/core2.conf ~/.config/deluge2/core.conf
  # sed -i "s/DWSALT/${DWSALT}/g" ~/.config/deluge2/web.conf
  # sed -i "s/DWP/${DWP}/g" ~/.config/deluge2/web.conf
  # portGenerator2 && portCheck2 && sed -i 's|"port":.*,|"port": '$portGen2',|g' ~/.config/deluge2/web.conf
    echo "$(whoami):${DEPASS}:10" > ~/.config/deluge2/auth
fi

# 运行
~/bin/de2 -c ~/.config/deluge2 >/dev/null 2>&1

# 检查 用户名、密码、端口
DE2PORT=` grep daemon_port ~/.config/deluge2/core.conf | grep -oP "\d+" `
DE2AUTHNAME=` grep -v localclient ~/.config/deluge2/auth | head -n1 | awk -F ":" '{print $1}' `
DE2AUTHPASS=` grep -v localclient ~/.config/deluge2/auth | head -n1 | awk -F ":" '{print $2}' `

if [[ ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep de2 ` ]]; then
    echo -e "\n${bold}${green}第二个 Deluge 已安装完成！${jiacu}\n"
    echo -e "WebUI  网址  ${cyan}http://$(hostname -f)/$(whoami)/deluge${jiacu}"
    echo -e "WebUI  密码  ${cyan}和第一个 Deluge WebUI 的密码一样${jiacu}"
    echo -e "WebUI  主机  ${cyan}127.0.0.1 或 10.0.0.1${jiacu}"
    echo -e "GtkUI  主机  ${cyan}$(hostname -f)${jiacu}"
    echo -e "daemon 账号  ${cyan}$DE2AUTHNAME${jiacu}"
    echo -e "daemon 密码  ${cyan}$DE2AUTHPASS${jiacu}"
    echo -e "daemon 端口  ${cyan}$DE2PORT${normal}"
else
    echo -e "${error} 第二个 Deluge 安装完成，但无法正常运行。\n不要问我为什么和怎么办，你自己看着办吧！${normal}"
fi ; }






# 04. 降级 rTorrent
# https://www.seedhost.eu/whmcs/knowledgebase/249/Changing-rTorrent-version.html
# https://www.feralhosting.com/wiki/software/rutorrent/version
# FH 只提供 0.9.4 和 0.9.6

function _rt_downgrade() {

echo
echo -e "${green}01)${normal} rTorrent ${cyan}0.9.4${normal}"
echo -e "${green}02)${normal} rTorrent ${cyan}0.9.6${normal}"
echo -ne "${bold}${yellow}你想用哪个版本 的 rTorrent？${normal}：" ; read -e version

case $version in
    01 | 1) SHRTVERSION=0.9.4 && FHRTVERSION=0.9.4_w0.13.4 ;;
    02 | 2) SHRTVERSION=0.9.6 && FHRTVERSION=0.9.6_w0.13.6 ;;
    03 | 3) SHRTVERSION=0.9.2 && FHRTVERSION=0.9.2_w0.13.2 ;;
    04 | 4) SHRTVERSION=0.9.3 && FHRTVERSION=0.9.3_w0.13.3 ;;
    "" | *) SHRTVERSION=0.9.4 && FHRTVERSION=0.9.4_w0.13.4 ;;
esac

if [[ $Seedbox == FH ]]; then
    mkdir -p ~/private/rtorrent
    echo -n "$FHRTVERSION" > ~/private/rtorrent/.version
    echo -e "\n版本改变完成，需要重启 rTorrent 以生效\n"
elif [[ $Seedbox == SH ]]; then
    mkdir -p ~/private/rtorrent
    if [[ $SHRTVERSION == 0.9.6 ]];then rm -f ~/.config/.rtversion ; else echo "$SHRTVERSION" > ~/.config/.rtversion ; fi
    echo -e "\n版本改变完成，需要重启 rTorrent 以生效\n"
else
    echo "${warn} 不支持非 SH/FH 盒子！${normal}"
fi ; }






# 05. 配置 ruTorrent

function _config_rut() { echo

if [[ $Seedbox == FH ]]; then

# ruTorrent Upgrade
cd ~/www/$(whoami).$(hostname -f)/*
git clone --depth=1 https://github.com/Novik/ruTorrent ruTorrent
cp -r rutorrent/conf/* ruTorrent/conf/
cp rutorrent/.ht* ruTorrent/
rm -rf rutorrent/ && mv ruTorrent rutorrent && cd

# sox
wget http://ftp.debian.org/debian/pool/main/s/sox/libsox3_14.4.2-3_amd64.deb && dpkg -x libsox3_14.4.2-3_amd64.deb ~/deb-temp
wget http://ftp.debian.org/debian/pool/main/s/sox/sox_14.4.2-3_amd64.deb && dpkg -x sox_14.4.2-3_amd64.deb ~/deb-temp
mv ~/deb-temp/usr/lib/x86_64-linux-gnu/* ~/lib/
mv ~/deb-temp/usr/bin/* ~/bin/
rm -rf ~/*.deb ~/deb-temp
cd && sed -i "s|sox'] = ''|sox'] = '$(pwd)/bin/sox'|g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/spectrogram/conf.php

# Screenshots ffmpeg and m2ts
cd && sed -i "s|ffmpeg'] = ''|ffmpeg'] = '$(pwd)/bin/ffmpeg'|g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/screenshots/conf.php
sed -i "s/\"mkv\"/\"mkv\",\"m2ts\"/g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/screenshots/conf.php

# Filemanager
cd ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/filemanager
chmod 700 ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/scripts/*
cd && sed -i "s|(getExternal(\"ffprobe\")|(getExternal(\"~/bin/ffprobe\")|g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/flm.class.php
sed -i "s|(getExternal('ffmpeg')|(getExternal('$(pwd)/bin/ffmpeg')|g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/flm.class.php

# ruTorrent Themes
cd ~/www/$(whoami).$(hostname -f)/*/rutorrent
mkdir -p theme/themes
cd theme/themes
svn co -q https://github.com/ArtyumX/ruTorrent-Themes/trunk/MaterialDesign
svn co -q https://github.com/ArtyumX/ruTorrent-Themes/trunk/club-QuickBox
cd

# AutoDL-Irssi
bash -c "$(wget -qO- http://git.io/oTUCMg)"

else echo "${atte} 这是为了 FH 盒子设计的，其他盒子就不要用了~${normal}" ; fi ; }






# 06. 安装 flexget
# https://www.feralhosting.com/wiki/software/pip
# https://www.feralhosting.com/wiki/software/flexget
# https://www.seedhost.eu/whmcs/knowledgebase/248/Flexget-installation.html

function _install_flexget() {

if [[ $Seedbox == FH ]]; then
    pip install --user --ignore-installed --no-use-wheel virtualenv
    ~/.local/bin/virtualenv ~/pip --system-site-packages
    ~/pip/bin/pip install flexget
elif [[ $Seedbox == SH ]]; then
    pip install --user flexget
else
    echo "${warn} 不支持非 SH/FH 盒子！${normal}" ; exit 1
fi

portGenerator && portCheck
deluge_port=` grep daemon_port ~/.config/deluge/core.conf | grep -Eo "[0-9]+" `

mkdir -p ~/.config/flexget
cp -f ~/.config/flexget/config.yml ~/.config/flexget/config.yml."$(date "+%Y.%m.%d.%H.%M.%S")".bak >/dev/null 2>&1

cat >  ~/.config/flexget/config.yml <<EOF
tasks:
  MTeam:
    rss: https://mantou
    verify_ssl_certificates: no
    regexp:
      accept:
        - OneHD
      reject:
        - MTeamPAD
    deluge:
      maxupspeed: 12800.0
      port: $deluge_port
web_server:
  port: $portGen
  web_ui: yes
schedules: no
EOF

}










# 07. 安装一些软件

function _install_tools() {

# ffmpeg
mkdir -p ~/bin
wget -qO ~/ffmpeg.tar.gz https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz
tar xf ~/ffmpeg.tar.gz && cd && rm -rf ffmpeg-*-64bit-static/{manpages,presets,readme.txt}
cp ~/ffmpeg-*-64bit-static/* ~/bin
chmod 700 ~/bin/{ffmpeg,ffprobe,ffmpeg-10bit,qt-faststart}
cd && rm -rf ffmpeg{.tar.gz,-*-64bit-static}

# p7zip
wget -qO ~/p7zip.tar.bz2 http://sourceforge.net/projects/p7zip/files/p7zip/9.38.1/p7zip_9.38.1_src_all.tar.bz2
tar xf ~/p7zip.tar.bz2 && cd ~/p7zip_9.38.1
make -j$(nproc) && make install DEST_HOME=$HOME
cd && rm -f ~/p7zip.tar.bz2

# rclone
# mkdir -p ~/bin
# wget -qO ~/rclone.zip http://downloads.rclone.org/rclone-current-linux-amd64.zip
# unzip -qq ~/rclone.zip
# mv ~/rclone-v*-linux-amd64/rclone ~/bin
# rm -rf ~/rclone-v*-linux-amd64 ~/rclone.zip
# chmod +x ~/bin/rclone

# mktorrent
# git clone --depth=1 https://github.com/Rudde/mktorrent
# cd mktorrent/ && PREFIX=$HOME make -j$(nproc)
# PREFIX=$HOME make install
# cd .. && rm -rf mktorrent

}






# 08. 查看盒子信息
function _stats() { 

echo -e "\n${bold}正在检查系统信息，请稍等 ... ${normal}\n"

serverfqdn=`  hostname -f  `
serveripv4=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}' )
isInternalIpAddress "$serveripv4" || serveripv4=$( wget -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php )
isValidIpAddress "$serveripv4" || serveripv4=$( wget -t1 -T6 -qO- checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' )
isValidIpAddress "$serveripv4" || serveripv4=$( wget -t1 -T7 -qO- ipecho.net/plain )
isValidIpAddress "$serveripv4" || { echo "${bold}${red}${shanshuo}ERROR ${jiacu}${underline}检查公网 IPv4 地址失败，使用内网地址代替 ...${normal}" ; serveripv4=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') ; }
serveripv6=$( wget -t1 -T5 -qO- v6.ipv6-test.com/api/myip.php | grep -Eo "[0-9a-z:]+" | head -n1 )

uptime1=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days %d hour %d min\n",a,b,c)}' /proc/uptime )
uptime2=`uptime | grep -ohe 'up .*' | sed 's/,/\ hours/g' | awk '{ printf $2" "$3 }'`
load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
running_kernel=` uname -r `

cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
cpucores_single=$( grep 'core id' /proc/cpuinfo | sort -u | wc -l )
#physical_cpu_number=$( grep 'physical id' /proc/cpuinfo | cut -c15-17 )
cpu_percent=$( top -b -n 1|grep Cpu|awk '{print $2}'|cut -f 1 -d "." )
cpunumbers=$( grep 'physical id' /proc/cpuinfo | sort -u | wc -l )
cpucores=$( expr $cpucores_single \* $cpunumbers )
cputhreads=$( grep 'processor' /proc/cpuinfo | sort -u | wc -l )
[[ $cpunumbers == 2 ]] && CPUNum='双路 ' ; [[ $cpunumbers == 4 ]] && CPUNum='四路 ' ; [[ $cpunumbers == 8 ]] && CPUNum='八路 '

freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
#swap=$( free -m | awk '/Swap/ {print $2}' )
#uswap=$( free -m | awk '/Swap/ {print $3}' )
memory_usage=`free -m |grep -i mem | awk '{printf ("%.2f\n",$3/$2*100)}'`%
users=`users | wc -w`
processes=`ps aux | wc -l`
date=$( date +%Y-%m-%d" "%H:%M:%S )
arch=$( uname -m )

neighbors_same_disk_num=`  getent passwd | grep -v $(whoami) | grep $current_disk/ | wc -l  `
neighbors_same_disk_name=`  getent passwd | grep -v $(whoami) | grep $current_disk/ | awk -F ":" '{print $1}'  `
neighbors_all_num=`  getent passwd | grep -v $(whoami) | grep -E "home[0-9]+|media" | wc -l  `
disk_num=`  df -lh | grep -E "/home[0-9]+|media" | wc -l  `

disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
disk_total_size=$( calc_disk ${disk_size1[@]} )
disk_used_size=$( calc_disk ${disk_size2[@]} )

current_disk_size=($( LANG=C df -hPl | grep $current_disk | awk '{print $2}' ))
current_disk_total_used=($( LANG=C df -hPl | grep $current_disk | awk '{print $3}' ))
#current_disk_avai=($( LANG=C df -hPl | grep $current_disk | awk '{print $4}' ))
#current_disk_perc=($( LANG=C df -hPl | grep $current_disk | awk '{print $5}' ))
current_disk_self_used=` du -sh ~ | awk -F " " '{print $1}' `

tcp_control=` cat /proc/sys/net/ipv4/tcp_congestion_control `
[[ $tcp_control == bbr ]] && tcp_control="BBR (原版)"

clear ; echo

echo " ${bailanse}${bold}                                           08. 系统信息                                            ${normal}"
echo " ${bold}"

echo -e  "${bold}  完全限定域名  : ${cyan}$serverfqdn${normal}"
echo -e  "${bold}  IPv4 地址     : ${cyan}$serveripv4${normal}"
echo -ne "${bold}  IPv6 地址     : ${cyan}"

if [[ $serveripv6 ]]; then
echo -e "$serveripv6${normal}"
else
echo -e "IPv6 尚未启用${normal}"
fi

echo
echo -e  "${bold}  CPU 型号      : ${cyan}$CPUNum$cname${normal}"
echo -e  "${bold}  CPU 核心      : ${cyan}合计 ${cpucores} 核心，${cputhreads} 线程${normal}"
echo -e  "${bold}  CPU 状态      : ${cyan}当前主频 ${freq} MHz，占用率 ${cpu_percent}%${normal}"
echo -e  "${bold}  内存大小      : ${cyan}$tram MB ($uram MB 已用)${normal}"
echo -e  "${bold}  运行时间      : ${cyan}$uptime1${normal}"
echo -e  "${bold}  系统负载      : ${cyan}$load${normal}"
echo
echo -e  "${bold}  总硬盘大小    : ${cyan}共 $disk_num 个硬盘分区，合计 $disk_total_size GB ($disk_used_size GB 已用)${normal}"
echo -e  "${bold}  当前硬盘大小  : ${cyan}${current_disk_size}B (共 ${current_disk_total_used}B 已用，其中你用了 ${current_disk_self_used}B)${normal}"
echo -e  "${bold}  邻居数量      : ${cyan}整台机器共 $neighbors_all_num 位邻居，其中同硬盘邻居 $neighbors_same_disk_num 位${normal}"
echo
echo -e  "${bold}  操作系统      : ${cyan}$DISTRO $osversion $CODENAME ($arch)${normal}"
echo -e  "${bold}  运行内核      : ${cyan}$running_kernel${normal}"
echo -e  "${bold}  拥塞控制算法  : ${cyan}$tcp_control${normal}"
echo
echo -e  "${bold}  服务器时间    : ${cyan}$date${normal}"
echo ; }










# 10. 设置 bash 环境
function _set_profile() { 

# 备份下，然后直接覆盖掉原先的内容
cp -f ~/.profile ~/iFeral/backup/.profile."$(date "+%Y.%m.%d.%H.%M.%S")".bak >/dev/null 2>&1
cat > ~/.profile <<EOF
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TZ="/usr/share/zoneinfo/Asia/Shanghai"

export PATH=~/FH:~/iFeral/qb:~/iFeral/app:~/bin:~/pip/bin:~/.local/bin:\$PATH

cdk=\$(df -h | grep `pwd | awk -F '/' '{print \$(NF-1)}'` | awk '{print \$1}' | awk -F '/' '{print \$3}')
[[ \$(echo \$cdk | grep -E "sd[a-z]+1") ]] && cdk=\$(echo \$cdk | sed "s/1//")
alias io='iostat -d -x -m 1 | grep -E "\$cdk | rMB/s | wMB/s"'

alias killde='kill "\$(pgrep -fu "\$(whoami)" "deluged")"'
alias killde2='kill "\$(pgrep -fu "\$(whoami)" "de2")"'
alias killtr='kill "\$(pgrep -fu "\$(whoami)" "transmission-daemon")"'
alias killrt='kill "\$(pgrep -fu "\$(whoami)" "/usr/local/bin/rtorrent")"'
alias killqb='kill \$(pgrep -fu "\$(whoami)" "qbitt")'

alias cesu='echo;python ~/iFeral/app/speedtest --share;echo'
alias cesu2='python ~/iFeral/app/speedtest --share --server'
alias cesu3="echo;python ~/iFeral/app/speedtest --list 2>&1 | head -n30 | grep --color=always -P '(\d+)\.(\d+)\skm|(\d+)(?=\))';echo"
alias ls="ls -hAv --color --group-directories-first"
alias ll="ls -hAlvZ --color --group-directories-first"
alias shanchu='rm -rf'
alias zjpid='ps aux | egrep "$(whoami)|COMMAND" | egrep -v "grep|aux|root"'
alias pid="ps aux | grep -v grep | grep"
alias ios="iostat -d -x -m 1"
alias wangsu='sar -n DEV 1| grep -E "rxkB\/s|txkB\/s|eth0|eth1"'
alias scrgd="screen -R gooooogle"
alias scrl="screen -ls"
alias quanxian="chmod -R +x"
alias cdb="cd .."
alias gclone="git clone --depth=1"
EOF
}





# 11. 设置 zsh 环境
function _set_zsh() { if [[ `command -v zsh` ]]; then
cd ; echo -e "\n${atte} 等会儿切换到 zsh 需要输入当前 SSH 的密码${normal}\n"
rm -rf ~/.oh-my-zsh .zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget -qO ~/.oh-my-zsh/themes/agnosterzak.zsh-theme http://raw.github.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme
sed -i "s/robbyrussell/agnosterzak/g" ~/.zshrc

cat >> ~/.zshrc <<EOF
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TZ="/usr/share/zoneinfo/Asia/Shanghai"

export PATH=~/FH:~/iFeral/qb:~/iFeral/app:~/bin:~/pip/bin:~/.local/bin:\$PATH

alias -s sh='bash'
alias -s log='tail -n50'
alias -s gz='tar zxf'
alias -s xz='tar xf'
alias -s tgz='tar zxf'
alias -s rar='unrar x'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

cdk=\$(df -h | grep `pwd | awk -F '/' '{print \$(NF-1)}'` | awk '{print \$1}' | awk -F '/' '{print \$3}')
[[ \$(echo \$cdk | grep -E "sd[a-z]+1") ]] && cdk=\$(echo \$cdk | sed "s/1//")
alias io='iostat -d -x -m 1 | grep -E "\$cdk | rMB/s | wMB/s"'

alias killde='kill "\$(pgrep -fu "\$(whoami)" "deluged")"'
alias killde2='kill "\$(pgrep -fu "\$(whoami)" "de2")"'
alias killtr='kill "\$(pgrep -fu "\$(whoami)" "transmission-daemon")"'
alias killrt='kill "\$(pgrep -fu "\$(whoami)" "/usr/local/bin/rtorrent")"'
alias killqb='kill \$(pgrep -fu "\$(whoami)" "qbitt")'

alias cesu='echo;python ~/iFeral/app/speedtest --share;echo'
alias cesu2='python ~/iFeral/app/speedtest --share --server'
alias cesu3="echo;python ~/iFeral/app/speedtest --list 2>&1 | head -n30 | grep --color=always -P '(\d+)\.(\d+)\skm|(\d+)(?=\))';echo"
alias ls="ls -hAv --color --group-directories-first"
alias ll="ls -hAlvZ --color --group-directories-first"
alias shanchu='rm -rf'
alias zjpid='ps aux | egrep "$(whoami)|COMMAND" | egrep -v "grep|aux|root"'
alias pid="ps aux | grep -v grep | grep"
alias ios="iostat -d -x -m 1"
alias wangsu='sar -n DEV 1| grep -E "rxkB\/s|txkB\/s|eth0|eth1"'
alias scrgd="screen -R gooooogle"
alias scrl="screen -ls"
alias quanxian="chmod -R +x"
alias cdb="cd .."
alias gclone="git clone --depth=1"

# Fix numeric keypad  
# 0 . Enter  
bindkey -s "^[Op" "0"  
bindkey -s "^[On" "."  
bindkey -s "^[OM" "^M"  
# 1 2 3  
bindkey -s "^[Oq" "1"  
bindkey -s "^[Or" "2"  
bindkey -s "^[Os" "3"  
# 4 5 6  
bindkey -s "^[Ot" "4"  
bindkey -s "^[Ou" "5"  
bindkey -s "^[Ov" "6"  
# 7 8 9  
bindkey -s "^[Ow" "7"  
bindkey -s "^[Ox" "8"  
bindkey -s "^[Oy" "9"  
# + - * /  
bindkey -s "^[Ol" "+"  
bindkey -s "^[Om" "-"  
bindkey -s "^[Oj" "*"  
bindkey -s "^[Oo" "/"  
EOF

chsh -s /usr/bin/zsh
source ~/.zshrc

else echo -e "\n${error} 你的盒子没有预装 zsh，故无法使用本功能！${normal}\n" ; fi ; }











_logo
_init
_main_menu

