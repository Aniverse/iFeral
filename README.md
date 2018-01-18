# iFeral
> 主要针对 FH SSD，HDD 某些地方可能有区别  
> 部分内容对于 SeedHost 也适用  
> 我懒得把它们写成脚本了  
> rm -rf ~/.* ~/*   

## What can I do for you ?
- 安装任意版本的 Deluge，同时运行两个 Deluge
- 将 rTorrent 版本降低至 0.9.4 或者更低
- 升级 ruTorrent 到 3.8
- 安装第三方 ruTorrent 插件与主题
- 安装 qBittorrent，可选版本为 3.3.7 / 3.3.11 / 3.3.16
  
- 使用 oh-my-zsh，配置 alias 简化命令
- 设置时区为 UTC+8，设置 UTF-8 为默认编码
- 安装 rar, unrar, speedtest, rclone, mktorrent
- 安装 h5ai
- 安装 Aria2 & WebUI
- 安装 Flexget & WebUI
- 安装 pip, mono, cmake, ffmepg
- 用 p7zip 解压 DVDISO（BDISO 无解）
- 在 FeralHosting 盒子上用脚本扫描 BDinfo

## qBittorrent、rar、unrar、speedtest，oh-my-zsh
``` 
cd
chsh -s /usr/bin/zsh
rm -rf ~/.oh-my-zsh .zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget -qO ~/.oh-my-zsh/themes/agnosterzak.zsh-theme http://raw.github.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme

rm -rf iFeral
git clone --depth=1 https://github.com/Aniverse/iFeral
chmod -R +x iFeral
mkdir -p tmp private/qbittorrent/{data,watch,torrents} ~/.config/qBittorrent
```

### Configuring qBittorrent
```
PASSWORD=<INPUT YOUR PASSWORD>
QBPASS=$(python ~/iFeral/app/qbittorrent.userpass.py ${PASSWORD})

function portGenerator() { portGen=$(shuf -i 10001-32001 -n 1) }
function portCheck() { while [[ "$(netstat -ln | grep ':'"$portGen"'' | grep -c 'LISTEN')" -eq "1" ]];do;portGenerator;done }
portGenerator && portCheck

cat > ~/.config/qBittorrent/qBittorrent.conf <<EOF
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
General\Locale=zh
Queueing\QueueingEnabled=false
Downloads\SavePath=private/qBittorrent/data

WebUI\Port=$portGen
WebUI\Password_ha1=@ByteArray($QBPASS)
WebUI\Username=$(whoami)
EOF
```

## qBittorrent 3.3.7 (From FeralHosting Offical WiKi)
``` 
wget -qO ~/install.qbittorrent.sh https://goo.gl/PFYfgd && bash ~/install.qbittorrent.sh
```

## zsh
```
#sed -i '/^ZSH_THEME.*/'d ~/.zshrc
sed -i "s/robbyrussell/agnosterzak/g" ~/.zshrc

cat >> ~/.zshrc <<EOF
#ZSH_THEME="agnoster"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TZ="/usr/share/zoneinfo/Asia/Shanghai"

export PATH=~/iFeral/app:~/iFeral/bdupload:~/bin:~/pip/bin:$PATH
export LD_LIBRARY_PATH=~/iFeral/qbittorrent.3.3.16:$PATH
export TMPDIR=~/tmp

alias -s sh='bash'
alias -s log='tail -n50'
alias -s gz='tar -xzvf'
alias -s xz='tar xf'
alias -s tgz='tar -xzvf'
alias -s rar='unrar x'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

alias yongle='du -sB GB ~/'
alias space='du -sB GB'
alias chongqi='bash ~/iFeral/app/restart.sh'
alias shanchu='rm -rf'
alias cesu='echo;python ~/iFeral/app/spdtest --share;echo'
alias cesu2='python ~/iFeral/app/spdtest --share --server'
alias cesu3="echo;python ~/iFeral/app/spdtest --list 2>&1 | head -n30 | grep --color=always -P '(\d+)\.(\d+)\skm|(\d+)(?=\))';echo"
alias ls="ls -hAv --color --group-directories-first"
alias ll="ls -hAlvZ --color --group-directories-first"
alias cdde="cd ~/private/deluge/data && ll"
alias cdrt="cd ~/private/rtorrent/data && ll"
alias cdtr="cd ~/private/transmission/data && ll"
alias cdqb="cd ~/private/qbittorrent/data && ll"
alias scrgd="screen -R gooooogle"
alias quanxian="chmod -R +x"
alias cdb="cd .."
alias wget="wget --no-check-certificate"
alias gclone="git clone --depth=1"
alias scrl="screen -ls"
alias zjpid='ps aux | egrep "$(whoami)|COMMAND" | egrep -v "grep|aux|root"'
alias pid="ps aux | grep -v grep | grep"
alias io='iostat -d -x -m 1| grep -E "`echo $PWD | cut -c8-10` | rMB/s | wMB/s"'
alias ios="iostat -d -x -m 1"
alias wangsu='sar -n DEV 1| grep -E "rxkB\/s|txkB\/s|eth0|eth1"'
alias qb11='nohup ~/iFeral/app/qbitorrent-nox.3.3.11 &'
alias qb16='nohup ~/iFeral/app/qbitorrent-nox.3.3.16 &'
alias fenjuan="rar5 a -rr5 -m0 -ma5 -v1983M"

alias killde='kill "$(pgrep -fu "$(whoami)" "deluged")"'
alias killtr='kill "$(pgrep -fu "$(whoami)" "transmission-daemon")"'
alias killrt='kill "$(pgrep -fu "$(whoami)" "/usr/local/bin/rtorrent")"'
alias killqb='kill "$(pgrep -fu "$(whoami)" "qbittorrent-nox")"'

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

source ~/.zshrc
#nano ~/.zshrc
```





## rTorrent & ruTorrent

### rTorrent Version
```
rtversion="0.9.3_w0.13.3"
rtversion="0.9.6_w0.13.6"
rtversion="0.9.4_w0.13.4"
```

```
echo -n "${rtversion}" > ~/private/rtorrent/.version
pkill -fu "$(whoami)" 'SCREEN -S rtorrent'
SCREEN -S rtorrent -fa -d -m rtorrent
```

### ruTorrent Password
```
htpasswd -cm ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd $(whoami)
```

### ruTorrent Upgrade
```
cd ~/www/$(whoami).$(hostname -f)/public_html
git clone --depth=1 https://github.com/Novik/ruTorrent
cp -r rutorrent/conf/* ruTorrent/conf/
cp rutorrent/.ht* ruTorrent/
rm -rf rutorrent/ && mv ruTorrent rutorrent && cd
```

### ruTorrent Themes

```
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/theme/themes
svn co -q https://github.com/ArtyumX/ruTorrent-Themes/trunk/MaterialDesign
svn co -q https://github.com/ArtyumX/ruTorrent-Themes/trunk/club-QuickBox
cd
```

### ruTorrent Plugins

- #### AutoDL-Irssi
```
wget -qO ~/install.autodl.sh http://git.io/oTUCMg && bash ~/install.autodl.sh && rm -rf ~/install.autodl.sh
```

- #### Screenshots supports m2ts
```
cd && sed -i "s|ffmpeg'] = ''|ffmpeg'] = '$(pwd)/bin/ffmpeg'|g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/screenshots/conf.php
sed -i "s/\"mkv\"/\"mkv\",\"m2ts\"/g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/screenshots/conf.php
```

- #### Filemanager
```
cd ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/filemanager
chmod 700 ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/scripts/*
cd && sed -i "s|(getExternal(\"ffprobe\")|(getExternal(\"~/bin/ffprobe\")|g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/flm.class.php
sed -i "s|(getExternal('ffmpeg')|(getExternal('$(pwd)/bin/ffmpeg')|g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/flm.class.php
```

- #### Fileshare
```
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileshare
ln -s ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/share.php ~/www/$(whoami).$(hostname -f)/public_html/
sed "/if(getConfFile(/d" -i ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/share.php
sed -i "s|'http://mydomain.com/share.php';|'http://$(whoami).$(hostname -f)/share.php';|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/conf.php
```

- #### Fileupload
```
mkdir -p ~/bin
git clone --depth=1 https://github.com/mcrapet/plowshare.git ~/.plowshare-source && cd ~/.plowshare-source
make install PREFIX=$HOME
cd && rm -rf .plowshare-source
plowmod --install
cd ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileupload
cd
```

- #### ruTorrent Mobile
```
cd ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins
git clone --depth=1 https://github.com/xombiemp/rutorrentMobile.git mobile
cd
```

- #### Coloured Ratio Column
```
wget -qO ~/ratio.zip http://git.io/71cumA
unzip -qo ~/ratio.zip -d ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/
rm -f ratio.zip
```





### Install another version of Deluge & running multiple instances
```
DEVERSION=1.3.13
```

```
wget -O ~/deluge-"${DEVERSION}".tar.gz http://download.deluge-torrent.org/source/deluge-"${DEVERSION}".tar.gz
tar zxf ~/deluge-"${DEVERSION}".tar.gz && cd ~/deluge-"${DEVERSION}"
python setup.py install --user
cd && rm -rf ~/deluge-"${DEVERSION}" ~/deluge-"${DEVERSION}".tar.gz
echo "export PATH=~/.local/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
mv ~/.local/bin/deluged ~/.local/bin/de2
mv ~/.local/bin/deluge-web ~/.local/bin/dew2
cp -r ~/.config/deluge ~/.config/deluge2
rm -rf ~/.config/deluge2/deluged.pid ~/.config/deluge2/state/*.torrent
sed -i 's|"daemon_port":.*,|"daemon_port": '$(shuf -i 10001-32001 -n 1)',|g' ~/.config/deluge2/core.conf

de2 -c ~/.config/deluge2
dew2 --fork -c ~/.config/deluge2 --port 65231
```

### Accessing Deluge Remote GUI
```
printf "$(hostname -f)\n$(whoami)\n$(sed -rn 's/(.*)"daemon_port": (.*),/\2/p' ~/.config/deluge/core.conf)\n$(sed -rn "s/$(whoami):(.*):(.*)/\1/p" ~/.config/deluge/auth)\n"
printf "$(hostname -f)\n$(whoami)\n$(sed -rn 's/(.*)"daemon_port": (.*),/\2/p' ~/.config/deluge2/core.conf)\n$(sed -rn "s/$(whoami):(.*):(.*)/\1/p" ~/.config/deluge2/auth)\n"
```




### FFmpeg (From FeralHosting Offical WiKi)
```
mkdir -p ~/bin
wget -qO ~/ffmpeg.tar.gz https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz
tar xf ~/ffmpeg.tar.gz && cd && rm -rf ffmpeg-*-64bit-static/{manpages,presets,readme.txt}
cp ~/ffmpeg-*-64bit-static/* ~/bin
chmod 700 ~/bin/{ffmpeg,ffprobe,ffmpeg-10bit,qt-faststart}
cd && rm -rf ffmpeg{.tar.gz,-*-64bit-static}
```

### FFmpeg buliding
```
wget http://ffmpeg.org/releases/ffmpeg-3.4.1.tar.xz
tar xf ffmpeg-3.4.1.tar.xz
cd ffmpeg-3.4.1
./configure --prefix=$HOME --enable-static --disable-shared --enable-pic --disable-x86asm
make -j$(nproc) 1>> /dev/null
make install
cd; rm -rf ffmpeg-3.4.1 ffmpeg-3.4.1.tar.xz
```

### Install p7zip
```
wget -qO ~/p7zip.tar.bz2 http://sourceforge.net/projects/p7zip/files/p7zip/9.38.1/p7zip_9.38.1_src_all.tar.bz2
tar xf ~/p7zip.tar.bz2 && cd ~/p7zip_9.38.1
make && make install DEST_HOME=$HOME
cd && rm -f ~/p7zip.tar.bz2
```

### Install rclone
```
mkdir -p ~/bin
wget -qO ~/rclone.zip http://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip ~/rclone.zip
mv ~/rclone-v*-linux-amd64/rclone ~/bin
rm -rf ~/rclone-v*-linux-amd64 ~/rclone.zip
```

```
mkdir -p ~/.config/rclone
cat>~/.config/rclone/rclone.conf<<EOF
--- PASTE YOUR CONFIG HERE ---
EOF
```

### Install Mktorrent
```
git clone --depth=1 https://github.com/Rudde/mktorrent
cd mktorrent/ && PREFIX=$HOME make -j$(nproc)
PREFIX=$HOME make install
cd .. && rm -rf mktorrent
```

### Install CMake & mono
```
mkdir -p ~/bin
wget -O ~/cmake.tar.gz https://cmake.org/files/v3.9/cmake-3.9.4-Linux-x86_64.tar.gz
tar xf ~/cmake.tar.gz --strip-components=1 -C ~/
rm -rf ~/cmake.tar.gz

wget -O ~/libtool.tar.gz http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
tar xf ~/libtool.tar.gz && cd ~/libtool-2.4.6
./configure --prefix=$HOME
make -j$(nproc) && make install 
cd .. && rm -rf libtool{-2.4.6,.tar.gz}

PATH=~/bin:$PATH
wget -qO ~/mono.tar.bz2 http://download.mono-project.com/sources/mono/mono-5.4.0.201.tar.bz2
tar xf ~/mono.tar.bz2 && cd ~/mono-*
./autogen.sh --prefix="$HOME"
make get-monolite-latest && make -j$(nproc) && make install
cd && rm -rf ~/mono{-*,.tar.bz2}
```

### Install Pip & Flexget
```
pip install --user --ignore-installed --no-use-wheel virtualenv
~/.local/bin/virtualenv ~/pip --system-site-packages
~/pip/bin/pip install flexget
touch ~/.config/flexget/config.yml

pip install --user transmissionrpc
sed -i "s|base_url + '/t|base_url + '/$(whoami)/t|g" ~/.local/lib/python2.7/site-packages/transmissionrpc/client.py
```

### Install Node.js & Flood
```
mkdir -p ~/bin
wget -qO ~/node.js.tar.gz https://nodejs.org/dist/v8.7.0/node-v8.7.0-linux-x64.tar.xz
tar xf ~/node.js.tar.gz --strip-components=1 -C ~/
cd && rm -rf node.js.tar.gz

rm -rf ~/node/apps
mkdir -p ~/node/apps
git clone --depth=1 -b v1.0.0 --single-branch https://github.com/jfurrow/flood.git ~/node/apps/flood
cp ~/node/apps/flood/config.template.js ~/node/apps/flood/config.js

sed -i "s|floodServerHost: '127.0.0.1'|floodServerHost: ''|g" ~/node/apps/flood/config.js
sed -i "s|floodServerPort: 3000|floodServerPort: $(shuf -i 10001-32001 -n 1)|g" ~/node/apps/flood/config.js
sed -i "s|secret: 'flood'|secret: '$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)'|g" ~/node/apps/flood/config.js
sed -i "s|socket: false|socket: true|g" ~/node/apps/flood/config.js
sed -i "s|socketPath: '/tmp/rtorrent.sock'|socketPath: '$HOME/private/rtorrent/.socket'|g" ~/node/apps/flood/config.js
npm install --production --prefix ~/node/apps/flood
npm run build --prefix ~/node/apps/flood

screen -dmS flood npm start --prefix ~/node/apps/flood/ && echo http://$(id -u -n).$(hostname -f):$(sed -rn 's/(.*)floodServerPort: (.*),/\2/p' ~/node/apps/flood/config.js)
```

### Install Aria2
```
git clone --depth=1 -b release-1.33.1 --single-branch https://github.com/aria2/aria2
cd aria2
autoreconf -i
./configure --prefix=$HOME
make -j$(nproc) && make install
cd .. && rm -rf aria2

cd ~/www/$(whoami).$(hostname -f)/* 
git clone --depth=1 https://github.com/ziahamza/webui-aria2 aria2

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
aria2c --enable-rpc --rpc-listen-all
```

### Install h5ai
```
wget -qO ~/h5ai.zip http://git.io/vEMGv
unzip -qo ~/h5ai.zip -d ~/www/$(whoami).$(hostname -f)/*/
echo -e '<Location ~ "/">\n    DirectoryIndex  index.html  index.php  /_h5ai/public/index.php\n</Location>' > ~/.apache2/conf.d/h5ai.conf
/usr/sbin/apache2ctl -k graceful
```





### General info on installing software
```
tar xf XXXXXXXXX.tar.gz --strip-components=1 -C ~/
cmake -DPREFIX=$HOME
./configure --prefix=$HOME
PREFIX=$HOME make -j$(nproc)
make install DEST_HOME=$HOME
```

```
echo "PATH=~/bin:$PATH" > ~/.bashrc
source ~/.bashrc
```

```
wget -qO software.deb https://somesite.com/software.deb
dpkg -x ~/software.deb ~/software
cp -rf ~/software/usr/bin* ~/bin/
rm -rf ~/software
```

```
cd ~/www/$(whoami).$(hostname -f)/*
```


  -------------------
### Some references
https://www.feralhosting.com/wiki  
https://github.com/feralhosting/faqs-cached  

https://github.com/wyjok/FH  