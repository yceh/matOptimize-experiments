FROM ubuntu:20.04
#ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
#ENV DEBIAN_FRONTEND=noninteractive
#USER root
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -yq --no-install-recommends \
    git wget build-essential wget cmake  libboost-all-dev\
    ca-certificates  libprotoc-dev protobuf-compiler unzip \
    perl sed coreutils libncurses5 time && apt-get clean
RUN git clone https://github.com/yatisht/usher.git && cd usher \
 && wget https://github.com/oneapi-src/oneTBB/archive/2019_U9.tar.gz && \
tar -xvzf 2019_U9.tar.gz && mkdir -p build && cd build && \
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DTBB_DIR=${PWD}/../oneTBB-2019_U9  -DCMAKE_PREFIX_PATH=${PWD}/../oneTBB-2019_U9/cmake  .. && make VERBOSE=1 -j && cd .. && echo -n palosgomias > ~/.passwordfile.tnt 
RUN wget http://www.netlib.org/pvm3/pvm3.4.6.tgz && tar -xf pvm3.4.6.tgz && cd pvm3&& export PVM_ROOT=`pwd`  && make -j
RUN apt-get update && apt-get install -yq --no-install-recommends vim-tiny
ENV PATH=/usher/build:/pvm3/bin/LINUX64:$PATH PVM_ROOT=/pvm3
RUN ln -sf /home/temp/matOptimize-experiments/data/tnt /pvm3/bin/LINUX64/tnt
CMD /pvm3/lib/pvmd & bash
RUN useradd -m temp
USER temp
RUN  echo palosgomias > /home/temp/.passwordfile.tnt
WORKDIR /home/temp
RUN git clone https://github.com/yceh/matOptimize-experiments.git
WORKDIR /home/temp/matOptimize-experiments
RUN mkdir data 
