## zsh For iFeral

```
cd ; chsh -s /usr/bin/zsh
rm -rf ~/.oh-my-zsh .zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget -qO ~/.oh-my-zsh/themes/agnosterzak.zsh-theme \
http://raw.github.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme
```

```
#sed -i '/^ZSH_THEME.*/'d ~/.zshrc
sed -i "s/robbyrussell/agnosterzak/g" ~/.zshrc

cat >> ~/.zshrc <<EOF
#ZSH_THEME="agnoster"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TZ="/usr/share/zoneinfo/Asia/Shanghai"

export PATH=~/iFeral/app:~/bin:~/pip/bin:\$PATH
#export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH
#export TMPDIR=~/tmp

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
alias gclone="git clone --depth=1"
alias scrl="screen -ls"
alias zjpid='ps aux | egrep "$(whoami)|COMMAND" | egrep -v "grep|aux|root"'
alias pid="ps aux | grep -v grep | grep"
alias ios="iostat -d -x -m 1"
alias wangsu='sar -n DEV 1| grep -E "rxkB\/s|txkB\/s|eth0|eth1"'
alias qb300="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.0'"
alias qb301="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.1'"
alias qb302="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.2'"
alias qb303="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.3'"
alias qb304="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.4'"
alias qb305="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.5'"
alias qb306="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.6'"
alias qb307="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.7'"
alias qb308="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.8'"
alias qb309="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.9'"
alias qb310="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.10'"
alias qb3111="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.11.Skip'"
alias qb311="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.11'"
alias qb312="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.12'"
alias qb314="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.14'"
alias qb315="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.15'"
alias qb316="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.3.3.16'"
alias qb400="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.4.0.0'"
alias qb401="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.4.0.1'"
alias qb402="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.4.0.2'"
alias qb403="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.4.0.3'"
alias qb404="screen -dmS qBittorrent /bin/bash -c 'export TMPDIR=~/tmp;export LD_LIBRARY_PATH=~/iFeral/qb:\$LD_LIBRARY_PATH; ~/iFeral/app/qbittorrent-nox.4.0.4'"
alias fenjuan="rar5 a -rr5 -m0 -ma5 -v1983M"
alias killde='kill "$(pgrep -fu "$(whoami)" "deluged")"'
alias killde2='kill "$(pgrep -fu "$(whoami)" "de2")"'
alias killtr='kill "$(pgrep -fu "$(whoami)" "transmission-daemon")"'
alias killrt='kill "$(pgrep -fu "$(whoami)" "/usr/local/bin/rtorrent")"'
alias killqb='kill $(pgrep -fu "$(whoami)" "qbitt")'

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