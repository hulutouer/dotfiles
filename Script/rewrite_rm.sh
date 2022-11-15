#!/usr/bin/env bash
rewrite_rm()
{
  if [ ! -d ~/.trash ];then
      mkdir ~/.trash
  fi
  if [ $# -eq 0 ];then
      echo "Usage: delete file1 [file2 file3...]"
  else 
      echo "You are about to delete these files："
      echo $@
      echo -n "Are you sure tu do that? [Y/n]:"
      read reply
      if [ "$reply" != "n" ] && [ "$reply" != "N" ];then
          # 遍历传入的参数
          #  $@   获取脚本的所有参数
          # "$@"  获取所有参数，但是每个参数都是一个独立的字符串
          # “$@”  在文件或者目录名存在空格的情况下使用
          for file in "$@"
          do
              if [ -f "$file" ] || [ -d "$file" ];then
                  # -b 当回收站目录已经存在相同等的文件或目录名时，mv不会简单覆盖，而是在当前名字的基础后追加~再移动
                  mv -b "$file" ~/.trash/
              else 
                  echo "$file: No such file or directory"
              fi
          done 
      else 
          echo "No file removed"
      fi
  fi
}
rewrite_rm
