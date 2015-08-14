#!/bin/bash

ZFS_IMAGES=`mktemp`
DS_IMAGES=`mktemp`

if [ -z "$ZFS_IMAGES" ] || [ -z "$DS_IMAGES" ]
then
	echo "Failed to create temp files"
	rm -f $ZFS_IMAGES 2>/dev/null
	rm -f $DS_IMAGES 2>/dev/null
fi

./image-get-zfs-list.sh | sort > $ZFS_IMAGES
python image-get-datastore-list.py | sort > $DS_IMAGES

echo "Missing images (only exist in Datastore DB, missing in ZFS) [IMG_ID VMID]:"
diff $DS_IMAGES $ZFS_IMAGES | grep "^<" | sed 's/< //'

echo
echo "Redundant images (not exist in Datastore DB, only exist in ZFS) [IMG_ID VMID]:"
diff $DS_IMAGES $ZFS_IMAGES | grep "^>" | sed 's/> //'


rm -f $ZFS_IMAGES 2>/dev/null
rm -f $DS_IMAGES 2>/dev/null
