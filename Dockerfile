FROM sitespeedio/node:ubuntu16.04-nodejs6.9.1

# Lets install all dependencies for VisualMetrics
RUN apt-get update -y && apt-get install -y \
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
  pip install pyssim

# Install a static version of FFMPEG
# Break the build if the version doesn't match the expected, to avoid surprise upgrades.
RUN wget -q http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz && \
  tar xf ffmpeg-release-64bit-static.tar.xz && \
  mv ffmpeg-*-64bit-static/ffmpeg /usr/bin/ && \
  ffmpeg -version | grep -q 'ffmpeg version 3.2-static' && \
  rm -r ffmpeg-*
