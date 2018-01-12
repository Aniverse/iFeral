# Feral
> WARNING: DO NOT USE THIS REPO   
> 好吧，其实我就是弄着玩的，也没打算写成脚本  

### Functions
- **安装 qBittorent**  
目前可选的版本为 3.3.11 和 3.3.16  
- **安装 rar 5.50**  
- **安装 Speedtest**  
- **设置 alias**  

### Usage
``` 
cd
wget -O ~/.zshrc https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/config/zshrc
chsh -s /usr/bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget -O ~/.oh-my-zsh/themes/agnosterzak.zsh-theme http://raw.github.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme

git clone --depth=1 https://github.com/Aniverse/Feral
chmod -R +x Feral
mkdir -p tmp private/qbittorrent/{data,watch,torrents}

cat>>~/.zshrc<<EOF

export PATH=~/Feral/app:$PATH
export TMPDIR=~/tmp

alias chongqi='bash ~/Feral/app/restart.sh'
alias shanchu='rm -rf'
alias cesu='echo;python ~/Feral/app/spdtest --share;echo'
alias cesu2='python ~/Feral/app/spdtest --share --server'
alias cesu3="echo;python ~/Feral/app/spdtest --list 2>&1 | head -n30 | grep --color=always -P '(\d+)\.(\d+)\skm|(\d+)(?=\))';echo"
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
alias qb11='export LD_LIBRARY_PATH=~/Feral/app/qbittorrent.3.3.11;nohup ~/Feral/app/qbitorrent-nox.3.3.11 &'
alias qb16='export LD_LIBRARY_PATH=~/Feral/app/qbittorrent.3.3.16;nohup ~/Feral/app/qbitorrent-nox.3.3.16 &'
alias killqb="kill -9 `ps aux | egrep $(whoami) | grep qb | awk '{print $2}'`"
alias fenjuan="rar5 a -rr5 -m0 -ma5 -v1983M"

EOF

source ~/.zshrc

```



export PATH=~/bin/ffmpeg2/bin:$PATH

cd ~/makemkv-oss-1.10.9
./configure --prefix=$HOME/bin

PKG_CONFIG_PATH=~/bin/ffmpeg2/lib/pkgconfig ./configure --prefix=$HOME/bin



cd ~/makemkv-oss-1.10.9



./configure --prefix=$HOME/bin/ffmpeg2 --enable-static --disable-shared --enable-pic --disable-yasm
make -j24
make install DEST_HOME=$HOME


wget -O ffmpeg.tar.gz https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz

mkdir -p ~/bin && bash
wget -qO ~/ffmpeg.tar.gz https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz
tar xf ~/ffmpeg.tar.gz && cd && rm -rf ffmpeg-*-64bit-static/{manpages,presets,readme.txt}
cp ~/ffmpeg-*-64bit-static/* ~/bin
chmod 700 ~/bin/{ffmpeg,ffprobe,ffmpeg-10bit,qt-faststart}
cd && rm -rf ffmpeg{.tar.gz,-*-64bit-static}





### 一些编译安装时的选项
```
./configure --prefix=$HOME/bin
make -j24
make install DEST_HOME=$HOME
echo "PATH=~/bin:$PATH" > ~/.bashrc
source ~/.bashrc
```

### 改变 rTorrent 的版本
```
rtversion="0.9.3_w0.13.3"
rtversion="0.9.6_w0.13.6"
rtversion="0.9.4_w0.13.4"
echo -n "${rtversion}" > ~/private/rtorrent/.version
pkill -fu "$(whoami)" 'SCREEN -S rtorrent'
screen -S rtorrent rtorrent
```

### ruTorrent 升级到 3.8
```
cd ~/www/$(whoami).$(hostname -f)/public_html/
gclone https://github.com/Novik/ruTorrent.git
cp -r rutorrent/conf/* ruTorrent/conf/
cp rutorrent/.ht* ruTorrent/
rm -rf rutorrent/ && mv ruTorrent rutorrent && cd
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




### 改变 Deluge 的版本
DEVERSION=1.3.13
wget -qO ~/deluge-tmp.tar.gz http://download.deluge-torrent.org/source/deluge-"${DEVERSION}".tar.gz
mkdir ~/deluge-tmp && tar xf ~/deluge-tmp.tar.gz  --strip-components=1 -C ~/deluge-tmp && cd ~/deluge-tmp/
python setup.py install --user
cd && rm -rf ~/deluge-tmp*



### 通过 SSH 修改 ruTorrent、Deluge WebUI、qBittorrent WebUI 的密码

ANUSER=$(whoami)
ANPASS=


wget -qO ~/bin/deluge.userpass.py https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/special/deluge.userpass.py
wget -qO ~/bin/qbittorrent.userpass.py https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/special/qbittorrent.userpass.py


sed -i "s/RPCUSERNAME/${ANUSER}/g" /root/.config/transmission-daemon/settings.json
sed -i "s/RPCPASSWORD/${ANPASS}/g" /root/.config/transmission-daemon/settings.json

cp -f "${local_packages}"/template/config/qBittorrent.conf /root/.config/qBittorrent/qBittorrent.conf
cp -f "${local_packages}"/template/systemd/qbittorrent.service /etc/systemd/system/qbittorrent.service

QBPASS=$(python "${local_packages}"/script/special/qbittorrent.userpass.py ${ANPASS})
sed -i "s/SCRIPTUSERNAME/${ANUSER}/g" /root/.config/qBittorrent/qBittorrent.conf
sed -i "s/SCRIPTQBPASS/${QBPASS}/g" /root/.config/qBittorrent/qBittorrent.conf

sed -i 's|"download_location": "$(pwd)/Downloads"|"download_location": "$(pwd)/private/deluge/data"|g' ~/.config/deluge/core.conf
sed -i 's|"autoadd_location": "$(pwd)/Downloads"|"autoadd_location": "$(pwd)/private/deluge/watch"|g' ~/.config/deluge/core.conf




DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DWP=$(python "${local_packages}"/script/special/deluge.userpass.py ${ANPASS} ${DWSALT})
echo "${ANUSER}:${ANPASS}:10" > /root/.config/deluge/auth
sed -i "s/delugeuser/${ANUSER}/g" /root/.config/deluge/core.conf
sed -i "s/DWSALT/${DWSALT}/g" /root/.config/deluge/web.conf
sed -i "s/DWP/${DWP}/g" /root/.config/deluge/web.conf



start
deluged
check running
pgrep -fu "$(whoami)" "deluged"
stop
kill "$(pgrep -fu "$(whoami)" "deluged")"
restart
kill "$(pgrep -fu "$(whoami)" "deluged")" && sleep 3 && deluged
kill (force stop)
kill -9 "$(pgrep -fu "$(whoami)" "deluged")"




BHE4hv8Muchxd8LV


【盒子名称】Feral Hosting Neon SSD (hippolytus)
【盒子类型】共享盒子
【IP】共享 IPv4，无 IPv6
【CPU】Intel Xeon E5 2680 V3 双路，24C48T
【内存】256GB
【硬盘】保证至少 150GB 可用，SSD RAID0
（可以超用但不建议长期这么做）
【网速】共享 20Gbps，无限流量
【软件】
Deluge 1.3.15 / 1.3.13
rTorrent 0.9.6 / 0.9.4 / 0.9.3 with ruTorrent 3.8 ／ flood
qBittorrent 3.3.7 / 3.3.11 / 3.3.16
Transmission 2.84
Flexget
BBR

【技术支持】看心情
【原价】15 英镑
【转租价格】80 RMB（用到 2018.02.01 12:00 UTC+8）

注：不要问我有没有其他盒子可以出租，有的话我会发帖吧的




