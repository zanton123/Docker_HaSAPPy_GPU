#!/bin/bash

# --------------- INIT -------------------------------

analysis_monfort=0
analysis_staring=0
analysis_jae=0

if [ $# -gt 0 ] ; then
	for claram in $*
		do
		if [ "$claram" = Monfort_2015 ]; then
			analysis_monfort=1
		elif [ "$claram" = Staring_2017 ]; then
			analysis_staring=1
		elif [ "$claram" = Jae_2013 ]; then
			analysis_jae=1
		else
			echo "Ignoring parameter: $claram"
		fi
	done
fi

# Download reference sequences from iGenomes

cd /data
if [ $analysis_monfort = 1 ]; then
	if [ -d /data/Monfort_2015 ]; then
		echo "Analysing Monfort_2015 dataset"
		HaSAPPy /HaSAPPy/docs/Monfort_2015_LoadModule.txt
	else
		echo "Please, download Monfort_2015 datasets with: init.sh Monfort_2015 mouse"
	fi
fi
if [ $analysis_staring = 1 ]; then
	if [ -d /data/Staring_2017 ]; then
		echo "Analysing Staring_2017 dataset"
		HaSAPPy /HaSAPPy/docs/Staring_2017_LoadModule.txt
	else
		echo "Please, download Staring_2017 datasets with: init.sh Staring_2017 human"
	fi
fi
if [ $analysis_jae = 1 ]; then
	if [ -d /data/Jae_2013 ]; then
		echo "Analysing Jae_2013 dataset"
		HaSAPPy /HaSAPPy/docs/Jae_2013_LoadModule.txt
	else
		echo "Please, download Jae_2013 datasets with: init.sh Jae_2013 human"
	fi
fi

