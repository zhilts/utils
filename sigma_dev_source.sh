#!/usr/bin/env bash

sigmadev_mount () {
	MOUNT_POINT=~/dev/sigma_mount/$1
	mkdir -p $MOUNT_POINT
	sshfs sigma:/home/zhilts/dev/$1 $MOUNT_POINT
}

sigmadev_umount() {
	DIR="*"
	if [ "$1" != "" ]; then
		DIR=$1
	fi
	umount ~/dev/sigma_mount/${DIR}
}

sigmadev_sync() {
	if [ "$2" = "" ]; then
		echo "sigmadev_sync [pull|push] DIR"
		exit 2
	fi
	OPERATION="$1"
	DIR="$2"
	LOCAL="${HOME}/dev/${DIR}"
	REMOTE="sigma:/home/zhilts/dev/${DIR}"
	# mkdir -p ${LOCAL}
	# ssh 

	if [ "${OPERATION}" = "pull" ]; then
		SRC="${REMOTE}"
		DEST="${LOCAL}"
	fi
	if [ "${OPERATION}" = "push" ]; then
		SRC="${LOCAL}"
		DEST="${REMOTE}"
	fi
	echo "${SRC}" "${DEST}"

	rsync -aHAXxv --numeric-ids -e "ssh -T -o Compression=no -x" "${SRC}/" "${DEST}"
	#rsync -rvxPe ssh "${SRC}" "${DEST}"
}