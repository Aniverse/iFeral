# iFeral
> 主要针对 FH SSD，HDD 某些地方可能有区别  
> 部分内容对于 SeedHost 也适用
> rm -rf ~/.* ~/*   
> cd ~/www/$(whoami).$(hostname -f)/*  

## qBittorrent、rar、unrar、speedtest，oh-my-zsh
``` 
cd
chsh -s /usr/bin/zsh
rm -rf ~/.oh-my-zsh .zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget -O ~/.oh-my-zsh/themes/agnosterzak.zsh-theme http://raw.github.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme
cp -f "${local_packages}"/template/config/zshrc ~/.zshrc

rm -rf iFeral
git clone --depth=1 https://github.com/Aniverse/iFeral
chmod -R +x iFeral
mkdir -p tmp private/qbittorrent/{data,watch,torrents}
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

export PATH=~/iFeral/app:~/iFeral/bdupload:~/bin:$PATH
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

#nano ~/.zshrc
source ~/.zshrc
```

## rTorrent & ruTorrent

### 修改 ruTorrent 的密码
```htpasswd -cm ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd $(whoami)```

### 修改 rTorrent 的版本
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

### ruTorrent 升级到 3.8
```
cd ~/www/$(whoami).$(hostname -f)/public_html/
git clone --depth=1 https://github.com/Novik/ruTorrent.git
cp -r rutorrent/conf/* ruTorrent/conf/
cp rutorrent/.ht* ruTorrent/
rm -rf rutorrent/ && mv ruTorrent rutorrent && cd
```

### ruTorrent Plugins

#### ffmpeg
```
wget http://ffmpeg.org/releases/ffmpeg-3.4.1.tar.xz
tar xf ffmpeg-3.4.1.tar.xz
cd ffmpeg-3.4.1
./configure --prefix=$HOME --enable-static --disable-shared --enable-pic --disable-x86asm
make -j48 1>> /dev/null
make install
cd; rm -rf ffmpeg-3.4.1 ffmpeg-3.4.1.tar.xz
```

#### Filemanager
```
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/filemanager
chmod 700 ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/filemanager/scripts/*
cd && sed -i "s|(getExternal(\"ffprobe\")|(getExternal(\"~/bin/ffprobe\")|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/filemanager/flm.class.php
sed -i "s|(getExternal('ffmpeg')|(getExternal('$(pwd)/bin/ffmpeg')|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/filemanager/flm.class.php
```

#### Fileshare
```
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileshare
ln -s ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/share.php ~/www/$(whoami).$(hostname -f)/public_html/
sed "/if(getConfFile(/d" -i ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/share.php
sed -i "s|'http://mydomain.com/share.php';|'http://$(whoami).$(hostname -f)/share.php';|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/conf.php
```

#### Fileupload
```
mkdir -p ~/bin
git clone https://github.com/mcrapet/plowshare.git ~/.plowshare-source && cd ~/.plowshare-source
make install PREFIX=$HOME
cd && rm -rf .plowshare-source
plowmod --install
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileupload
```

#### AutoDL-Irssi
```
wget -qO ~/install.autodl.sh http://git.io/oTUCMg && bash ~/install.autodl.sh
```

### 安装第二个 Deluge
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

### 显示 Deluge Remote GUI 要用的信息
```
printf "$(hostname -f)\n$(whoami)\n$(sed -rn 's/(.*)"daemon_port": (.*),/\2/p' ~/.config/deluge/core.conf)\n$(sed -rn "s/$(whoami):(.*):(.*)/\1/p" ~/.config/deluge/auth)\n"
printf "$(hostname -f)\n$(whoami)\n$(sed -rn 's/(.*)"daemon_port": (.*),/\2/p' ~/.config/deluge2/core.conf)\n$(sed -rn "s/$(whoami):(.*):(.*)/\1/p" ~/.config/deluge2/auth)\n"
```

### 设置客户端及其密码（还没写完）
```
cd
ANUSER=$(whoami)
ANPASS=你的密码

kill "$(pgrep -fu "$(whoami)" "deluged")"
kill "$(pgrep -fu "$(whoami)" "transmission-daemon")"
kill "$(pgrep -fu "$(whoami)" "/usr/local/bin/rtorrent")"
kill "$(pgrep -fu "$(whoami)" "qbittorrent-nox")"

~/.config/deluge/plugins

# qBittorrent WebUI
cp -f ~/iFeral/template/qBittorrent.conf ~/.config/qBittorrent/qBittorrent.conf
QBPASS=$(python ~/iFeral/app/qbittorrent.userpass.py ${ANPASS})

sed -i "s/PPWWDD/$(pwd)/g" ~/.config/qBittorrent/qBittorrent.conf
sed -i "s/SCRIPTUSERNAME/${ANUSER}/g" ~/.config/qBittorrent/qBittorrent.conf
sed -i "s/SCRIPTQBPASS/${QBPASS}/g" ~/.config/qBittorrent/qBittorrent.conf

# Deluge WebUI

cp -f ~/iFeral/template/deluge.core.conf ~/.config/deluge/core.conf


DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DWP=$(python ~/iFeral/app/deluge.userpass.py ${ANPASS} ${DWSALT})

sed -i '/^$(whoami):.*/'d ~/.config/deluge/auth
echo "${ANUSER}:${ANPASS}:10" > ~/.config/deluge/auth

sed -i "s/delugeuser/${ANUSER}/g" ~/.config/deluge/core.conf
sed -i "s/DWSALT/${DWSALT}/g" ~/.config/deluge/web.conf
sed -i "s/DWP/${DWP}/g" ~/.config/deluge/web.conf

# Transmission WebUI
#sed -i "s/RPCUSERNAME/${ANUSER}/g" ~/.config/transmission-daemon/settings.json
#sed -i "s/RPCPASSWORD/${ANPASS}/g" ~/.config/transmission-daemon/settings.json
sed -i 's|"download_location": "$(pwd)/Downloads"|"download_location": "$(pwd)/private/deluge/data"|g' ~/.config/deluge/core.conf
sed -i 's|"autoadd_location": "$(pwd)/Downloads"|"autoadd_location": "$(pwd)/private/deluge/watch"|g' ~/.config/deluge/core.conf
```

### 安装 CMake 与 mono
```
mkdir -p ~/bin
wget -qO ~/cmake.tar.gz https://cmake.org/files/v3.9/cmake-3.9.4-Linux-x86_64.tar.gz
tar xf ~/cmake.tar.gz --strip-components=1 -C ~/

mkdir -p ~/bin
wget -qO ~/libtool.tar.gz http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
tar xf ~/libtool.tar.gz && cd ~/libtool-2.4.6
./configure --prefix=$HOME
make -j$(nproc) && make install 
cd && rm -rf libtool{-2.4.6,.tar.gz}

PATH=~/bin:$PATH
wget -qO ~/mono.tar.bz2 http://download.mono-project.com/sources/mono/mono-5.4.0.201.tar.bz2
tar xf ~/mono.tar.bz2 && cd ~/mono-*
./autogen.sh --prefix="$HOME"
make get-monolite-latest && make -j$(nproc) && make install
cd && rm -rf ~/mono{-*,.tar.bz2}
```

### 安装 pip 与 Flexget
```
pip install --user --ignore-installed --no-use-wheel virtualenv
~/.local/bin/virtualenv ~/pip --system-site-packages
~/pip/bin/pip install flexget
touch ~/config.yml
```

### 安装 Node.js 与 Flood
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

### 一些安装时的参数与用法
```
~/pip/bin/pip install package

tar xf XXXXXXXXX.js.tar.gz --strip-components=1 -C ~/
cmake -DPREFIX=$HOME
./configure --prefix=$HOME
PREFIX=$HOME make
make -j24
make install DEST_HOME=$HOME

echo "PATH=~/bin:$PATH" > ~/.bashrc
source ~/.bashrc

wget -qO software.deb https://somesite.com/software.deb
dpkg -x ~/software.deb ~/software
cp -rf ~/software/usr/bin* ~/bin/
rm -rf ~/software
```



  -------------------
### Some references
https://www.feralhosting.com/wiki
https://github.com/feralhosting/wiki
https://github.com/feralhosting/faqs-cached

https://www.feralhosting.com/wiki/software/flexget