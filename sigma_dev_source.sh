#!/usr/bin/env bash
# sigma_dev_source.sh — helpers for working on code that lives on the "sigma"
# dev server. Source it, don't run it:
#
#   source ~/Development/sz-utils/sigma_dev_source.sh
#
#   sigmadev_mount <dir>           mount sigma:dev/<dir> at ~/dev/sigma_mount/<dir> (sshfs)
#   sigmadev_umount [dir]          unmount one dir, or all of them with no argument
#   sigmadev_sync pull|push <dir>  rsync ~/dev/<dir> from or to the server
#
# "sigma" is a Host entry in ~/.ssh/config. Remote paths are relative to your
# home directory on the server; set SIGMADEV_REMOTE to point somewhere else
# (default: sigma:dev).

SIGMADEV_REMOTE="${SIGMADEV_REMOTE:-sigma:dev}"

sigmadev_mount() {
	if [ -z "$1" ]; then
		echo "Usage: sigmadev_mount <dir>" >&2
		return 2
	fi
	local mount_point="$HOME/dev/sigma_mount/$1"
	mkdir -p "$mount_point"
	sshfs "$SIGMADEV_REMOTE/$1" "$mount_point"
}

sigmadev_umount() {
	if [ -n "$1" ]; then
		umount "$HOME/dev/sigma_mount/$1"
	else
		umount "$HOME"/dev/sigma_mount/*
	fi
}

sigmadev_sync() {
	local operation="$1" dir="$2" src dest
	local local_dir="$HOME/dev/$dir"
	local remote_dir="$SIGMADEV_REMOTE/$dir"

	case "$operation" in
		pull) src="$remote_dir"; dest="$local_dir" ;;
		push) src="$local_dir"; dest="$remote_dir" ;;
		*) dir="" ;;
	esac
	if [ -z "$dir" ]; then
		echo "Usage: sigmadev_sync pull|push <dir>" >&2
		return 2
	fi

	echo "$src -> $dest"
	rsync -aHAXxv --numeric-ids -e "ssh -T -o Compression=no -x" "$src/" "$dest"
}
