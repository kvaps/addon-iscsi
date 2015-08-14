#!/bin/bash

#set -e
#set -x

if [ $# -lt 1 ]
then
	echo "Usage: $0 IMG_ID [VM_ID]"
	exit 1
fi

IMG_ID=$1
VM_ID=$2

echo "Trying to delete redundant image $IMG_ID $VM_ID..."

echo "Sanity checking..."
DS_IMGS=`mktemp`
ZFS_IMGS=`mktemp`
python image-get-datastore-list.py >$DS_IMGS
./image-get-zfs-list.sh >$ZFS_IMGS
PASS=1
if [ -z "$VM_ID" ]
then
	grep "^\<$IMG_ID\>" $DS_IMGS >/dev/null && PASS=0
	IMGS_COUNT=`grep "^\<$IMG_ID\>" $ZFS_IMGS | wc -l`
else
	grep "^\<$IMG_ID $VM_ID\>" $DS_IMGS >/dev/null && PASS=0
	IMGS_COUNT=1
fi

if [ $PASS -eq 0 ]
then
	echo "Image exists in Datastore database, ignoring this delete operation"
	exit 2
fi

DEL_DEP=0
if [ $IMGS_COUNT -gt 1 ]
then
	echo "Image has dependent images:"
	grep "^\<$IMG_ID\> " $ZFS_IMGS
	read -p "Try to remove dependent images? [y/N]" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo YES
		DEL_DEP=1
	else
		echo NO
		exit 3
	fi
fi

echo "Sanity check passed, trying to delete image..."

rm -f $DS_IMGS
rm -f $ZFS_IMGS
