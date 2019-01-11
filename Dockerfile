FROM resin/rpi-raspbian

# define variables
ENV MYHOUSE_VERSION=2.4 \
  RTL_433_VERSION=18.05 \
  WORKDIR=/apps

# define metadata
LABEL com.myhouse-project.version="$MYHOUSE_VERSION"

# Set the working dir
WORKDIR $WORKDIR

# Install required packages with apt
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get install -y \
  screen \
  unzip \
  less \
  curl \
  expect \
  net-tools \
  usbutils \
  raspi-config \
  raspi-gpio \
  wiringpi \
  libraspberrypi-bin \
  build-essential \
  autoconf \
  cmake \
  pkg-config \
  libtool \
  libusb-1.0.0-dev \
  python-pip \
  python-serial \
  python-dev \
  python-flask \
  python-redis \
  python-numpy \
  python-rpi.gpio \
  python-feedparser \
  python-opencv \
  mpg123 \
  sox \
  flac \
  pocketsphinx \
  libttspico-utils \
  rtl-sdr \
  librtlsdr-dev \
  bluetooth \
  bluez \
  bluez-tools \
  alsa-utils \
  pulseaudio-module-bluetooth  \
  redis-server \
  rsyslog \
  openssh-server \
  mosquitto \
  mosquitto-clients \
  wget \
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
  Adafruit-ADS1x15==1.0.2 \
  six==1.11.0
ENV ADAFRUIT_DHT_VERSION=1.3.3
RUN wget https://github.com/adafruit/Adafruit_Python_DHT/archive/$ADAFRUIT_DHT_VERSION.zip \
  && unzip $ADAFRUIT_DHT_VERSION.zip \
  && rm -f $ADAFRUIT_DHT_VERSION.zip \
  && cd Adafruit_Python_DHT-$ADAFRUIT_DHT_VERSION \
  && python setup.py --force-pi install \
  && cd .. \
  && rm -rf Adafruit_Python_DHT-$ADAFRUIT_DHT_VERSION

# Install rtl_433 (https://github.com/merbanan/rtl_433)
RUN wget https://github.com/merbanan/rtl_433/archive/$RTL_433_VERSION.zip \
  && unzip $RTL_433_VERSION.zip \
  && rm -f $RTL_433_VERSION.zip \
  && cd rtl_433-$RTL_433_VERSION/ \
  && mkdir build \
  && cd build \
  && cmake ../ \
  && make \
  && make install \
  && make clean

# Install myHouse
RUN wget https://github.com/myhouse-project/myHouse/archive/v$MYHOUSE_VERSION.zip -O myHouse.zip \
  && unzip myHouse.zip \
  && mv myHouse-$MYHOUSE_VERSION myHouse \
  && rm -f myHouse.zip

# Expose network services
EXPOSE 80 1883

# Expose Volumes
VOLUME /conf /logs /data /setup

HEALTHCHECK --interval=5m --timeout=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Install entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["bash","/docker-entrypoint.sh"]

# copy setup helper scripts
COPY ./setup $WORKDIR/setup

# Start myHouse
CMD ["myHouse"]
