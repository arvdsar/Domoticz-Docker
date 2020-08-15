FROM debian:buster
LABEL maintainer = "Alexander van der Sar"

#based on the install steps described in Domoticz WiKi
#OpenZwave v1.6 included
#My purpose is to run this on my Synology NAS

RUN apt-get update && apt-get install -yq \
		make \
	 	gcc \
	 	g++ \
	 	libssl-dev \
	 	git \
	 	libcurl4-gnutls-dev \
	 	libusb-dev \
	 	python3-dev \
	 	zlib1g-dev \
	 	libcereal-dev \
	 	liblua5.3-dev \
	 	uthash-dev \
	 	wget\
	 && \
	 apt remove --purge --auto-remove cmake

RUN 	wget https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0.tar.gz && \
		tar -xzvf cmake-3.17.0.tar.gz &&\
		rm cmake-3.17.0.tar.gz &&\
		cd cmake-3.17.0 &&\
		./bootstrap &&\
		make &&\
		make install &&\
		cd .. &&\
		rm -Rf cmake-3.17.0 &&\
		apt remove --purge --auto-remove libboost-dev libboost-thread-dev libboost-system-dev libboost-atomic-dev libboost-regex-dev libboost-chrono-dev

RUN mkdir boost &&\
		cd boost &&\
		wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz &&\
		tar xfz boost_1_72_0.tar.gz &&\
		cd boost_1_72_0/ &&\
		./bootstrap.sh &&\
		./b2 stage threading=multi link=static --with-thread --with-system &&\
		./b2 install threading=multi link=static --with-thread --with-system &&\
		cd ../../ &&\
		rm -Rf boost/ 

RUN		git clone https://github.com/OpenZwave/open-zwave open-zwave-read-only &&\
		cd open-zwave-read-only &&\
		git pull &&\
		make &&\
		make install &&\
		cd ..

RUN		git clone https://github.com/domoticz/domoticz.git dev-domoticz &&\
		cd dev-domoticz &&\
		git pull &&\
		cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt &&\
		make 

RUN 		apt-get install python3-pip &&\
		pip3 install requests paramiko &&\
		cd /dev-domoticz/plugins &&\
		git clone https://github.com/d-EScape/Domoticz_iDetect.git iDetect &&\
		git clone https://github.com/Xorfor/Domoticz-Pi-hole-Plugin.git &&\
		git clone https://github.com/akamming/domoticz-coronadashboard.git &&\
		git clone https://github.com/lolautruche/SurveillanceStationDomoticz.git &&\
		git clone https://github.com/ycahome/MeteoAlarmEU.git &&\
		git clone https://github.com/Xorfor/Domoticz-LastDutchEarthquake-Plugin.git



RUN cd /
WORKDIR /dev-domoticz

RUN chmod +x ./domoticz
VOLUME /config

EXPOSE 8080

ENTRYPOINT ["/dev-domoticz/domoticz", "-dbase", "/config/domoticz.db", "-log", "/config/domoticz.log"]
CMD ["-www", "8080"]


