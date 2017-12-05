FROM nvidia/cuda:6.5-runtime-ubuntu14.04
LABEL source "HaSAPPy:GPU"

# Usage:
#       xhost +local:root
#       sudo docker run --runtime=nvidia -it -v <DATA PATH>:/data -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY zanton123/hasappy:GPU
#       xhost -

# <DATA PATH> is maped as volume into the container as /data folder for storage of genome and experimental datasets

RUN mkdir data

RUN apt-get update && apt-get install -y --no-install-recommends \
		ubuntu-desktop \
		build-essential cmake git \
		wget \
		python-dev python-numpy python-matplotlib python-scipy \
		python-sklearn python-pandas python-xlsxwriter \
		cython \
		idle \
		zlib1g-dev liblzma-dev libbz2-dev \
		python-pip
RUN pip install --upgrade pip && \
		pip install HTSeq


# Get bowtie2, unpack, and install into /usr/local/bin

RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.3.1/bowtie2-2.3.3.1-linux-x86_64.zip && \
		unzip bowtie2-2.3.3.1-linux-x86_64.zip && \
		mv bowtie2-2.3.3.1-linux-x86_64/ bowtie2/ && \
		rm bowtie2-2.3.3.1-linux-x86_64.zip
ENV PATH ${PATH}:/bowtie2

# Get NextGenMap source, build, and install into /usr/local/bin including openCL driver libs

RUN wget http://github.com/Cibiv/NextGenMap/archive/0.5.0.tar.gz && \
		tar -xzf 0.5.0.tar.gz && \
		mv NextGenMap-0.5.0/ NextGenMap/ && \
		rm 0.5.0.tar.gz && \
		cd NextGenMap && mkdir -p build && cd build && \
		cmake .. && make && \
		cp -r ../bin/ngm-0.5.0/* /usr/local/bin/ && \
		cd / && \
		rm -rf NextGenMap


# Copy nvBowtie and nvBWT executables to /usr/local/bin/

COPY nvBowtie /usr/local/bin/
COPY nvBWT /usr/local/bin/

# Get SRA Tooklit from NCBI

RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2-1/sratoolkit.2.8.2-1-ubuntu64.tar.gz && \
		tar -zxf sratoolkit.2.8.2-1-ubuntu64.tar.gz && \
		rm sratoolkit.2.8.2-1-ubuntu64.tar.gz
ENV PATH ${PATH}:/sratoolkit.2.8.2-1-ubuntu64/bin
# ENV PYTHONPATH /HaSAPPy/HaSAPPy

# Get HaSAPPy from github repository

RUN cd / && \
		git clone https://github.com/gdiminin/HaSAPPy.git && \
		cd /HaSAPPy/HaSAPPy && \
		chmod +x PreprocessReads && \
		cp HaSAPPY.py HaSAPPy && \
		chmod +x HaSAPPy && \
		cp GeneReference_built.py GeneReference_built && \
		chmod +x GeneReference_built

# Update to the latest version of PreprocessReads (GPU) by overwriting old version

COPY PreprocessReads /HaSAPPy/HaSAPPy/
RUN chmod +x /usr/local/bin/PreprocessReads && \
		cp PreprocessReads /usr/local/bin/

# Install HaSAPPy modules

RUN cd /HaSAPPy && \
		python setup.py install

ENV PATH ${PATH}:/HaSAPPy/HaSAPPy

# Generate annotation databases
RUN python /HaSAPPy/HaSAPPy/GeneReference_built.py -i /HaSAPPy/docs/mm10_REFSEQgenes.txt -o /HaSAPPy/docs/GeneReference_Mouse-MM10.pkl
RUN python /HaSAPPy/HaSAPPy/GeneReference_built.py -i  /HaSAPPy/docs/hg38_REFSEQgenes.txt -o /HaSAPPy/docs/GeneReference_Homo-HG38.pkl


# Cleanup docker image

RUN apt-get purge -y --auto-remove build-essential cmake git && \
		rm -rf /var/lib/apt/lists/*

COPY cleanup-docker.sh /
COPY init.sh /usr/local/bin/
COPY analyse.sh /usr/local/bin/
COPY .bashrc /root/
COPY Monfort_2015_LoadModule.txt /HaSAPPy/docs
COPY Jae_2013_LoadModule.txt /HaSAPPy/docs
COPY Staring_2017_LoadModule.txt /HaSAPPy/docs
RUN chmod +x /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/analyse.sh
RUN chmod +x /usr/local/bin/nvBowtie
RUN chmod +x /usr/local/bin/nvBWT

CMD bash
