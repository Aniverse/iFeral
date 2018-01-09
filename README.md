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
