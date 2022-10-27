FROM debian:unstable
MAINTAINER ago

ARG USER_UID
ARG USER_NAME
ARG LOGIN_SHELL=/bin/bash
ENV SHELL=$LOGIN_SHELL

# add library path
ENV LD_LIBRARY_PATH /usr/local/lib64

# install base packages
RUN apt-get update \
 && apt-get install -y sudo less locales zsh build-essential git \
 && apt-get clean

# set environment
RUN ln -s -f /usr/share/zoneinfo/Japan /etc/localtime
RUN echo "${USER_NAME} ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen

# build gcc
#RUN apt-get update \
# && apt-get install -y flex \
# && apt-get clean \
# && cd /usr/local/src \
# && git clone --depth 1 -b master git://gcc.gnu.org/git/gcc.git \
# && cd gcc \
# && ./contrib/download_prerequisites \
# && mkdir build \
# && cd build \
# && ../configure --enable-languages=c,c++ --prefix=/usr/local --disable-bootstrap --disable-multilib \
# && make -j4 \
# && make install \
# && make clean \
# && update-alternatives --install /usr/bin/cc cc /usr/local/bin/gcc 1000 \
# && update-alternatives --install /usr/bin/c++ c++ /usr/local/bin/g++ 1000

# install clang
RUN apt-get update \
 && apt-get install -y clang \
 && apt-get clean

# install cmake
RUN apt-get update \
 && apt-get install -y libssl-dev \
 && apt-get clean \
 && cd /usr/local/src \
 && git clone -b v3.23.1 --depth 1 https://gitlab.kitware.com/cmake/cmake.git \
 && cd cmake \
 && ./bootstrap \
 && make \
 && make install \
 && cd .. \
 && rm -rf cmake

# install extra-cmake-modules
RUN cd /usr/local/src \
 && git clone -b v5.94.0 --depth 1 https://github.com/KDE/extra-cmake-modules.git \
 && cd extra-cmake-modules \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd .. \
 && rm -rf extra-cmake-modules

# install other software
RUN apt-get update \
 && apt-get install -y tmux vim automake autoconf pkg-config \
 && apt-get clean

RUN apt-get update \
 && apt-get install -y llvm-dev libclang-dev zlib1g-dev \
 && cd /usr/local/src \
 && git clone --recursive --depth 1 https://github.com/Andersbakken/rtags.git \
 && cd rtags \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd .. \
 && rm -rf rtags

# install libraries
RUN apt-get update \
 && apt-get install -y libwayland-dev wayland-protocols libxkbcommon-dev libvulkan-dev libgtest-dev pkg-config \
 && apt-get clean

# build emacs
RUN apt-get update \
 && apt-get install -y emacs-nox \
 && apt-get clean

# create user
RUN useradd --uid "${USER_UID}" -d "/home/${USER_NAME}" -s "${LOGIN_SHELL}" "${USER_NAME}"
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

CMD LANG=ja_JP.UTF-8 $SHELL --login
