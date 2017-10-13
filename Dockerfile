FROM sitespeedio/node:ubuntu17.04-nodejs8.7.0

# Lets install all dependencies for VisualMetrics
RUN buildDeps='wget' && \
  apt-get update -y && apt-get install -y \
  imagemagick \
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
  pip install pyssim && \
  wget http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz && \
  tar xf ffmpeg-release-64bit-static.tar.xz && \
  mv ffmpeg*/ffmpeg /usr/bin/ && \
  mv ffmpeg*/ffprobe /usr/bin/ && \
  rm ffmpeg-release-64bit-static.tar.xz && \
  apt-get purge -y --auto-remove $buildDeps \
