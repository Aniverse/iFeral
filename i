#!/bin/bash
# Author: Aniverse
# https://github.com/Aniverse/iFeral
# bash -c "$(wget -qO- https://github.com/Aniverse/iFeral/raw/master/i)"
#
iFeralVer=0.7.7
iFeralDate=2019.01.04
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
DISTRO=`  awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release  `
DISTROL=`  echo $DISTRO | tr 'A-Z' 'a-z'  `
CODENAME=`  cat /etc/os-release | grep VERSION= | tr '[A-Z]' '[a-z]' | sed 's/\"\|(\|)\|[0-9.,]\|version\|lts//g' | awk '{print $2}'  `
[[ $DISTRO == Ubuntu ]] && osversion=`  grep Ubuntu /etc/issue | head -1 | grep -oE  "[0-9.]+"  `
[[ $DISTRO == Debian ]] && osversion=`  cat /etc/debian_version  `
# 盒子检测 -----------------------------------------------------------------------------------
Seedbox=Unknown
org=$(wget -t1 -T6 -qO- 'http://ip-api.com/json' | awk -F '"' '{print $28}') 2>1
echo "$org" | grep -q "Dedi Networks LTD" && Seedbox=DSD

serverfqdn=$( hostname -f 2>1 )
[ -z $serverfqdn ] && serverfqdn=$( hostname 2>1 )

echo $serverfqdn | grep -q feral          && Seedbox=FH
echo $serverfqdn | grep -q seedhost       && Seedbox=SH
echo $serverfqdn | grep -q pulsedmedia    && Seedbox=PM
echo $serverfqdn | grep -q ultraseedbox   && Seedbox=USB
echo $serverfqdn | grep -q appbox         && Seedbox=AppBox && Docker=1
echo $serverfqdn | grep -q seedboxes.cc   && Seedbox=Sbcc   && Docker=1

# Seedboxco.net = vnc.USERNAME.appboxes.co
# Seedboxes.cc 需要用 hostname 而不是 hostname -f，格式是 USERNAME-seedbox.cloud.seedboxes.cc
# FH 是 hippolytus.feralhosting.com，用 hostname 的话就只有 hippolytus
# DediSeedbox 用 hostname 检测不到，结果是 610787a74d5c 这样的

[[ $Seedbox == FH ]] && df -hPl | grep -q "/media/md" && FH_SSD=1


grep docker /proc/1/cgroup -qa && SeedboxType=Docker

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
# https://bitbucket.org/feralio/wiki/src/master/src/wiki/software/qbittorrent/qbittorrent.sh?at=master&fileviewer=file-view-default
portGenerator() { portGen=$(shuf -i 10001-32001 -n1) ; } ; portGenerator2() { portGen2=$(shuf -i 10001-32001 -n1) ; }
portCheck() { while [[ "$(ss -ln | grep ':'"$portGen"'' | grep -c 'LISTEN')" -eq "1" ]]; do portGenerator ; done ; }
portCheck2() { while [[ "$(ss -ln | grep ':'"$portGen2"'' | grep -c 'LISTEN')" -eq "1" ]]; do portGenerator2 ; done ; }

[[ $Seedbox == USB    ]] && current_disk=$(echo $(pwd) | sed "s/\/$(whoami)//") # /home11    这样子的
[[ $Seedbox == PM     ]] && current_disk=$(echo $(pwd) | sed "s/\/$(whoami)//") # /home       这样子的
[[ $Seedbox == SH     ]] && current_disk=$(echo $(pwd) | sed "s/\/$(whoami)//") # /home22     这样子的
[[ $Seedbox == FH     ]] && current_disk=$(echo $(pwd) | sed "s/\/$(whoami)//") # /media/sdk1 这样子的，或者 /media/98811
[[ $Seedbox == DSD    ]] && current_disk=$(echo $(pwd) | sed "s/\/$(whoami)//") # /           这样子的
[[ $Seedbox == Sbcc   ]] && current_disk=$(echo $(pwd) | sed "s/\/$(whoami)//") # /home/user  这样子的
[[ $Seedbox == AppBox ]] && [[ ! $(whoami) == root  ]] && current_disk=/home/$(whoami)
[[ $Seedbox == AppBox ]] && [[   $(whoami) == root  ]] && current_disk=/root
[[ $Seedbox == FH     ]] && echo $current_disk | grep -q "/home" && current_disk=$(echo $current_disk | sed "s/\/home//") && FH_HOME=1 # /media/sdr1/home 这样子的，一些老的 FH HDD 会出现这样的

# 所有邻居

if [[ $Seedbox == USB ]]; then
    # ls /etc/seedbox/user
    # ls -l /home* | grep -Ev "root|total" | grep -E "home[0-9]+"
    getent passwd | grep -Ev "$(whoami)|root" | grep -E "/bin/sh|/bin/bash" | grep -E "/home[0-9]+/" > ~/neighbors_all
elif [[ $Seedbox == PM ]]; then
    getent passwd | grep -Ev "$(whoami)|root" | grep -E "/bin/sh|/bin/bash" | grep -E "/home/" > ~/neighbors_all
elif [[ $Seedbox == FH ]]; then
    getent passwd | grep -Ev "$(whoami)|root" | grep -E "/bin/sh|/bin/bash" | grep -E "/media/" > ~/neighbors_all
elif [[ $Seedbox == SH ]]; then
    getent passwd | grep -Ev "$(whoami)|root" | grep -E "/bin/sh|/bin/bash" | grep -E "/home|/home[0-9]+" > ~/neighbors_all
else
    getent passwd | grep -Ev "$(whoami)|root" | grep -E "/bin/sh|/bin/bash" | grep -E "/home/|/home[0-9]+/|/media/" > ~/neighbors_all
fi

# 所有硬盘分区
df -hPl | grep -wvP '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem|udev|docker|md[0-9]+/[a-z].*' | sort -u > ~/par_list

neighbors_all_num=$(cat ~/neighbors_all | wc -l)
neighbors_same_disk_num=$(cat ~/neighbors_all | grep "${current_disk}/" | wc -l)

# 计算总共空间的时候，排除掉 FH SSD 每个用户限额的空间；计算已用空间的时候不排除（因为原先的单个 md 已用空间只有 128k/256k）
disk_size1=($( LANG=C df -hPl | grep -wvP '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem|udev|docker|md[0-9]+/[a-z]*' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvP '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem|udev|docker' | awk '{print $3}' ))
disk_total_size=$( calc_disk ${disk_size1[@]} )
disk_used_size=$( calc_disk ${disk_size2[@]} )

if [[ $FH_SSD == 1 ]];then
    current_disk_size=($( LANG=C df -hPl | grep $(pwd) | awk '{print $2}' ))
    current_disk_total_used=($( LANG=C df -hPl | grep $(pwd) | awk '{print $3}' ))
    current_disk_self_used=$( du -sh ~ | awk -F " " '{print $1}' )
else
    current_disk_size=($( LANG=C df -hPl | grep $current_disk | awk '{print $2}' ))
    current_disk_total_used=($( LANG=C df -hPl | grep $current_disk | awk '{print $3}' ))
    current_disk_self_used=$( du -sh ~ | awk -F " " '{print $1}' )
fi

#current_disk_avai=($( LANG=C df -hPl | grep $current_disk | awk '{print $4}' ))
#current_disk_perc=($( LANG=C df -hPl | grep $current_disk | awk '{print $5}' ))

# -----------------------------------------------------------------------------------





# 00. Logo
function _logo() {
cd ; clear ; wget --timeout=7 -qO- https://github.com/Aniverse/iFeral/raw/master/files/iFeral.logo.1
echo -e "${bold}Ver. $iFeralVer    \n"
#[[ $Seedbox == Unknown ]] && echo -e "${warn} 你这个似乎不是 FH 或 SH 的盒子，不保证本脚本能正常工作！\n"
#[[ $Seedbox == SH ]] && echo -e "${atte} 本脚本主要为 FH 盒子设计，不保证所有功能都能在 SeedHost 盒子上正常工作！\n"
#[[ $Seedbox == USB ]] && echo -e "${atte} 本脚本主要为 FH 盒子设计，不保证所有功能都能在 UltraSeedBox 盒子上正常工作！\n"
#[[ $Seedbox == PM ]] && echo -e "${atte} 本脚本主要为 FH 盒子设计，不保证所有功能都能在 PulsedMedia 盒子上正常工作！\n"
# echo -e "${atte} 1 和 2 以外的选项我都没怎么测试过，不保证一定能用\n"
}






# 00. 初始化
function _init() {  if [[ ! `  ls ~ | grep iFeral  `  ]]; then
git clone --depth=1 https://github.com/Aniverse/iFeral ; chmod -R +x ~/iFeral/app
cd ; clear ; wget --timeout=7 -qO- https://github.com/Aniverse/iFeral/raw/master/files/iFeral.logo.1
echo -e "${bold}Ver. $iFeralVer    \n"
mkdir -p ~/bin ~/lib ~/iFeral/backup ~/iFeral/log ~/.config ~/iSeed/{00.Tools,01.Screenshots,02.Torrents,03.BDinfo,04.BluRay}
mkdir -p ~/.local/usr/{bin,lib,include} ~/.local/{bin,lib,include}
fi
user=$(whoami)
USERPATH=` pwd `
USERPATHSED=$( echo ${USERPATH} | sed -e 's/\//\\\//g' ) ; }







# 00. 导航菜单
function _main_menu() {

echo -e "${bold}目前本脚本正在被作者 xjb 折腾中，不保证好用"
echo -e "${bold}什么，你说 xjb 乱改你不会另外开一个 branch 么……"
echo -e "${bold}作者：懒得管了，反正好像也没什么人用啊……\n"
echo -e "${bold}${green}(01) ${jiacu}安装 qBittorrent (v3)    "
echo -e "${green}(02) ${jiacu}安装 Deluge          "
#echo -e "\n不保证以下功能好用\n"
#echo -e "${green}(03) ${jiacu}安装 Transmission   "
#echo -e "${green}(04) ${jiacu}降级 rTorrent        "
#echo -e "${green}(05) ${jiacu}配置 ruTorrent       "
echo -e "${green}(06) ${jiacu}安装 flexget         "
#echo -e "${green}(07) ${jiacu}安装 ffmpeg 等软件   "
echo -e "${green}(08) ${jiacu}查看 系统信息        "
echo -e "${green}(09) ${jiacu}查看 邻居            "
#echo -e "${green}(10) ${jiacu}设置 .profile        "
#echo -e "${green}(11) ${jiacu}使用 zsh             "
#echo -e "${green}(12) ${jiacu}安装 Aria2 & AriaNG  "
echo -e "${green}(13) ${jiacu}安装 qBittorrent (v1)  "
echo -e "${green}(14) ${jiacu}安装 qBittorrent (v2)  "
echo -e "${green}(99) ${jiacu}退出脚本             "
echo -e "${normal}"

echo -ne "${yellow}${bold}你想做些什么？ (默认选择退出) ${normal}" ; read -e response

case $response in
    1 | 01) # 安装 qBittorrent
            install_qb_v3 ;;
    2 | 02) # 安装 Deluge
            _install_de ;;
    3 | 03) # 
            clear ; exit 0 ;;
    4 | 04) # 降级 rTorrent
            _rt_downgrade ;;
    5 | 05) # 配置 ruTorrent
            _config_rut ;;
    6 | 06) # 安装 flexget
            _install_flexget ;;
    7 | 07) # 安装 一些工具
            _install_tools ;;
    8 | 08) # 查看 系统信息
            _stats ; echo ; _main_menu ;;
    9 | 09) # 查看 所有邻居
            _show_neighbor ; echo ; _main_menu ;;
        12) _install_aria2 ;;
        13) install_qb_v1 ;;
        14) install_qb_v2 ;;
    99| "") clear ; exit 0 ;;
    *     ) clear ; exit 0 ;;
esac

echo ; }








# 询问是否覆盖原配置信息
function install_qb_ask_config() {
if [[ -e ~/.config/qBittorrent/qBittorrent.conf ]]; then
    echo -e "\n${atte} 你以前装过 qBittorrent，那时的配置文件还留着\n其中包含着 qBittorrent 的账号、密码、端口、下载路径等信息"
    read -ep "你现在要使用以前留下的配置文件吗？${normal} [${cyan}Y${normal}/n]: " responce
    case $responce in
        [yY] | [yY][Ee][Ss] | "" ) qbconfig=old ;;
        [nN] | [nN][Oo]          ) qbconfig=new ;;
        *                        ) qbconfig=old ;;
    esac
else
    qbconfig=new
fi ; }

 # 输出结果
function install_qb_finished() {
QBPORT=` grep "WebUI.Port" ~/.config/qBittorrent/qBittorrent.conf | grep -Po "\d+" `
QBUSERNAME=` grep "WebUI.Username" ~/.config/qBittorrent/qBittorrent.conf | awk -F "=" '{print $NF}' `
if [[ ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep qbittorrent ` ]]; then
    echo -e "\n${bold}${green}qBittorrent 已安装完成！${jiacu}\n"
    echo -e "网址  ${cyan}http://$(hostname -f):$QBPORT${jiacu}"
    echo -e "账号  ${cyan}$QBUSERNAME${jiacu}"
    [[ $qbconfig == new ]] &&
    echo -e "密码  ${cyan}$PASSWORD${normal}"
    [[ $qbconfig == old ]] &&
    echo -e "密码  ${cyan}(和以前一样)${normal}"
    echo "$QBVERSION" > ~/iFeral/qbversion.lock
else
    echo -e "${error} qBittorrent 安装完成，但无法正常运行。\n不要问我为什么和怎么办，你自己看着办吧！${normal}"
fi ; }

# 新建配置文件
function install_qb_new_config() {
if [[ $qbconfig == new ]]; then
    echo ; read -ep "${bold}${yellow}请输入你要用于 qBittorrent WebUI 的密码：${normal}" PASSWORD
    QBPASS=`  echo -n $PASSWORD | md5sum | awk '{print $1}'  `
    [[ -e ~/.config/qBittorrent/qBittorrent.conf ]] && { rm -rf ~/.config/qBittorrent/qBittorrent.conf.backup ; mv -f ~/.config/qBittorrent/qBittorrent.conf ~/.config/qBittorrent/qBittorrent.conf.backup ; }
    portGenerator && portCheck
    portGenerator2 && portCheck2
    [[ $Seedbox == FH  ]]    && QBDL_PATH="${USERPATH}/private/qBittorrent/data"
    [[ $Seedbox == SH  ]]    && QBDL_PATH="${USERPATH}/downloads"
    [[ $Seedbox == PM  ]]    && QBDL_PATH="${USERPATH}/data"
    [[ $Seedbox == USB ]]    && QBDL_PATH="${USERPATH}/Downloads"
    [[ $Seedbox == DSD ]]    && QBDL_PATH="/downloads"
    [[ $Seedbox == Sbcc ]]   && QBDL_PATH="${USERPATH}/files/downloads"
    [[ $Seedbox == AppBox ]] && QBDL_PATH="/APPBOX_DATA/apps/qBittorrent"
    mkdir -p $QBDL_PATH ~/.config/qBittorrent
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
Downloads\SavePath=$QBDL_PATH

WebUI\Port=$portGen
WebUI\Password_ha1=@ByteArray($QBPASS)
WebUI\Username=$(whoami)
EOF
fi ; }


# 01. 安装 qBittorrent，V1
function install_qb_v1() {

echo ; mkdir -p ~/tmp ~/private/qbittorrent/{data,watch,torrents} ~/.config/{qBittorrent,flexget}
for qbpid in ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep qbittorrent | awk '{print $2}' ` ; do kill -9 $qbpid ; done

# 下载
if [[ ! `  ls ~/iFeral/qb/library  2>/dev/null  `  ]]; then
    echo -e "${bold}${yellow}下载 qbittorrent-nox ...${normal}\n"
    if   [[ $Seedbox == FH ]]; then
         git clone --depth=1 -b master  --single-branch https://github.com/Aniverse/qBittorrent-nox ~/iFeral/qb
    elif [[ $Seedbox == SH ]]; then
         git clone --depth=1 -b trusty2 --single-branch https://github.com/Aniverse/qBittorrent-nox ~/iFeral/qb
    else
         echo -e "${bold}${yellow}暂时不支持 FH/SH 以外的盒子 ...${normal}\n" ; exit 1
    fi
    chmod +x -R ~/iFeral/qb ; echo
fi

# 询问版本
[[ $Seedbox == FH ]] && QB_supported_versions="3.3.0-3.3.16，4.0.0-4.1.1"
[[ $Seedbox == SH ]] && QB_supported_versions="3.3.2-3.3.16，4.0.0-4.1.1"
while [[ $QBVERSION = "" ]]; do
    echo -e "${jiacu}当前可用的版本为 $QB_supported_versions"
    read -ep "${bold}${yellow}请输入你要使用的 qBittorrent 版本： ${normal}" QBVERSION
    [[ ! ` ls ~/iFeral/qb | grep $QBVERSION ` ]] && { echo -e "${error} 你输入的版本不可用，请重新输入！" ; unset QBVERSION ; }
done

install_qb_ask_config
install_qb_new_config

TMPDIR=~/tmp LD_LIBRARY_PATH=~/iFeral/qb/library ~/iFeral/qb/qbittorrent-nox.$QBVERSION -d

install_qb_finished ; }


# 01. 安装 qBittorren，V2
function install_qb_v2() {

echo ; mkdir -p ~/tmp ~/private/qbittorrent/{data,watch,torrents} ~/.config/{qBittorrent,flexget}
for qbpid in ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep qbittorrent | awk '{print $2}' ` ; do kill -9 $qbpid ; done

询问版本
QB_supported_versions=$( curl -s https://github.com/Aniverse/ygnrmRuUagpgPvr4rW97/tree/master/$CODENAME | grep "$CODENAME/qbit" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+<" | sed "s/</ /" | sed ':t;N;s/\n//;b t' )

while [[ $QBVERSION = "" ]]; do
    echo -e "${jiacu}当前可用的版本为 $QB_supported_versions"
    read -ep "${bold}${yellow}请输入你要使用的 qBittorrent 版本： ${normal}" QBVERSION
    [[ ! ` echo $QB_supported_versions | grep $QBVERSION ` ]] && { echo -e "${error} 你输入的版本不可用，请重新输入！" ; unset QBVERSION ; }
done

# 下载
if [[ ! `  ls ~/iFeral/qb/library  2>/dev/null  `  ]]; then
    echo -e "\n${bold}${yellow}下载 qbittorrent-nox ...${normal}\n"
    if   [[ $CODENAME =~ (trusty|jessie|stretch) ]]; then
         svn co -q https://github.com/Aniverse/ygnrmRuUagpgPvr4rW97/trunk/$CODENAME/lib ~/iFeral/qb/library
         wget   -q https://github.com/Aniverse/ygnrmRuUagpgPvr4rW97/raw/master/$CODENAME/qbittorrent-nox.$QBVERSION -O ~/iFeral/qb/qbittorrent-nox.$QBVERSION
         chmod +x ~/iFeral/qb/qbittorrent-nox.$QBVERSION
    else
         echo -e "${bold}${yellow}暂时不支持系统非 Debian8/9、Ubuntu 14.04 的盒子 ...${normal}\n" ; exit 1
    fi
fi

install_qb_ask_config
install_qb_new_config

# 运行 qBittorrent-nox
TMPDIR=~/tmp LD_LIBRARY_PATH=~/iFeral/qb/library ~/iFeral/qb/qbittorrent-nox.$QBVERSION -d

install_qb_finished
}


# 01. 安装 qBittorren，V3
function install_qb_v3() {

echo ; mkdir -p ~/tmp ~/private/qbittorrent/{data,watch,torrents} ~/.config/{qBittorrent,flexget}
for qbpid in ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep qbittorrent | awk '{print $2}' ` ; do kill -9 $qbpid ; done
QBVERSION=4.1.5

# 下载
if [[ ! `  ls ~/iFeral/qb/library  2>/dev/null  `  ]]; then
    echo -e "\n${bold}${yellow}下载 qbittorrent-nox ...${normal}\n"
    if [[ $CODENAME =~ (trusty|xenial|bionic|jessie|stretch) ]]; then
        if [[ $(command -v svn) ]]; then
            svn co -q https://github.com/Aniverse/bbq/trunk/$CODENAME/lib ~/iFeral/qb/library
            wget   -q https://github.com/Aniverse/bbq/raw/master/$CODENAME/qbittorrent-nox.$QBVERSION -O ~/iFeral/qb/qbittorrent-nox.$QBVERSION
            chmod +x ~/iFeral/qb/qbittorrent-nox.$QBVERSION
        elif [[ ! $(command -v svn) ]] && [[ $(command -v git) ]]; then
            git clone --depth=1 https://github.com/Aniverse/bbq
            cp -rf ~/bbq/$CODENAME ~/iFeral/qb
            chmod +x ~/iFeral/qb/qbittorrent-nox.$QBVERSION
		else # 难道我要全部 wget？？？
            echo -e "\n无法下载 qBittorrent！\n" ; exit 1
        fi
    else
         echo -e "${bold}${yellow}暂时不支持你的系统 ...${normal}\n" ; exit 1
    fi
fi

install_qb_ask_config
install_qb_new_config

# 运行 qBittorrent-nox
TMPDIR=~/tmp LD_LIBRARY_PATH=~/iFeral/qb/library ~/iFeral/qb/qbittorrent-nox.$QBVERSION -d

install_qb_finished
}






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

rm -f ~/bin/{de2,dew2} >/dev/null 2>&1
mv -f ~/.local/bin/deluged ~/bin/de2 >/dev/null 2>&1
mv -f ~/.local/bin/deluge-web ~/bin/dew2 >/dev/null 2>&1
chmod 700 ~/bin/{de2,dew2} >/dev/null 2>&1
[[ ! -e ~/bin/de2 ]] && { echo -e "${error} 第二个 Deluged 安装失败！\n不要问我为什么和怎么办，你自己看着办吧！${normal}" ; exit 1 ; }

# 询问是否覆盖原配置信息
if [[ -e ~/.config/deluge2/core.conf ]]; then
    echo -e "\n${atte} 你以前装过第二个 Deluge，那时的配置文件还留着\n其中包含着 Deluge 的账号、密码、端口、下载路径等信息"
    read -ep "你现在要使用以前留下的配置文件吗？${normal} [${cyan}Y${normal}/n]: " responce
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
    echo ; read -ep "${bold}${yellow}请输入你要用于 Deluge DAEMON 的密码：${normal}" DEPASS
    DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n1)
    DWP=$(python "$USERPATH/iFeral/app/deluge.userpass.py" ${DEPASS} ${DWSALT})
    [[ -d ~/.config/deluge2 ]] && { rm -rf ~/.config/deluge2.backup ; mv -f ~/.config/deluge2 ~/.config/deluge2.backup ; }
    mkdir -p ~/.config
    cp -rf ~/iFeral/template/deluge2 ~/.config
    portGenerator && portCheck

    sed -i 's|"daemon_port":.*,|"daemon_port": '$portGen',|g' ~/.config/deluge2/core.conf

  # 直接 sed 路径无法替换，需要用这种方式来实现，比较蛋疼
    cat ~/.config/deluge2/core.conf | sed -e "s/USERPATH/${USERPATHSED}/g" > ~/.config/deluge2/core2.conf
    mv ~/.config/deluge2/core2.conf ~/.config/deluge2/core.conf
    sed -i "s/DWSALT/${DWSALT}/g" ~/.config/deluge2/web.conf
    sed -i "s/DWP/${DWP}/g" ~/.config/deluge2/web.conf
    portGenerator2 && portCheck2 && sed -i 's|"port":.*,|"port": '$portGen2',|g' ~/.config/deluge2/web.conf
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
echo -ne "${bold}${yellow}你想用哪个版本的 rTorrent？${normal}：" ; read -e version

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
    mkdir -p ~/.config
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

# AutoDL-Irssi，bash -c "$(wget -qO- http://git.io/oTUCMg)"
wget -qO ~/install.autodl.sh https://bitbucket.org/feralio/wiki/raw/HEAD/src/wiki/software/autodl/autodl.sh
echo 1 | bash ~/install.autodl.sh

else echo "${atte} 这是为了 FH 盒子设计的，其他盒子就不要用了~${normal}" ; fi ; }






# 06. 安装 flexget
# https://www.feralhosting.com/wiki/software/pip
# https://www.feralhosting.com/wiki/software/flexget
# https://www.seedhost.eu/whmcs/knowledgebase/248/Flexget-installation.html

function _install_flexget() {

echo ; read -ep "${bold}${yellow}请输入你要用于 Flexget WebUI 的密码，不要太简单：${normal}" PASSWORD ; echo

#if [[ $Seedbox == FH ]]; then
#   pip install --user --ignore-installed --no-use-wheel virtualenv
#   ~/.local/bin/virtualenv ~/pip --system-site-packages
#   ~/pip/bin/pip install flexget
#
#~/.local/bin/virtualenv --system-site-packages ~/pip/
#~/pip/bin/pip install flexget
#~/pip/bin/pip install transmissionrpc
#fi

wget -qO- https://bootstrap.pypa.io/get-pip.py | python - --user
~/.local/bin/pip install --user --upgrade pip setuptools virtualenv
~/.local/bin/pip install --user --upgrade markdown testresources
~/.local/bin/pip install --user --upgrade deluge-client flexget transmissionrpc

portGenerator && portCheck

mkdir -p ~/.config/flexget
cp -f ~/.config/flexget/config.yml ~/.config/flexget/config.yml."$(date "+%Y.%m.%d.%H.%M.%S")".bak >/dev/null 2>&1

cat >  ~/.config/flexget/config.yml <<EOF
tasks:
  MTeam:
    rss: https://https://tp.m-team.cc/torrentrss.php
    verify_ssl_certificates: no
    regexp:
      accept:
        - OneHD
      reject:
        - MTeamPAD
web_server:
  port: $portGen
  web_ui: yes
schedules: no
EOF

FLPORT=` grep "port" ~/.config/flexget/config.yml | grep -Po "\d+" `

# 运行
~/pip/bin/flexget web passwd $PASSWORD 2>&1 | tee ~/flex.pass.output
[[ `grep "not strong enough" ~/flex.pass.output` ]] && export FlexPassFail=1
rm -f ~/flex.pass.output
~/pip/bin/flexget daemon start --daemonize

# 输出结果
if [[ -e ~/pip/bin/flexget ]]; then
    if [[ ` ps aux | grep $(whoami) | grep -Ev "grep|aux|root" | grep "flexget daemon" ` ]]; then
        echo -e "\n${bold}${green}Flexget 已安装完成！${jiacu}\n"
        echo -e "网址  ${cyan}http://$(hostname -f):$FLPORT${jiacu}"
        echo -e "账号  ${cyan}flexget${jiacu}"
        if [[ $FlexPassFail == 1 ]]; then echo -e "${error}你刚才设的密码太简单了，Flexget 不接受这么简单的密码\n请自行输入 ~/pip/bin/flexget web passwd <密码> 来设置密码\n（方括号部分请改成密码）${normal}\n"
        else echo -e "密码  ${cyan}$PASSWORD${normal}\n" ; fi
    else echo -e "${error} Flexget 安装完成，但 daemon 没开起来。\n不要问我为什么和怎么办，你自己看着办吧！${normal}" ; fi
else
    echo -e "${error} Flexget 安装失败。\n请尝试手动安装？${normal}"
fi ; }









# 07. 安装一些软件

function _install_tools() {

# ffmpeg
echo -e "\n${bold}安装 ffmpeg ...${normal}\n"
mkdir -p ~/bin
wget -qO ~/ffmpeg.tar.gz https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz
tar xf ~/ffmpeg.tar.gz && cd && rm -rf ffmpeg-*-64bit-static/{manpages,presets,readme.txt}
cp ~/ffmpeg-*-64bit-static/* ~/bin> /dev/null 2>&1
chmod 700 ~/bin/{ffmpeg,ffprobe,ffmpeg-10bit,qt-faststart}
cd && rm -rf ffmpeg{.tar.gz,-*-64bit-static}

# p7zip
echo -e "${bold}安装 p7zip ...${normal}\n"
wget -qO ~/p7zip.tar.bz2 http://sourceforge.net/projects/p7zip/files/p7zip/9.38.1/p7zip_9.38.1_src_all.tar.bz2
tar xf ~/p7zip.tar.bz2 && cd ~/p7zip_9.38.1
make -j$(nproc) > /dev/null 2>&1
make install DEST_HOME=$HOME > /dev/null 2>&1
cd && rm -f ~/p7zip.tar.bz2

# rclone
echo -e "${bold}安装 rclone ...${normal}\n"
mkdir -p ~/bin
wget -qO ~/rclone.zip http://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip -qq ~/rclone.zip
mv ~/rclone-v*-linux-amd64/rclone ~/bin
rm -rf ~/rclone-v*-linux-amd64 ~/rclone.zip
chmod +x ~/bin/rclone

# mktorrent
# echo -e "${bold}安装 mktorrent 1.1 ...${normal}\n"
# git clone --depth=1 https://github.com/Rudde/mktorrent
# cd mktorrent/ && PREFIX=$HOME make -j$(nproc)
# PREFIX=$HOME make install
# cd .. && rm -rf mktorrent

# Mediainfo
echo -e "${bold}安装新版 mediainfo ...${normal}\n"
if [[ $CODENAME == stretch ]]; then
    wget -qO 1.deb https://mediaarea.net/download/binary/libzen0/0.4.37/libzen0v5_0.4.37-1_amd64.Debian_9.0.deb
    wget -qO 2.deb https://mediaarea.net/download/binary/libmediainfo0/18.05/libmediainfo0v5_18.05-1_amd64.Debian_9.0.deb
    wget -qO 3.deb https://mediaarea.net/download/binary/mediainfo/18.05/mediainfo_18.05-1_amd64.Debian_9.0.deb
elif [[ $CODENAME == trusty ]]; then
    wget -qO 1.deb https://mediaarea.net/download/binary/libzen0/0.4.37/libzen0_0.4.37-1_amd64.xUbuntu_14.04.deb
    wget -qO 2.deb https://mediaarea.net/download/binary/libmediainfo0/18.05/libmediainfo0_18.05-1_amd64.xUbuntu_14.04.deb
    wget -qO 3.deb https://mediaarea.net/download/binary/mediainfo/18.05/mediainfo_18.05-1_amd64.xUbuntu_14.04.deb
fi
dpkg -x 1.deb ~/deb-temp ; dpkg -x 2.deb ~/deb-temp ; dpkg -x 3.deb ~/deb-temp
mv ~/deb-temp/usr/lib/x86_64-linux-gnu/* ~/lib/
mv ~/deb-temp/usr/bin/* ~/bin/
rm -rf [123].deb ~/deb-temp

grep -q mediainfo ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/flm.class.php &&
sed -i "s|(getExternal('mediainfo')|(getExternal('$(pwd)/bin/mediainfo')|g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/flm.class.php

# LD_LIBRARY_PATH=~/lib ~/bin/mediainfo --version

}






# 08. 查看盒子信息
function _stats() { 

echo -e "\n${bold}正在检查系统信息，请稍等 ... ${normal}"

# current_disk=`  echo $(pwd) | sed "s/\/$(whoami)//" | sed s"/\/home//"  `
# cdk=$(df -h | grep `pwd | awk -F '/' '{print $2,$3}' | sed "s/ /\//"` | awk '{print $1}' | awk -F '/' '{print $3}')

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
# physical_cpu_number=$( grep 'physical id' /proc/cpuinfo | cut -c15-17 )
# cpu_percent=$( top -b -n 1|grep Cpu|awk '{print $2}'|cut -f 1 -d "." )
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

tcp_control=$(cat /proc/sys/net/ipv4/tcp_congestion_control 2>1)

echo -e "${bold}正在检查服务器的其他 IP 信息 ... (可能比较慢)${normal}\n"

ipip_result=~/ipip_result
wget --no-check-certificate -qO- https://www.ipip.net/ip.html > $ipip_result 2>&1

# DediSeedbox 这蛋疼玩意儿没法在命令里带中文……
  ipip_IP=$( cat $ipip_result | grep -A3 IP     | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | head -1 )
 ipip_ASN=$( cat $ipip_result | grep -C7 ASN    | grep -oE "AS[0-9]+" | head -1 )
ipip_CIDR=$( cat $ipip_result | grep -C7 ASN    | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+" | head -1 )
  ipip_AS=$( cat $ipip_result | grep -A1 $ipip_CIDR | grep -v $ipip_CIDR | grep -oE ">.*<" | sed "s/>//" | sed "s/<//" | head -1 )
ipip_rDNS=$( cat $ipip_result | grep -oE "rDNS: [a-zA-Z0-9.-]+" | sed "s/rDNS: //" )
 ipip_Loc=$( cat $ipip_result | grep -A7 "https://tools.ipip.net/traceroute.php?ip=" | tail -1 | grep -oE ">.*<" | sed "s/>//" | sed "s/<//" )
 ipip_ISP=$( cat $ipip_result | grep -A9 "$ipip_Loc" | tail -1 | grep -oE ">.*<" | sed "s/>//" | sed "s/<//" )

rm -rf $ipip_result

clear ; echo

echo " ${bailanse}${bold}                                           08. 系统信息                                            ${normal}"
echo " ${bold}"


    if [[ ! $Seedbox == DSD ]]; then
echo -e  "${bold}  完全限定域名  : ${cyan}$serverfqdn${normal}"
    else sleep 0 ; fi
echo -e  "${bold}  IPv4 地址     : ${cyan}$serveripv4${normal}"
    if [[ $serveripv6 ]]; then
echo -e  "${bold}  IPv6 地址     : ${cyan}$serveripv6${normal}"
    else sleep 0 ; fi


echo -e  "${bold}  反向域名      : ${cyan}$ipip_rDNS${normal}"
echo -e  "${bold}  运营商        : ${cyan}$ipip_ISP${normal}"
echo -e  "${bold}  ASN 信息      : ${cyan}$ipip_ASN, $ipip_AS${normal}"
echo -e  "${bold}  地理位置      : ${cyan}$ipip_Loc${normal}"


echo
echo -e  "${bold}  CPU 型号      : ${cyan}$CPUNum$cname${normal}"
echo -e  "${bold}  CPU 核心      : ${cyan}合计 ${cpucores} 核心，${cputhreads} 线程${normal}"
echo -e  "${bold}  CPU 状态      : ${cyan}当前主频 ${freq} MHz${normal}"
echo -e  "${bold}  内存大小      : ${cyan}$tram MB ($uram MB 已用)${normal}"
echo -e  "${bold}  运行时间      : ${cyan}$uptime1${normal}"
echo -e  "${bold}  系统负载      : ${cyan}$load${normal}"
echo


if [[ $SeedboxType == Docker ]]; then sleep 0 ; else
echo -e  "${bold}  总硬盘大小    : ${cyan}共 $disk_num 个硬盘分区，合计 $disk_total_size GB ($disk_used_size GB 已用)${normal}"
echo -e  "${bold}  当前硬盘大小  : ${cyan}${current_disk_size}B (共 ${current_disk_total_used}B 已用，其中你用了 ${current_disk_self_used}B)${normal}"
echo -e  "${bold}  邻居数量      : ${cyan}整台机器共 $neighbors_all_num 位邻居，其中同硬盘邻居 $neighbors_same_disk_num 位${normal}"
echo
fi


echo -e  "${bold}  操作系统      : ${cyan}$DISTRO $osversion $CODENAME ($arch) ${yellow}$SeedboxType${normal}"
echo -e  "${bold}  运行内核      : ${cyan}$running_kernel${normal}"
if [[ $tcp_control ]]; then
echo -e  "${bold}  TCP 拥塞控制  : ${cyan}$tcp_control${normal}"
else sleep 0 ; fi


echo
echo -e  "${bold}  服务器时间    : ${cyan}$date${normal}"
echo ; }





# 09. 查看邻居信息
function _show_neighbor() { clear
if   [[ $SeedboxType == Docker ]]; then
    echo -e "${bold}Docker 类型的盒子在我所知范围内没办法看邻居……${normal}"
elif [[ $Seedbox =~ (FH|SH) ]]; then
    echo -e "${bold}${cayn}以下是当前和你在同一个硬盘分区上的邻居${normal}\n"
	cat ~/neighbors_all | grep "${current_disk}/" | awk -F ":" '{print $1}' | sort -u | pr -3 -t ; echo
    echo -e "${bold}${cayn}以下是整个盒子上所有的邻居${normal}\n"
    cat ~/neighbors_all | awk -F ":" '{print $1}' | sort -u | pr -3 -t ; echo
  # getent passwd | grep -Ev "$(whoami)|nologin|/bin/false|/bin/sync|/var/lib/libuuid|root" | awk -F ':' '{print $6}' | sort -u | pr -3 -t ; echo
    echo -e "${bold}${cayn}以下是整个盒子上所有的邻居（带路径）${normal}\n"
    cat ~/neighbors_all | awk -F ":" '{print $6}' | sort -u | pr -3 -t ; echo
elif [[ $Seedbox == PM ]]; then
    echo -e "${bold}${cayn}以下是整个盒子上的邻居${normal}\n"
    cat ~/neighbors_all | awk -F ":" '{print $1}' | sort -u | pr -3 -t ; echo
elif [[ $Seedbox == USB ]]; then
    echo -e "${bold}${cayn}以下是当前和你在同一个硬盘分区上的邻居${normal}\n"
    cat ~/neighbors_all | grep "${current_disk}/" | awk -F ":" '{print $1}' | sort -u | pr -3 -t ; echo
    echo -e "${bold}${cayn}以下是整个盒子上所有的邻居${normal}\n"
    cat ~/neighbors_all | awk -F ":" '{print $1}' | sort -u | pr -3 -t ; echo
    echo -e "${bold}${cayn}以下是整个盒子上所有的邻居（带路径）${normal}\n"
    cat ~/neighbors_all | awk -F ":" '{print $6}' | sort -u | pr -3 -t ; echo
else
    echo -e "${bold}没适配你所使用的盒子，这个邻居列表不知道准不准，凑合着看下吧${normal}\n"
    cat ~/neighbors_all | awk -F ":" '{print $1}' | sort -u | pr -3 -t ; echo
fi ; }







# 12. 安装 aria2
function _install_aria2() { 

# 安装 Aria2
wget https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.gz
tar xf aria2-1.33.1.tar.gz && rm -f aria2-1.33.1.tar.gz
cd aria2-1.33.1
./configure --prefix=$HOME
make -j$(nproc) && make install
cd .. && rm -rf aria2-1.33.1

# 安装 AiraNG
cd ~/www/$(whoami).$(hostname -f)/* 
mkdir -p aria2 ; cd aria2
wget https://github.com/mayswind/AriaNg/releases/download/0.4.0/aria-ng-0.4.0.zip
unzip aria-ng-0.4.0.zip && rm -f aria-ng-0.4.0.zip

# 配置 Aira2
mkdir -p ~/.config/aria2 ~/private/aria2
cd ~/.config/aria2
cat >~/.config/aria2/aria2.conf<<EOF
#Setting
dir=~/private/aria2
dht-file-path=~/.config/aria2/dht.dat
save-session-interval=15
force-save=false
log-level=error
 
# Advanced Options
disable-ipv6=true
file-allocation=none
max-download-result=35
max-download-limit=20M
 
# RPC Options
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-save-upload-metadata=true
rpc-secure=false
rpc-listen-port=10087
 
# see --split option
continue=true
max-concurrent-downloads=10
max-overall-download-limit=0
max-overall-upload-limit=5
max-upload-limit=1
 
# Http/FTP options
split=16
connect-timeout=120
max-connection-per-server=16
max-file-not-found=2
min-split-size=10M
check-certificate=false
http-no-cache=true
 
#BT options
bt-enable-lpd=true
bt-max-peers=1024
bt-require-crypto=true
follow-torrent=true
listen-port=6881-6999
bt-request-peer-speed-limit=256K
bt-hash-check-seed=true
bt-seed-unverified=true
bt-save-metadata=true
enable-dht=true
enable-peer-exchange=true
seed-time=0
EOF

echo -e "\nhttp://$(whoami).$(hostname -f)/aria2\n"
aria2c --enable-rpc --rpc-listen-all -D


}





_logo
_init
_main_menu

