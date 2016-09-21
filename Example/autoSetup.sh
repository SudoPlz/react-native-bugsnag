#!/bin/bash

INFO_PLIST_MATCH_REG='\*\*\* Your bugsnag API key \*\*\*/'
BUGSNAG_ID_LEN=32


curdir=`pwd`

#install npm modules
npm i




cd ios

#install Pods
pod install

#Read bugsnag id
read -p "<Please paste your bugsnag id here> : " BUSNAG_ID;
#Get the length of the id
size=${#BUSNAG_ID} 

#If the size is correct
if [ "$size" == $BUGSNAG_ID_LEN ]; then
   	echo "BUGSNAG ID correct"
   	
   	#Look for the default string
	grep -F '*** Your bugsnag API key ***' Example/Info.plist -q
	if [ "$?" == 0 ]; then
		echo "Now replacing *** Your bugsnag API key *** with $BUSNAG_ID within the Example/Info.plist file."
		#Replace for the default string with the user bugsnag id
		sed -i.bak "s/$INFO_PLIST_MATCH_REG$BUSNAG_ID/" Example/Info.plist
		if [ "$?" == 0 ]; then
			sleep 1
			#Open the xcode workspace
			open Example.xcworkspace
			echo "You are ready to roll. Hit Run on Xcode."
			cd $curdir
		else
			echo "Unable to replace with your bugsnag key, please edit Example/Info.plist manually."
			cd $curdir
		fi
	else
		echo "Could not replace with bugsnag key. Terminating"
		cd $curdir
	fi

else
	echo "BUGSNAG ID incorrect. Its length should be $BUGSNAG_ID_LEN characters. Nothing done."
	cd $curdir
fi