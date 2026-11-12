#!/usr/bin/env bash
# devbox.sh — helpers for working on code that lives on a remote dev server.
# Source it, don't run it:
#
#   source ~/Development/sz-utils/devbox.sh
#
#   devbox_mount <dir>           mount <server>:dev/<dir> at ~/dev/devbox_mount/<dir> (sshfs)
#   devbox_umount [dir]          unmount one dir, or all of them with no argument
#   devbox_sync pull|push <dir>  rsync ~/dev/<dir> from or to the server
#
# The server is a Host entry in ~/.ssh/config. Remote paths are relative to
# your home directory on the server. Set DEVBOX_REMOTE to choose the host and
# folder (default: devbox:dev), e.g. DEVBOX_REMOTE=myserver:projects

DEVBOX_REMOTE="${DEVBOX_REMOTE:-devbox:dev}"

devbox_mount() {
	if [ -z "$1" ]; then
		echo "Usage: devbox_mount <dir>" >&2
		return 2
	fi
	local mount_point="$HOME/dev/devbox_mount/$1"
	mkdir -p "$mount_point"
	sshfs "$DEVBOX_REMOTE/$1" "$mount_point"
}

devbox_umount() {
	if [ -n "$1" ]; then
		umount "$HOME/dev/devbox_mount/$1"
	else
		umount "$HOME"/dev/devbox_mount/*
	fi
}

devbox_sync() {
	local operation="$1" dir="$2" src dest
	local local_dir="$HOME/dev/$dir"
	local remote_dir="$DEVBOX_REMOTE/$dir"

	case "$operation" in
		pull) src="$remote_dir"; dest="$local_dir" ;;
		push) src="$local_dir"; dest="$remote_dir" ;;
		*) dir="" ;;
	esac
	if [ -z "$dir" ]; then
		echo "Usage: devbox_sync pull|push <dir>" >&2
		return 2
	fi

	echo "$src -> $dest"
	rsync -aHAXxv --numeric-ids -e "ssh -T -o Compression=no -x" "$src/" "$dest"
}
