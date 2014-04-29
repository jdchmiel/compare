#!/bin/bash
set -x

function isInt() {
	if [ $# == 1 ] && [[ $1 =~ ^[0-9]*$ ]]; then
		return 0
	fi
	return 1
}

# start Xvfb with specified display number, store the pid and display num for cleanup
function startXvfb() {
	if isInt $1; then
		Xvfb :$1 -screen 0 1024x768x24 &
		XvfbPids[$1]=$!
	else
		echo "startXvfb(): must supply a screen buffer integer\r"
		exit 1
	fi
}

function killXvfb() {
	if isInt $1; then
		#pid=ps aux | grep "[X]vfb :17" | awk '{print $2}'
		echo -n "killing display $1 with pid of ${XvfbPids[$1]}\r"
		kill ${XvfbPids[${1}]}
	else
		echo "killXvfb(): must supply a screen buffer integer\r"
		exit 1
	fi
}

function killFirefox() {
	if isInt $1; then
		#pid=ps aux | grep "firefox" | awk '{print $2}'
		echo -n "killing firefox on display $1 with pid of ${ffPids[$1]}\r"
		kill ${ffPids[${1}]}
	else
		echo "killXvfb(): must supply a screen buffer integer\r"
		exit 1
	fi
}

# todo change this to short circuit when I figure out the NOT operator
function startFirefox() {
	if isInt $1; then
		firefox &
		ffPids[${1}]=$!
	else
		echo "startFireFox(): must supply a screen buffer integer\r"
		exit 1
	fi
}

function firefoxUrl() {
	if [ $# == 2 ] && isInt $1; then
		firefox -remote "openFile(${2})" &
	else
		echo "firefoxUrl(): Must supply a screen buffer integer and a url\r"
		exit 1
	fi
}

function screenShot() {
	if [ $# == 2 ] && isInt $1; then
		import -window root $2 &
	else
		echo "screenShot(): must supply a screen buffer integer and image file name\r"
		exit 1
	fi
}



if [ $# == 0 ]; then
	echo "Usage:"
	echo "param1: first folder, source or master record."
	echo "param2: second folder, unknown domain to compare to master"
	echo "param3: third folder, to store output images and maybe movies"
	exit 1
fi
if [[ $# < 3 ]]; then
	echo "Missing params. for usage instructions try with no params, ie: ./vc.sh"
	exit 1
fi

folderA=$1
folderB=$2
folderC=$3

mkdir ${folderC}

export DISPLAY=:17
virtScreen=17
startXvfb ${virtScreen}
sleep 3
startFirefox ${virtScreen}
sleep 3

cd ${folderA}
for fileName in *; do
	firefoxUrl ${virtScreen} "file://${folderA}/${fileName}"
	sleep 1
echo "${fileName}"
	screenShot ${virtScreen} "${folderC}/${fileName}.png"
done

cd ${folderB}
for fileName in *; do
	firefoxUrl ${virtScreen} "file://${folderB}/${fileName}"
	sleep 1
	screenShot ${virtScreen} "${folderC}/${fileName}_B.png"
done

killXvfb ${virtScreen}
killFirefox ${virtScreen}
export DISPLAY=:0

cd ${folderA}
for fileName in *; do
	compare "${folderC}/${fileName}.png" "${folderC}/${fileName}_B.png" "${folderC}/${fileName}_C.png"
done


# this is suspect - redirect to facebook ???
# testbod_htmlCon_Zu4ee
