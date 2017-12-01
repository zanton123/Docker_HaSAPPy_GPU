#!/bin/bash

# --------------- WELCOME -------------------------------

echo
echo 'Welcome to an interactive session of Docker HaSAPPy:Ubuntu 14.04'
echo '------------------------------------------------------------------'
echo
echo 'This container runs HaSAPPy interactively using NVIDIA docker GPU'
echo 'support. Data input and output is exchanged with the host through'
echo 'the /data folder, which should be maped to an external volume with'
echo
echo ' docker run --runtime=nvidia -it -v <DATA PATH>:/data zanton123/hasappy:GPU'
echo
echo 'This will use <DATA PATH> as a local work directory on your system.'
echo 'A large amount of data will be downloaded. Set aside at least'
echo '200 GB of disk space to avoid running out of space.'
echo
echo 'We advise not to mount the docker image storage on the disk'
echo 'containing the root file system but symlink /var/lib/docker to a'
echo 'separate large hard disk to prevent the root file system to run out'
echo 'of space. For convenience a script is copied to <DATA PATH> for'
echo 'cleaning up docker images and containers. Use cleanup-docker.sh'
echo 'when running out of critical disk space.'
echo 
echo 'An init.sh script is available to download the data and initialize'
echo 'the reference genome indexes. The script allows to select which'
echo 'downloads are required to keep the bandwidth manageable.'
echo
echo 'Usage:'
echo '    init.sh [mouse] [human] [Monfort_2015] [Jae_2013] [Staring_2017]'
echo
echo 'For setting up HaSAPPy for the mouse or human genome use:'
echo '    mouse'
echo '    human'
echo
echo 'For reanalysing datasets associated with a published study use:'
echo '    Monfort_2015'
echo '    Jae_2013'
echo '    Staring_2017'
echo
echo 'All functionality of HaSAPPy can then be used interactively using'
echo '/data as the <DATA PATH> to store your experimental input data and'
echo 'retrieve output of the analysis.'
echo 
echo 'HaSAPPy source code and tutorial are available from:'
echo
echo '    https://github.com/gdiminin/HaSAPPy'
echo
[ -f /data/cleanup-docker.sh ] || { [ -f /cleanup-docker.sh ] && mv /cleanup-docker.sh /data/ ; }


