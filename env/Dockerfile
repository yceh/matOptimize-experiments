FROM ubuntu:20.04
#ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
#ENV DEBIAN_FRONTEND=noninteractive
#USER root
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -yq --no-install-recommends \
    git wget build-essential wget cmake  libboost-all-dev\
    ca-certificates  libprotoc-dev protobuf-compiler unzip r-cran-ape \
    perl sed coreutils libncurses5 time && apt-get clean
RUN  cd /usr/bin && \
    wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faToVcf \
    && chmod a+x faToVcf && \
    wget http://www.lillo.org.ar/phylogeny/tnt/tnt64-no-tax-limit.zip \
    && unzip -p  tnt64-no-tax-limit.zip  tnt >tnt && chmod a+x tnt \
    && rm tnt64-no-tax-limit.zip
RUN cd ~ && git clone https://github.com/yatisht/usher.git && cd usher \
 && wget https://github.com/oneapi-src/oneTBB/archive/2019_U9.tar.gz && \
tar -xvzf 2019_U9.tar.gz && mkdir -p build && cd build && \
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DTBB_DIR=${PWD}/../oneTBB-2019_U9  -DCMAKE_PREFIX_PATH=${PWD}/../oneTBB-2019_U9/cmake  .. && make VERBOSE=1 -j && cd .. && echo -n palosgomias > ~/.passwordfile.tnt && mkdir ~/matOptimize_experiments
ENV PATH=/root/usher/build:$PATH 
WORKDIR /root
CMD bash
