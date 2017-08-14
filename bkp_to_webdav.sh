#!/bin/sh
# version 2.0

# SETTINGS
date=$(date "+%Y%m%d")
time=$(date "+%H%M%S")
root=~/

# Target for backup
src=EDU

archive_name=$src\_$date\_$time
webdav_path=https://webdav.yandex.ua/Backups
volume_name=WEBDAV_YANDEX

delete_local_backup=false
# End SETTINGS


# SCRIPT
printf "\e[43;30m ## $src BACKUPPER ## \e[0m\n"
pushd $root &> /dev/null

if [ ! -d $volume_name ]; then 
	mkdir $volume_name
fi
diskutil unmountDisk force $volume_name &> /dev/null

printf "\e[33m## Mounting to $webdav_path...\e[0m\n"
printf "\e[34m\nLogin to $webdav_path:\e[0m\n"
if mount_webdav -i -s $webdav_path $volume_name; then
	printf "\n\e[32m## Mounting successful\e[0m\n"
	
	mv $src $archive_name
	printf "\e[33m## Archiving $src to $archive_name.zip...\e[0m\n"
	if zip -rXv $archive_name.zip $archive_name &> /dev/null; then
		printf "\e[32m## $src archived\e[0m\n"
	else
		printf "\e[31m## $src not archived\e[0m\n"
	fi
	mv $archive_name $src
	total_size=$(du -hs $archive_name.zip)
	
	printf "\e[34m## Total files size: $total_size\e[0m\n"
	printf "\e[33m## Copying files to $volume_name...\e[0m\n"
	if cp -v $archive_name.zip $volume_name &> /dev/null; then
		printf "\e[32m## Сopying successful\e[0m\n"
	else
		printf "\e[31m## Сopying not successful\e[0m\n"
	fi

	if $delete_local_backup; then
		printf "\e[33m## Removing local backup $archive_name.zip...\e[0m\n"
		if rm -r $archive_name.zip; then
			printf "\e[32m## Local backup removed\e[0m\n"
		else
			printf "\e[31m## Local backup not removed\e[0m\n"
		fi
	fi

	printf "\e[33m## Unmounting $volume_name...\e[0m\n"
	if diskutil unmountDisk force $volume_name &> /dev/null; then
		printf "\e[32m## Unmount successful\e[0m\n"
	else
		printf "\e[31m## Unmount not successful\e[0m\n"
	fi
else
	printf "\n\e[31m## Mounting failed\e[0m\n"
fi
rm -rf $volume_name

popd &> /dev/null
# End SCRIPT
