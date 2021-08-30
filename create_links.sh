#!/usr/bin/env bash

FILE_PATH=$(readlink -f "$0")
REPO_DIR=$(dirname "$FILE_PATH")
BACKUP_DIR="$REPO_DIR/backup"
mkdir -p "$BACKUP_DIR"
FILE_DST=("$HOME/.zshrc" "$HOME/.vimrc" "$HOME/.gitconfig")

for f_out in "${FILE_DST[@]}"
do
	FNAME="$(basename -- $f_out)"
	F_SRC="$REPO_DIR/$FNAME"
	if [ -f $f_out ] && [ ! -L "$f_out" ]; then
		echo "Replacing '$f_out' with symlink."
		i=0
		F_BACKUP_BASE="$BACKUP_DIR/$FNAME"
		F_BACKUP=$F_BACKUP_BASE
		while [ -e "$F_BACKUP" ]; do
			printf -v F_BACKUP '%s.backup%04d' "$F_BACKUP_BASE" "$(( i++ ))"
		done
		echo "Moving '$f_out' to '$F_BACKUP'"
		mv "$f_out" "$F_BACKUP"
		ln -sv "$F_SRC" "$f_out"
	else
		echo "$f_out does not exist as regular file."
		if [ -e "$f_out" ]; then
			echo "There is already a symlink for $f_out. Skipping..."
		else
			ln -sv "$F_SRC" "$f_out"
		fi
	fi
done
