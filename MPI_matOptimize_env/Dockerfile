FROM ubuntu:20.04
#ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
#ENV DEBIAN_FRONTEND=noninteractive
#USER root
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -yq --no-install-recommends \
    git wget build-essential wget cmake\
    ca-certificates  libprotoc-dev protobuf-compiler unzip \
    sed coreutils vim-tiny libncurses5 time mpich openssh-server && apt-get clean
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -yq --no-install-recommends \
    libboost-filesystem-dev libboost-program-options-dev libboost-iostreams-dev libboost-date-time-dev && apt-get clean
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -yq --no-install-recommends \
    libmpich-dev  && apt-get clean
RUN mkdir /var/run/sshd && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ARG ignore=unknown
RUN git clone https://github.com/yceh/usher.git && cd usher && git checkout MPI\
 && wget https://github.com/oneapi-src/oneTBB/archive/2019_U9.tar.gz && \
tar -xvzf 2019_U9.tar.gz && mkdir -p build && cd build && \
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DTBB_DIR=${PWD}/../oneTBB-2019_U9  -DCMAKE_PREFIX_PATH=${PWD}/../oneTBB-2019_U9/cmake  .. && make VERBOSE=1 -j
RUN useradd -m temp
RUN echo /usher/build/tbb_cmake_build/tbb_cmake_build_subdir_release >/etc/ld.so.conf.d/tbb.conf&&ldconfig
RUN echo '    StrictHostKeyChecking no' >>/etc/ssh/ssh_config
USER temp
WORKDIR /home/temp
RUN ssh-keygen -q -f /home/temp/.ssh/id_rsa && cat .ssh/id_rsa.pub >> .ssh/authorized_keys
EXPOSE 22
CMD /usr/sbin/sshd -D -h /home/temp/.ssh/id_rsa
ENV PATH=$PATH:/usher/build