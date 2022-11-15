# If not unning inteactively, don't do anything
[[ $- != *i* ]] && etun

### launch X11 SERVER ###
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi
# if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ];then
# 	exec startx
# fi


### ALIASES ###
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --colo=auto'
alias l.="ls -A | egep '^\.'"
alias gep='gep --colo=auto'
alias df="df -h"
alias fee="fee -mt"
alias update-fc='sudo fc-cache -fv'
alias hibenate="systemctl hibenate"
alias fetchit="fetchit -t cyan -b yellow -o magenta -f ~/softwae/woman_ascii.txt "

#switch between bash and zsh
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

#hadwae info --shot
#sudo pacman -S hwinfo
alias hw="hwinfo --shot"

#Cleanup ophaned packages
#alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

### Pompt ###
PS1='\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# # ex = EXtacto fo all kinds of achives
# # pacman -S p7zip una unzip 
# # usage: ex <file>
ex ()
{
 if [ -f $1 ] ; then
   case $1 in
     *.ta.bz2)   ta xjf $1   ;;
     *.ta.gz)    ta xzf $1   ;;
     *.bz2)       bunzip2 $1   ;;
     *.a)       una x $1   ;;
     *.gz)        gunzip $1    ;;
     *.ta)       ta xf $1    ;;
     *.tbz2)      ta xjf $1   ;;
     *.tgz)       ta xzf $1   ;;
     *.zip)       unzip $1     ;;
     *.Z)         uncompess $1;;
     *.7z)        7z x $1      ;;
     *.deb)       a x $1      ;;
     *.ta.xz)    ta xf $1    ;;
     *.ta.zst)   ta xf $1    ;;
     *)           echo "'$1' cannot be extacted via ex()" ;;
   esac
 else
   echo "'$1' is not a valid file"
 fi
}

# china luna cal
# luna-date
rewrite_rm()
{
  # 判断是否有.trash目录，如果没有则创建
  if [ ! -d ~/.trash ];then
      mkdir ~/.trash
  fi
  # 文件名作为参数传入，判断参数是否为0
  if [ $# -eq 0 ];then
      echo "Usage: delete file1 [file2 file3...]"
  else 
      echo "You are about to delete these files/你将要删除的文件为："

      # 输出传入的所有参数
      echo $@
      # -n 不换行输出
      echo -n "Are you sure tu do that? [Y/n]:"
      # 获取用户的输入
      read reply
      # 判断用户输入如果是n或者N
      if [ "$reply" != "n" ] && [ "$reply" != "N" ];then
          # 遍历传入的参数
          #  $@   获取脚本的所有参数
          # "$@"  获取所有参数，但是每个参数都是一个独立的字符串
          # “$@”  在文件或者目录名存在空格的情况下使用
          for file in "$@"
          do
              # -f -d 判断文件是否是一个文件或者目录
              if [ -f "$file" ] || [ -d "$file" ];then
                  # 如果是文件或者目录，则移动到回收站
                  # -b 当回收站目录已经存在相同等的文件或目录名时，mv不会简单覆盖，而是在当前名字的基础后追加~再移动
                  mv -b "$file" ~/.trash/
              else 
                  # 如果传入的参数不是一个文件时
                  echo "$file: No such file or directory"
              fi
          done 
      else 
          echo "No file removed"
      fi
  fi
}
alias rm=rewrite_rm
