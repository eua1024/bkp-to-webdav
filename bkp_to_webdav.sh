#!/bin/sh

# DATA
date=$(date "+%Y%m%d")
time=$(date "+%H%M%S")
root=~/

#Target for backup
src=EDU

archive_name=$src\_$date\_$time
webdav_path=https://webdav.yandex.ua/Backups
volume_name=WEBDAV_YANDEX
# End DATA


# SCRIPT
pushd $root

if [ ! -d $volume_name ]; then 
	mkdir $volume_name
fi
diskutil unmountDisk force $volume_name &> /dev/null

echo "\nLogin to $webdav_path:"
if mount_webdav -i -s $webdav_path $volume_name; then
	echo "## Mount successful for $volume_name"
	
	mv $src $archive_name
	zip -rXv $archive_name.zip $archive_name
	mv $archive_name $src
	total_size=$(du -hs $archive_name.zip)
	
	echo "## Total files size: $total_size"
	echo "## Copying files to $volume_name..."
	if cp -v $archive_name.zip $volume_name; then
		echo "## Сopying to $volume_name successful"
	else
		echo "## Сopying to $volume_name not successful"
	fi
	rm -rf $archive_name.zip

	diskutil unmountDisk force $volume_name
else
	echo "## Mount failed for $volume_name"
fi
rm -rf $volume_name

popd
# End SCRIPT