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
# This is inspired by https://hub.docker.com/r/starefossen/node-imagemagick/

ENV MAGICK_URL "http://imagemagick.org/download/releases"
ENV MAGICK_VERSION 6.9.7-2

RUN apt-get update -y && \
 apt-get install build-essential curl -y && \
 gpg --keyserver pool.sks-keyservers.net --recv-keys 8277377A \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    libpng-dev libjpeg-dev libtiff-dev libopenjpeg-dev \
  && apt-get remove -y imagemagick \
  && cd /tmp \
  && curl -SLO "${MAGICK_URL}/ImageMagick-${MAGICK_VERSION}.tar.xz" \
  && curl -SLO "${MAGICK_URL}/ImageMagick-${MAGICK_VERSION}.tar.xz.asc" \
  && gpg --verify "ImageMagick-${MAGICK_VERSION}.tar.xz.asc" "ImageMagick-${MAGICK_VERSION}.tar.xz" \
  && tar xf "ImageMagick-${MAGICK_VERSION}.tar.xz" \
  && cd "ImageMagick-${MAGICK_VERSION}" \
  && ./configure \
    --disable-static \
    --enable-shared \

    --with-jpeg \
    --with-jp2 \
    --with-openjp2 \
    --with-png \
    --with-tiff \
    --with-quantum-depth=8 \

    --without-magick-plus-plus \
    # disable BZLIB support
    --without-bzlib \
    # disable ZLIB support
    --without-zlib \
    # disable Display Postscript support
    --without-dps \
    # disable FFTW support
    --without-fftw \
    # disable FlashPIX support
    --without-fpx \
    # disable DjVu support
    --without-djvu \
    # disable fontconfig support
    --without-fontconfig \
    # disable Freetype support
    --without-freetype \
    # disable JBIG support
    --without-jbig \
    # disable lcms (v1.1X) support
    --without-lcms \
    # disable lcms (v2.X) support
    --without-lcms2 \
    # disable Liquid Rescale support
    --without-lqr \
     # disable LZMA support
    --without-lzma \
    # disable OpenEXR support
    --without-openexr \
    # disable PANGO support
    --without-pango \
    # disable TIFF support
    --without-webp \
    # don't use the X Window System
    --without-x \
    # disable XML support
    --without-xml \
  && make \
  && make install \
  && ldconfig /usr/local/lib \
  && apt-get -y autoclean \
  && apt-get --purge autoremove curl build-essential -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install a static version of FFMPEG
RUN wget http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz && \
  tar xf ffmpeg-release-64bit-static.tar.xz && \
  mv ffmpeg*/ffmpeg /usr/bin/ && \
  mv ffmpeg*/ffprobe /usr/bin/ && \
  rm ffmpeg-release-64bit-static.tar.xz
