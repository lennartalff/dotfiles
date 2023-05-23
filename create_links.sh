#!/usr/bin/env bash

FILE_PATH=$(readlink -f "$0")
REPO_DIR=$(dirname "$FILE_PATH")
BACKUP_DIR="$REPO_DIR/backup"

files=($(find $REPO_DIR/home/ -type f))
for file in ${files[@]}
do
	file_base=$(basename -- "$file")
	dest=$HOME/$file_base
	if [ -L "$dest" ]; then
		if [ ! -e "$dest" ];then
			echo "Remove broken link: $dest"
			rm "$dest"
		else
			echo "Already installed: $dest"
			continue
		fi
	elif [ -e "$dest" ]; then
		echo "Skipping already existing file, please remove manually: $dest"
		continue
	fi
	ln -sv $file $dest
done

files=($(find "$REPO_DIR/.config" -mindepth 1 -maxdepth 1 -type d))
for file in ${files[@]}
do
	base=$(basename -- "$file")
	dest="$HOME/.config/$base"
	if [ -L "$dest" ];then
		if [ ! -e "$dest" ];then
			echo "Remove broken link: $dest"
			rm "$dest"
		else
			echo "Already installed: $dest"
			continue
		fi
	elif [ -e "$dest" ]; then
		echo "Already exstis: $dest"
		echo "Backing up..."
		mv "$dest" "$BACKUP_DIR/"
	fi
	ln -sv $file $dest
done
