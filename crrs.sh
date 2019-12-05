#!/bin/bash
# crrs.sh
# GNU General Public License v3.0
# Collate file directories automatically and remove old folders to release space
# lixin@xs.ustb.edu.cn
# University of Science and Technology Beijing
# Github: lixin555
echo "Start to analyse the information of directories."
datetype=()
num=0
maxn=$(ls -l /home/dell/video/ |grep "^-"|wc -l)
for i in /home/dell/video/*
do
    ((num++))
    a=$(ls $i -l | awk '{print $1}')""
    if [ ${a:0:1} == '-' ];then
        dltime=$(ls $i --full-time | awk '{print $6}')""
        isexist='n'
        for element in ${datetype[@]}
        do
            if [ $dltime == $element ];then
                isexist='y'
                break
            fi
        done      
    fi
    if [ $isexist == 'n' ];then
            datetype=(${datetype[@]} $dltime)
    fi
    echo "Finished: $num, Total: $maxn."
done
echo "Done!!! Next Step~"
echo "Start to create directores."
#create directories
for i in ${datetype[@]}
do
    mkdir /home/dell/video/$i
done
echo "Done!!! Next Step~"
echo "Start transfer files to new folders."
#move files into directories
for i in ${datetype[@]}
do
    for j in /home/dell/video/*
    do
        a=$(ls $j -l | awk '{print $1}')""
        if [ ${a:0:1} == '-' ];then
            dltime=$(ls $j --full-time | awk '{print $6}')""
            if [ "$i" == "$dltime" ];then
                mv -f $j /home/dell/video/$i/
            fi
        fi
    done
    echo "move $i"
done
echo "Done!!! Next Step~"
#delete folders
echo "Start to delete folders."
ctime=$(date +%Y-%m-%d --date="-1 month")
for i in /home/dell/video/*
do
	if [ "$i" == "/home/dell/video/$ctime" ];then 
		rm -rf $i
		echo $i >> /home/dell/log_videotest
	fi
done
echo "All Done!!!"