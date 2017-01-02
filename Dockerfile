FROM sitespeedio/node:ubuntu16.04-nodejs6.9.1

# Lets install all dependencies for VisualMetrics
RUN apt-get update -y && apt-get install -y \
  ipython \
  ipython-notebook \
  libjpeg-dev \
  python \
  python-dev \
  python-imaging \
  python-numpy \
  python-scipy \
  python-matplotlib \
  python-pandas \
  python-pip \
  python-sympy \
  python-nose \
  wget \
  xz-utils \
  --no-install-recommends --force-yes && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  pip install --upgrade pip && \
  pip install --upgrade setuptools && \
  pip install pyssim

# Install imagemagick, we need at least 6.9.7-1 for firstVisualChange to work correctly
# see https://github.com/WPO-Foundation/visualmetrics/issues/20
RUN apt-get update -y && \
  apt-get install build-essential -y && \
  apt-get build-dep imagemagick -y && \
  wget http://www.imagemagick.org/download/ImageMagick-6.9.7-1.tar.gz && \
  tar xzf ImageMagick-6.9.7-1.tar.gz && \
  cd ImageMagick-6.9.7-1 && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  rm ImageMagick-6.9.7-1.tar.gz && \
  rm -fR ImageMagick-6.9.7-1 && \
  apt-get --purge autoremove build-essential && \
  apt-get clean autoclean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install a static version of FFMPEG
RUN wget http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz && \
  tar xf ffmpeg-release-64bit-static.tar.xz && \
  mv ffmpeg*/ffmpeg /usr/bin/ && \
  mv ffmpeg*/ffprobe /usr/bin/ && \
  rm ffmpeg-release-64bit-static.tar.xz
