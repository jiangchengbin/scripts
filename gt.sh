#!/bin/bash -e

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         gt.sh                                          #
# Information:   Simplify git command                           #
# CreateDate:    2011-12-14                                     #
# ModifyDate:    2011-12-14                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################

tagfile=/tmp/.tag
diff_file_date=/tmp/.git_diff_file_date
diff_file=/tmp/.git_diff_file

# get information
get_info(){
	ver=`sed -n 's@^# Version:.*\(v.*\)@\1@p' $0 | cut -c 2-6`
	last_modify=`sed -n 's@^# ModifyDate:.*\(20..-..-..\)@\1@p' $0 | cut -c 1-10`
	tag1=`cat ${tagfile}1`
	tag2=`cat ${tagfile}2`
}

# show information
show_info(){
	echo tag1=$tag1
	echo tag2=$tag2
	echo $last_modify
	echo ver=$ver 
}

# show tags
show_tag(){
	if [ "$@" != ""];then
		git tag | grep $@
	fi
}

# change the tags
change_tags(){
	case $# in
		1 )
			tagfile=${tagfile}$1
			echo "tag$1=`cat $tagfile`"
		;;
		2 )
			cur_tag_file=${tagfile}$1
			echo "set tag$1=$2"
			echo $2 > $cur_tag_file
		;;
		4 )
			# set tag1
			cur_tag_file=${tagfile}$1
			echo "set tag$1=$2"
			echo $2 > $cur_tag_file

			#set tag2
			shift && shift
			change_tags $@
		;;
		* )
			echo change tags error
			exit -1
		;;	
	esac
}

# build the kernel tar file
creat_tar(){
	kernel_dir=linux-$@
	do_command="git archive --format=tar --prefix=$kernel_dir/ HEAD -o ${kernel_dir}.tar"
	echo $do_command
	$do_command && \
	echo "create ${kernel_dir}.tar success!" || \
	exit -1
}

# git diff command
git_diff(){
	do_command="git diff $tag1 $tag2 $@"
	echo $do_command
	$do_command
}

# get diff file
git_diff_file(){
	git_diff $@ > $diff_file_date && \
	grep -e 'diff --git' $diff_file_date > $diff_file  && \
	vim $diff_file
}

# parse command
cmd=$1
get_info
case $cmd in 
	1 | 2 )
		change_tags $@
	;;
	tag )
		show_tag $2	
	;;
	tar )
		creat_tar $2
	;;
	diff )
		shift
		git_diff $@
	;;
	file )
		shift
		git_diff_file $@
	;;
	* )
		show_info 
	;;
esac
