#!/bin/bash

mcdir=/home/minecraft/test
name=test
jar=server.jar
mem=1024
mcver=1.16.4
buildurl="https://papermc.io/api/v1/paper/$mcver/latest"

dlurl="$buildurl/download"
updir=$mcdir/update

if [ ! -d "$updir" ]; then
	mkdir -p $updir
	touch $mcdir/oldver.txt $updir/newver.txt
fi

yn=n

startsrv(){
	if test -f "$mcdir/$jar"; then
		screen -dmS $name bash -c \
		"cd '$mcdir' && \
		java -Xmx'$mem'M -Xms'$mem'M -jar '$jar' nogui"
		echo $name started
	else
		read -p "server jar not found, download now? [y/N]" yn
		case $yn in
			[Yy]*) echo setting up $name...; update ;; 
			[Nn]*) exit ;;
		esac
	fi
}

stopsrv(){
	screen -S $name -X stuff $'stop\n'
	echo stopping $name...
	while screen -ls | grep -q $name
		do
			sleep 5
		done
	echo $name stopped
}

update(){
	oldver=$(cat $updir/newver.txt)
	newver=$(curl -s ${buildurl} | sed 's/^.*"build"://; s/}.*$//')
	if [[ $newver != $oldver ]]; then
		wget -N ${dlurl} -O ${updir}/${jar} --no-cache
		echo -n $newver > $updir/newver.txt
		echo downloaded server jar, stored in $updir
		read -p "install now? [y/N]" yn
		case $yn in
			[Yy]*) echo installing $name...; upgrade ;; 
			[Nn]*) exit ;;
		esac
	else
		echo no newer version available
	fi
}

upgrade(){
	oldver=$(cat $mcdir/oldver.txt)
	newver=$(cat $updir/newver.txt)
	if ! screen -ls | grep -q $name; then
		if [[ $newver != $oldver ]]; then
			mv $updir/$jar $mcdir
			echo -n $newver > $mcdir/oldver.txt
			echo installed jar
			read -p "start server now? [y/N]" yn
			case $yn in
				[Yy]*) startsrv ;; 
				[Nn]*) exit ;;
			esac
		else
			echo no upgrade available, try update
		fi
	else
		read -p "server is running, stop and upgrade? [y/N]" yn
		case $yn in
			[Yy]*) stopsrv && upgrade ;;
			[Nn]*) exit ;;
		esac
	fi
}

if [ $1 == 'start' ]; then
	startsrv
elif [ $1 == 'stop' ]; then
	stopsrv
elif [ $1 == 'restart' ]; then
	stopsrv &&
	startsrv
elif [ $1 == 'update' ]; then
	$1
elif [ $1 == 'upgrade' ]; then
	$1
else
	echo unknown argument $1
fi