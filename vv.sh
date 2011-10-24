#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         vv.sh                                          #
# Information:   Simple Command                                 #
# Create Date:   2011-09-05                                     #
# Modify Date:   2011-10-24                                     #
# Version:       v1.5                                           #
#                                                               #
#################################################################

#deal with user input  command
case $1 in
	"" )
		lftp preload:preload@192.168.1.26:/users/joe
		;;
	lftp )
		lftp preload:preload@192.168.1.$2
		;;
	ss )
		sudo ssh root@192.168.1.$2
		;;
	ba )
		if [ $2"x" == "x" ];then
			touch ~/.old_spec
			old_spec=`cat ~/.old_spec`
			rpmbuild -ba $old_spec --target=i586
		else
			rpmbuild -ba $2 --target=i586 
		fi
		;;
	bp )
		if [ $2"x" == "x" ];then
			touch ~/.old_spec
			old_spec=`cat ~/.old_spec`
			rpmbuild -bp $old_spec --target=i586
		else
			rpmbuild -bp $2 --target=i586
		fi
		;;
	push )
		if [ $2"x" == "specx" ];then
			pwd=`pwd`
			echo ${pwd}"/"$3 >  ~/.old_spec
		fi
		;;
	git )
		if [ "$2" == "push" ];then
			sudo git push -u origin master
		elif [ "$2" == "remote" ]; then
			if [ "$3" == "" ];then
				project="scripts"	
			else
				project="$3"
			fi
			echo git remote add origin git@github.com:jiangchengbin/${project}.git
			git remote add origin git@github.com:jiangchengbin/${project}.git
		fi
		;;
	vim )
		if [ $2"x" == "specx" ];then
			touch ~/.old_spec
			old_spec=`cat ~/.old_spec`
			cp $old_spec $old_spec.bk -f
			vim $old_spec
		fi
		;;
	diff )
		if [ $4"x" == "bz2x" ];then
			touch $3.bz2
			mv $3.bz2 $3.bz2.bk -f
			diff $2.bk $2 -ruN > $3
			bzip2 $3  
		else
			touch $3
			cp $3 $3.bk -rf
			diff $2.bk $2 -ruN > $3
		fi
		;;
	scp )
		if [ $# -eq 4 ];then
			scp $2 root@192.168.1.$3:$4
		elif [ $# -gt 4 ];then
			eval last='$'{$#}
			n=$(expr $# - 1)
			eval last_second='$'{$n}
			n=$(expr $n - 1)
			file=`echo $@ | cut -d" " -f 2-$n`
			scp $file root@192.168.1.$last_second:$last
		elif [ $# -eq 3 ];then
			scp ~/rpmbuild/RPMS/i586/* root@192.168.1.$2:$3
		fi
    	;;
	mount )
		sudo curlftpfs -o user=preload:preload,allow_other,rw ftp://192.168.1.26 /ftp
		;;
	clean )
		if [ $2"x" == "rpmx" -o $2"x" == "rpmsx" ];then
			rm -rf ~/rpmbuild/RPMS/i586/* 
		fi
		;;
	date )
		LANG=en_US date
		;;
	* )
		echo "输入参数不正确！"
		;;
esac
