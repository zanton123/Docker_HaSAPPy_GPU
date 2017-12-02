#!/bin/bash

# --------------- INIT -------------------------------

build_genome_index_mouse=0
build_genome_index_human=0
analysis_monfort=0
analysis_staring=0
analysis_jae=0

if [ $# -gt 0 ] ; then
	for claram in $*
		do
		if [ "$claram" = human ]; then
			build_genome_index_human=1
		elif [ "$claram" = mouse ]; then
			build_genome_index_mouse=1
		elif [ "$claram" = Monfort_2015 ]; then
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
[ -d reference ] || mkdir reference
cd reference
if [ -d /data/reference/PhiX ]; then
	echo "/data/PhiX genome sequence folder already exists"
else
	echo "Downloading PhiX genome sequence ..."
	wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/PhiX/NCBI/1993-04-28/PhiX_NCBI_1993-04-28.tar.gz && \
		tar -xzf PhiX_NCBI_1993-04-28.tar.gz && \
		rm PhiX_NCBI_1993-04-28.tar.gz
		echo "Building nvBowtie index ..."
		cd PhiX/NCBI/1993-04-28/Sequence && mkdir nvBowtieIndex
		nvBWT WholeGenomeFasta/genome.fa nvBowtieIndex/phiX
cd /data/reference
fi
if [ $build_genome_index_mouse = 1 ]; then
	if [ -d /data/reference/Mus_musculus ]; then
		echo "/data/Mus_musculus genome sequence folder already exists"
	else
		echo "Downloading mouse genome sequence ..."
		echo
		wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Mus_musculus/UCSC/mm10/Mus_musculus_UCSC_mm10.tar.gz && \
			tar -xzf Mus_musculus_UCSC_mm10.tar.gz && \
			rm Mus_musculus_UCSC_mm10.tar.gz
		echo "Building nvBowtie index ..."
		cd Mus_musculus/UCSC/mm10/Sequence && mkdir nvBowtieIndex
		nvBWT WholeGenomeFasta/genome.fa nvBowtieIndex/mm10
	fi
cd /data/reference
fi
if [ $build_genome_index_human = 1 ]; then
	if [ -d /data/reference/Homo_sapiens ]; then
		echo "/data/Homo_sapiens genome sequence folder already exists"
	else
		echo "Downloading human genome sequence ..."
		echo
		wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Homo_sapiens/UCSC/hg38/Homo_sapiens_UCSC_hg38.tar.gz && \
			tar -xzf Homo_sapiens_UCSC_hg38.tar.gz && \
			rm Homo_sapiens_UCSC_hg38.tar.gz
		echo "Building nvBowtie index ..."
		cd Homo_sapiens/UCSC/hg38/Sequence && mkdir nvBowtieIndex
		nvBWT WholeGenomeFasta/genome.fa nvBowtieIndex/hg38
	fi
fi

# Download read datasets from SRA

cd /data
if [ $analysis_monfort = 1 ]; then
	if [ -d /data/Monfort_2015 ]; then
		echo "/data/Monfort_2015 dataset folder already exists"
	else
		echo "Downloading Monfort_2015 datasets ..."
		echo
		cd /data && mkdir Monfort_2015 && cd Monfort_2015 && mkdir unselected && mkdir selected && \
		fastq-dump -O unselected/ --gzip SRR2064917 && \
		fastq-dump -O unselected/ --gzip SRR2064920 && \
		fastq-dump -O unselected/ --gzip SRR2064924 && \
		fastq-dump -O unselected/ --gzip SRR2064927 && \
		fastq-dump -O unselected/ --gzip SRR2064928 && \
		fastq-dump -O unselected/ --gzip SRR2064929 && \
		fastq-dump -O unselected/ --gzip SRR2064930 && \
		fastq-dump -O selected/ --gzip SRR2064886 && \
		fastq-dump -O selected/ --gzip SRR2064896 && \
		fastq-dump -O selected/ --gzip SRR2064898 && \
		fastq-dump -O selected/ --gzip SRR2064899 && \
		fastq-dump -O selected/ --gzip SRR2064902 && \
		fastq-dump -O selected/ --gzip SRR2064905 && \
		fastq-dump -O selected/ --gzip SRR2064908
	fi
fi
if [ $analysis_staring = 1 ]; then
	if [ -d /data/Staring_2017 ]; then
		echo "/data/Staring_2017 dataset folder already exists"
	else
		echo "Downloading Staring_2017 datasets ..."
		echo
		cd /data && mkdir Staring_2017 && cd Staring_2017 && mkdir unselected && mkdir selected
		if [ -e /data/Jae_2013/unselected/SRR663777.fastq.gz ]; then
			cp /data/Jae_2013/unselected/SRR663777.fastq.gz /data/Staring_2017/unselected/
		else
			fastq-dump -O unselected/ --gzip SRR663777
		fi
		fastq-dump -O selected/ --gzip SRR4885982 && \
		fastq-dump -O selected/ --gzip SRR4886610 && \
		fastq-dump -O selected/ --gzip SRR4887274
	fi
fi
if [ $analysis_jae = 1 ]; then
	if [ -d /data/Jae_2013 ]; then
		echo "/data/Jae_2013 dataset folder already exists"
	else
		echo "Downloading Jae_2013 datasets ..."
		echo
		cd /data && mkdir Jae_2013 && cd Jae_2013 && mkdir unselected && mkdir selected
		if [ -e /data/Staring_2017/unselected/SRR663777.fastq.gz ]; then
			cp /data/Staring_2017/unselected/SRR663777.fastq.gz /data/Jae_2013/unselected/
		else
			fastq-dump -O unselected/ --gzip SRR663777
		fi
		fastq-dump -O selected/ --gzip SRR656615
	fi
fi
