FROM node:0.10.31
ENV MONO_VERSION 3.10.0
RUN \
  apt-get update && \
  apt-get install -y pkg-config libgdiplus wget && \
  cd /tmp && \
  wget http://download.mono-project.com/sources/mono/mono-$MONO_VERSION.tar.bz2 && \
  tar -xvf mono-$MONO_VERSION.tar.bz2 && \
  rm -f mono-$MONO_VERSION.tar.bz2 && \
  wget https://raw.githubusercontent.com/tjanczuk/edge/master/tools/Microsoft.Portable.Common.targets \
    -O ./mono-$MONO_VERSION/mcs/tools/xbuild/targets/Microsoft.Portable.Common.targets && \
  cd mono-$MONO_VERSION && \
  sed -i "s/\@prefix\@\/lib\///g" ./data/config.in && \
  ./configure --prefix=/usr/local --with-glib=embedded --enable-nls=no && \
  make && \
  make install && \
  ldconfig && \
  cd /tmp && \
  rm -rf mono-$MONO_VERSION
# Install Edge.js.
ENV NODE_PATH /usr/local/lib/node_modules
WORKDIR /data
RUN npm install -g edge
ADD ./samples /data/samples
RUN sed -i "s/..\/lib\/edge/edge/g" /data/samples/*.js

# Define default command to run.
CMD ["bash"]