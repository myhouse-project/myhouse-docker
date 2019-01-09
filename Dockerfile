# import from Rasbpian Jessie
FROM raspbian/jessie

# define metadata
LABEL com.myhouse-project.version="2.4"

# Set the working dir
WORKDIR /build

# Install required packages with apt
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get install -y \
  redis-server \
  python-dev \
  python-flask \
  python-redis \
  python-numpy \
  python-rpi.gpio \
  libttspico-utils \
  python-opencv \
  mpg123 \
  sox \
  flac \
  pocketsphinx \
  python-feedparser \
  python-serial \
  screen \
  unzip \
  python-pip \
  libtool \
  libusb-1.0.0-dev \
  librtlsdr-dev \
  rtl-sdr \
  build-essential \
  autoconf \
  cmake \
  pkg-config \
  bluez \
  alsa-utils \
  usbutils \
  net-tools \
  pulseaudio-module-bluetooth  \
  bluetooth \
  bluez-tools \
  expect \
  rsyslog \
  openssh-server \
  qemu-user-static \
  less \
  curl \
  raspi-config \
  raspi-gpio \
  wiringpi \
  libraspberrypi-bin \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install required python packages with pip
RUN pip install setuptools --upgrade \
  && pip install \
  APScheduler==3.3.1 \
  slackclient==1.0.2 \
  simplejson==3.8.2 \
  python-Levenshtein==0.12.0 \
  fuzzywuzzy==0.11.1 \
  pyicloud==0.9.1 \
  motionless==1.2 \
  flask-compress==1.3.2 \
  jsonschema==2.5.1 \
  paho-mqtt==1.2 \
  gTTS==2.0.3 \
  gTTS-token==1.1.3 \
  SpeechRecognition==3.5.0 \
  Adafruit-Python-DHT==1.1.2 \
  Adafruit-ADS1x15==1.0.2 \
  six==1.11.0

# Install rtl_433 (https://github.com/merbanan/rtl_433)
RUN wget https://github.com/merbanan/rtl_433/archive/18.05.zip \
  && unzip 18.05.zip \
  && rm -f 18.05.zip \
  && cd rtl_433-18.05/ \
  && mkdir build \
  && cd build \
  && cmake ../ \
  && make \
  && make install \
  && make clean

# Install myHouse
RUN wget https://github.com/myhouse-project/myHouse/archive/v2.4.zip -O myHouse.zip \
  && unzip myHouse.zip \
  && mv myHouse-2.4 /myHouse \
  && rm -f myHouse.zip

# Expose network services
EXPOSE 22 80

# Expose Volumes
VOLUME /myHouse/conf /myHouse/logs /var/lib/redis /var/log

# Install entrypoint
COPY ./docker-entrypoint.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Start myHouse
CMD ["myhouse"]
