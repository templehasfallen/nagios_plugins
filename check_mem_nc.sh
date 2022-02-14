#!/bin/bash

if [ "$1" = "-w" ] && [ "$2" -gt "0" ] && [ "$3" = "-c" ] && [ "$4" -gt "0" ]; then
	FreeM=`free -m`
        memTotal_m=`echo "$FreeM" |grep Mem |awk '{print $2}'`
        memUsed_m=`echo "$FreeM" |grep Mem |awk '{print $3}'`
        memFree_m=`echo "$FreeM" |grep Mem |awk '{print $4}'`
        memBuffer_m=`echo "$FreeM" |grep Mem |awk '{print $6}'`
        memCache_m=`echo "$FreeM" |grep Mem |awk '{print $7}'`
        memUsedPrc=`echo $((($memUsed_m*100)/$memTotal_m))||cut -d. -f1`
		memWithoutCache=`echo $(((($memUsed_m*100)-($memCache_m*100))/$memTotal_m))||cut -d. -f1`
		memWithoutCachePerc=`echo $(((($memUsed_m*100)-($memCache_m*100))/$memTotal_m))||cut -d. -f1`
        if [ "$memWithoutCachePerc" -ge "$4" ]; then
                echo "Memory: CRITICAL Total: $memTotal_m MB - Used: $memUsed_m MB - $memUsedPrc% used! ($memWithoutCache MB - $memWithoutCachePerc% excluding Cache)|TOTAL=$memTotal_m;;;; USED=$memUsed_m;;;; CACHE=$memCache_m;;;; BUFFER=$memBuffer_m;;;; TOTAL_NC=$memWithoutCache;;;;"
                exit 2
        elif [ "$memWithoutCachePerc" -ge "$2" ]; then
                echo "Memory: WARNING Total: $memTotal_m MB - Used: $memUsed_m MB - $memUsedPrc% used! ($memWithoutCache MB - $memWithoutCachePerc% excluding Cache)|TOTAL=$memTotal_m;;;; USED=$memUsed_m;;;; CACHE=$memCache_m;;;; BUFFER=$memBuffer_m;;;; TOTAL_NC=$memWithoutCache;;;;"
                exit 1
        else
                echo "Memory: OK Total: $memTotal_m MB - Used: $memUsed_m MB - $memUsedPrc% used! ($memWithoutCache MB - $memWithoutCachePerc% excluding Cache)|TOTAL=$memTotal_m;;;; USED=$memUsed_m;;;; CACHE=$memCache_m;;;; BUFFER=$memBuffer_m;;;; TOTAL_NC=$memWithoutCache;;;;"
                exit 0
        fi
else		# If inputs are not as expected, print help. 
	sName="`echo $0|awk -F '/' '{print $NF}'`"
        echo -e "\n\n\t\t### $sName Version 2.1a###\n"
        echo -e "# Usage:\t$sName -w <warnlevel> -c <critlevel>"
        echo -e "\t\t= warnlevel and critlevel is percentage value without %\n"
	echo -e "# This script provides memory usage reporting WITHOUT taking into account cached memory!"
	echo -e "# EXAMPLE:\t/usr/lib64/nagios/plugins/$sName -w 80 -c 90"
        echo -e "\nCopyright (C) 2012 Lukasz Gogolin (lukasz.gogolin@gmail.com), improved by Nestor 2015, improved by TempleHasFallen 2022 (https://github.com/templehasfallen)\n\n"
        exit
fi
