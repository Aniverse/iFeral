## Get iFeral
``` 
git clone --depth=1 https://github.com/Aniverse/iFeral
chmod -R +x iFeral
mkdir -p ~/tmp ~/private/qbittorrent/{data,watch,torrents} ~/.config/qBittorrent
```


# rTorrent & ruTorrent

### rTorrent Downgrade
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

### sox, spectrogram
```
wget http://ftp.debian.org/debian/pool/main/s/sox/libsox3_14.4.2-3_amd64.deb
dpkg -x libsox3_14.4.2-3_amd64.deb ~/deb-temp
wget http://ftp.debian.org/debian/pool/main/s/sox/sox_14.4.2-3_amd64.deb
dpkg -x sox_14.4.2-3_amd64.deb ~/deb-temp
mv ~/deb-temp/usr/lib/x86_64-linux-gnu/* ~/lib/
mv ~/deb-temp/usr/bin/* ~/bin/
rm -rf ~/*.deb ~/deb-temp
cd && sed -i "s|sox'] = ''|sox'] = '$(pwd)/bin/sox'|g"  \
~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/spectrogram/conf.php
```

### ruTorrent Themes

```
cd ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/theme/themes
svn co -q https://github.com/ArtyumX/ruTorrent-Themes/trunk/MaterialDesign
svn co -q https://github.com/ArtyumX/ruTorrent-Themes/trunk/club-QuickBox
```

### ruTorrent Plugins

- #### AutoDL-Irssi
```
wget -qO ~/install.autodl.sh http://git.io/oTUCMg && bash ~/install.autodl.sh && rm -rf ~/install.autodl.sh
```

- #### Screenshots
```
cd && sed -i "s|ffmpeg'] = ''|ffmpeg'] = '$(pwd)/bin/ffmpeg'|g" \
~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/screenshots/conf.php
sed -i "s/\"mkv\"/\"mkv\",\"m2ts\"/g" ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/screenshots/conf.php
```

- #### Filemanager
```
cd ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/filemanager
chmod 700 ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/scripts/*
cd && sed -i "s|(getExternal(\"ffprobe\")|(getExternal(\"~/bin/ffprobe\")|g" \
~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/flm.class.php
sed -i "s|(getExternal('ffmpeg')|(getExternal('$(pwd)/bin/ffmpeg')|g" \
~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/filemanager/flm.class.php
```

- #### Fileshare
```
cd ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/
svn co -q https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileshare
ln -s ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/share.php \
~/www/$(whoami).$(hostname -f)/public_html/
sed "/if(getConfFile(/d" -i ~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/share.php
sed -i "s|'http://mydomain.com/share.php';|'http://$(whoami).$(hostname -f)/share.php';|g" \
~/www/$(whoami).$(hostname -f)/public_html/rutorrent/plugins/fileshare/conf.php
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
```

- #### ruTorrent Mobile
```
cd ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins
git clone --depth=1 https://github.com/xombiemp/rutorrentMobile.git mobile
```

- #### Coloured Ratio Column
```
wget -qO ~/ratio.zip http://git.io/71cumA
unzip -qo ~/ratio.zip -d ~/www/$(whoami).$(hostname -f)/*/rutorrent/plugins/
rm -f ratio.zip
```

### Node.js & Flood
```
mkdir -p ~/bin
wget -qO ~/node.js.tar.gz https://nodejs.org/dist/v8.7.0/node-v8.7.0-linux-x64.tar.xz
tar xf ~/node.js.tar.gz --strip-components=1 -C ~/
cd && rm -rf node.js.tar.gz
```

```
rm -rf ~/node/apps
mkdir -p ~/node/apps
git clone --depth=1 -b v1.0.0 --single-branch https://github.com/jfurrow/flood.git ~/node/apps/flood
cp ~/node/apps/flood/config.template.js ~/node/apps/flood/config.js

sed -i "s|floodServerHost: '127.0.0.1'|floodServerHost: ''|g" ~/node/apps/flood/config.js
sed -i "s|floodServerPort: 3000|floodServerPort: $(shuf -i 10001-32001 -n 1)|g" ~/node/apps/flood/config.js
sed -i "s|secret: 'flood'|secret: '$(< /dev/urandom tr -dc \
'1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)'|g" \
~/node/apps/flood/config.js
sed -i "s|socket: false|socket: true|g" ~/node/apps/flood/config.js
sed -i "s|socketPath: '/tmp/rtorrent.sock'|socketPath: '$HOME/private/rtorrent/.socket'|g" \
~/node/apps/flood/config.js
npm install --production --prefix ~/node/apps/flood
npm run build --prefix ~/node/apps/flood

screen -dmS flood npm start --prefix ~/node/apps/flood/ &&
echo http://$(id -u -n).$(hostname -f):$(sed -rn 's/(.*)floodServerPort: (.*),/\2/p' ~/node/apps/flood/config.js)
```









# Deluge

### Install another version of Deluge & running the second instances

**Select a version to be installed**  
```
DEVERSION=1.3.9
```

**Install**  
```
wget -O ~/deluge-"${DEVERSION}".tar.gz http://download.deluge-torrent.org/source/deluge-"${DEVERSION}".tar.gz
tar zxf ~/deluge-"${DEVERSION}".tar.gz && cd ~/deluge-"${DEVERSION}"
sed -i "s/SSL.SSLv3_METHOD/SSL.SSLv23_METHOD/g" deluge/core/rpcserver.py
sed -i "/        ctx = SSL.Context(SSL.SSLv23_METHOD)/a\        ctx.set_options(SSL.OP_NO_SSLv2 & \
SSL.OP_NO_SSLv3)" deluge/core/rpcserver.py
python setup.py install --user >/dev/null 2>&1
cd && rm -rf ~/deluge-"${DEVERSION}" ~/deluge-"${DEVERSION}".tar.gz
echo "export PATH=~/.local/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
```

**Configure**  
```
mv -f ~/.local/bin/deluged ~/.local/bin/de2
mv -f ~/.local/bin/deluge-web ~/.local/bin/dew2
cp -r ~/.config/deluge ~/.config/deluge2
rm -rf ~/.config/deluge2/deluged.pid ~/.config/deluge2/state/*.torrent

portGenerator() { portGen=$(shuf -i 10001-32001 -n1) ; }
portCheck() { while [[ "$(netstat -ln | grep ':'"$portGen"'' | grep -c 'LISTEN')" -eq "1" ]]
do portGenerator ; done ; } ; portGenerator && portCheck
portGenerator2() { portGen2=$(shuf -i 10001-32001 -n1) ; }
portCheck2() { while [[ "$(netstat -ln | grep ':'"$portGen2"'' | grep -c 'LISTEN')" -eq "1" ]]
do portGenerator2 ; done ; } ; portGenerator2 && portCheck2

sed -i 's|"daemon_port":.*,|"daemon_port": '$portGen',|g' ~/.config/deluge2/core.conf
sed -i 's|"port":.*,|"port": '$portGen2',|g' ~/.config/deluge2/web.conf
```

**Running the second instance**  
```
de2 -c ~/.config/deluge2
dew2 --fork -c ~/.config/deluge2
```

### Accessing Deluge Remote GUI
```
printf "$(hostname -f)\n$(whoami)\n$(sed -rn 's/(.*)"daemon_port": (.*),/\2/p' \
~/.config/deluge/core.conf)\n$(sed -rn "s/$(whoami):(.*):(.*)/\1/p" ~/.config/deluge/auth)\n"
printf "$(hostname -f)\n$(whoami)\n$(sed -rn 's/(.*)"daemon_port": (.*),/\2/p' \
~/.config/deluge2/core.conf)\n$(sed -rn "s/$(whoami):(.*):(.*)/\1/p" ~/.config/deluge2/auth)\n"
```











### Install FFmpeg
```
mkdir -p ~/bin
wget -qO ~/ffmpeg.tar.gz https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz
tar xf ~/ffmpeg.tar.gz && cd && rm -rf ffmpeg-*-64bit-static/{manpages,presets,readme.txt}
cp ~/ffmpeg-*-64bit-static/* ~/bin
chmod 700 ~/bin/{ffmpeg,ffprobe,ffmpeg-10bit,qt-faststart}
cd && rm -rf ffmpeg{.tar.gz,-*-64bit-static}
```


### Compile FFmpeg 
```
wget http://ffmpeg.org/releases/ffmpeg-3.4.2.tar.xz
tar xf ffmpeg*.tar.xz
cd ffmpeg-3.4.2
./configure --prefix=$HOME --disable-shared --enable-pic --disable-x86asm #--enable-libbluray
make -j$(nproc)
make install
cd; rm -rf ffmpeg*
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
sed -i "s|base_url + '/t|base_url + '/$(whoami)/t|g" \
~/.local/lib/python2.7/site-packages/transmissionrpc/client.py
```


### Install Aria2
```
wget https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.gz
tar xf aria2-1.33.1.tar.gz && rm -f aria2-1.33.1.tar.gz
cd aria2-1.33.1
./configure --prefix=$HOME
make -j$(nproc) && make install
cd .. && rm -rf aria2-1.33.1

cd ~/www/$(whoami).$(hostname -f)/* 
mkdir -p aria2 ; cd aria2
wget https://github.com/mayswind/AriaNg/releases/download/0.4.0/aria-ng-0.4.0.zip
unzip aria-ng-0.4.0.zip && rm -f aria-ng-0.4.0.zip

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
```


### Install h5ai
```
wget -qO ~/h5ai.zip http://git.io/vEMGv
unzip -qo ~/h5ai.zip -d ~/www/$(whoami).$(hostname -f)/*/
echo -e '<Location ~ "/">\n    DirectoryIndex  index.html  index.php  /_h5ai/public/index.php\n</Location>' \
> ~/.apache2/conf.d/h5ai.conf
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
cd ~/www/$(whoami).$(hostname -a)/*
ln -s ~/bin/0utput 0utput
```

  -------------------
### Some references
https://www.feralhosting.com/wiki  
https://github.com/feralhosting/faqs-cached  

https://github.com/wyjok/FH  
