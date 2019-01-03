FROM lsiobase/ubuntu:bionic

ENV DEBIAN_FRONTEND="noninteractive"

# copy patches
COPY patches/ /defaults/patches/

RUN \
 echo "**** install runtime packages ****" && \
 echo "deb [trusted=yes] https://dl.bintray.com/pyroscope/rtorrent-ps /" | tee -a /etc/apt/sources.list && \
 apt-get update && \
 apt-get install -y \
	git \
	python \
	python-dev \
	python-pip \
	python-pkg-resources \
	python-setuptools \
	python-virtualenv \
	rtorrent-ps \
	screen && \
 ln -s /opt/rtorrent/bin/rtorrent /usr/bin/rtorrent

# install pyroscope command line utilities
RUN \
 echo "*** install pyroscope cli utilities ****" && \
 mkdir -p ~/bin ~/.local && \
 git clone "https://github.com/pyroscope/pyrocore.git" ~/.local/pyroscope && \
 git clone "https://github.com/pyroscope/pyrobase.git" ~/.local/pyroscope/pyrobase && \
 git clone "https://github.com/pyroscope/auvyon.git" ~/.local/pyroscope/auvyon && \
 cd ~/.local/pyroscope && \
 git apply /defaults/patches/pyro.patch && \
 ~/.local/pyroscope/update-to-head.sh && \
 ln -s ~/bin/* /usr/bin

RUN \
 echo "**** cleanup ****" && \
 apt-get purge -y \
	build-essential \
	git \
	python-dev \
	python-pip \
	python-pkg-resources \
	python-setuptools && \
 apt-get autoremove -y && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

ENV PYRO_CONFIG_DIR="/config/rtorrent/pyroscope"
