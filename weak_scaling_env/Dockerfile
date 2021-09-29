FROM ubuntu:20.04
#ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
#ENV DEBIAN_FRONTEND=noninteractive
#USER root
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -yq --no-install-recommends \
    git wget build-essential wget cmake  libboost-all-dev\
    ca-certificates  libprotoc-dev protobuf-compiler unzip \
    sed coreutils vim-tiny libncurses5 time && apt-get clean
RUN git clone https://github.com/yceh/usher.git && cd usher && git checkout weak_scaling \
 && wget https://github.com/oneapi-src/oneTBB/archive/2019_U9.tar.gz && \
tar -xvzf 2019_U9.tar.gz && mkdir -p build && cd build && \
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DTBB_DIR=${PWD}/../oneTBB-2019_U9  -DCMAKE_PREFIX_PATH=${PWD}/../oneTBB-2019_U9/cmake  .. && make VERBOSE=1 -j && cd .. && echo -n palosgomias > ~/.passwordfile.tnt 
RUN useradd -m temp
USER temp
WORKDIR /home/temp
ARG ignore=unknown
RUN git clone https://github.com/yceh/matOptimize-experiments.git
WORKDIR /home/temp/matOptimize-experiments
RUN mkdir data 
