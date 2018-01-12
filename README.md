# iFeral
> 主要针对 FH SSD，HDD 某些地方可能有区别  
> rm -rf ~/.* ~/*    

## qBittorrent、rar、unrar、speedtest，alias，zsh
``` 
cd
wget -O ~/.zshrc https://github.com/Aniverse/iFeral/raw/master/template/zshrc
chsh -s /usr/bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget -O ~/.oh-my-zsh/themes/agnosterzak.zsh-theme http://raw.github.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme

git clone --depth=1 https://github.com/Aniverse/iFeral
chmod -R +x iFeral
mkdir -p tmp private/qbittorrent/{data,watch,torrents}

source ~/.zshrc
```

## rTorrent $ ruTorrent

#### 修改 ruTorrent 的密码
```htpasswd -cm ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/.htpasswd $(whoami)```

#### 改变 rTorrent 的版本
```
rtversion="0.9.3_w0.13.3"
rtversion="0.9.6_w0.13.6"
rtversion="0.9.4_w0.13.4"
```

```
echo -n "${rtversion}" > ~/private/rtorrent/.version
pkill -fu "$(whoami)" 'SCREEN -S rtorrent'
screen -S rtorrent rtorrent
```

#### ruTorrent 升级到 3.8
```
cd ~/www/$(whoami).$(hostname -f)/public_html/
git clone --depth=1 https://github.com/Novik/ruTorrent.git
cp -r rutorrent/conf/* ruTorrent/conf/
cp rutorrent/.ht* ruTorrent/
rm -rf rutorrent/ && mv ruTorrent rutorrent && cd
```

#### ruTorrent Plugins

##### ffmpeg
```
wget http://ffmpeg.org/releases/ffmpeg-3.4.1.tar.xz
tar xf ffmpeg-3.4.1.tar.xz
cd ffmpeg-3.4.1
./configure --prefix=$HOME --enable-static --disable-shared --enable-pic --disable-x86asm
make -j48 1>> /dev/null
make install
cd; rm -rf ffmpeg-3.4.1 ffmpeg-3.4.1.tar.xz
```

##### Filemanager
```
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/filemanager
chmod 700 ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/filemanager/scripts/*
cd && sed -i "s|(getExternal(\"ffprobe\")|(getExternal(\"~/bin/ffprobe\")|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/filemanager/flm.class.php
sed -i "s|(getExternal('ffmpeg')|(getExternal('$(pwd)/bin/ffmpeg')|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/filemanager/flm.class.php
```

##### Fileshare
```
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileshare
ln -s ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/share.php ~/www/$(whoami).$(hostname -f)/public_html/
sed "/if(getConfFile(/d" -i ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/share.php
sed -i "s|'http://mydomain.com/share.php';|'http://$(whoami).$(hostname -f)/share.php';|g" ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/conf.php
```

##### Fileupload
```
mkdir -p ~/bin
git clone https://github.com/mcrapet/plowshare.git ~/.plowshare-source && cd ~/.plowshare-source
make install PREFIX=$HOME
cd && rm -rf .plowshare-source
plowmod --install
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileupload
```

##### AutoDL-Irssi
```
wget -qO ~/install.autodl.sh http://git.io/oTUCMg && bash ~/install.autodl.sh
```





### 改变 Deluge 的版本
```
DEVERSION=1.3.13
```

```
wget -qO ~/deluge-tmp.tar.gz http://download.deluge-torrent.org/source/deluge-"${DEVERSION}".tar.gz
mkdir ~/deluge-tmp && tar xf ~/deluge-tmp.tar.gz  --strip-components=1 -C ~/deluge-tmp && cd ~/deluge-tmp/
python setup.py install --user
cd && rm -rf ~/deluge-tmp*
```



### 设置客户端及其密码
```
cd
ANUSER=$(whoami)
ANPASS=

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

### 一些编译安装时的选项
```
./configure --prefix=$HOME/bin
make -j24
make install DEST_HOME=$HOME
echo "PATH=~/bin:$PATH" > ~/.bashrc
source ~/.bashrc
```

