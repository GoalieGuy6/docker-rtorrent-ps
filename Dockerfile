FROM lsiobase/ubuntu:bionic

ENV DEBIAN_FRONTEND="noninteractive"

# copy patches
COPY patches/ /defaults/patches/

RUN \
 echo "**** install runtime packages ****" && \
 echo "deb [trusted=yes] https://dl.bintray.com/pyroscope/rtorrent-ps /" | tee -a /etc/apt/sources.list && \
 apt-get update && \
 apt-get install -y \
	rtorrent-ps \
	screen && \
 ln -s /opt/rtorrent/bin/rtorrent /usr/bin/rtorrent && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /downloads
