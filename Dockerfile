FROM debian:unstable
MAINTAINER ago

ARG USER_UID
ARG USER_NAME
ARG LOGIN_SHELL=/bin/bash
ENV SHELL=$LOGIN_SHELL

COPY update-alternatives-clang.sh /root

# add library path
ENV LD_LIBRARY_PATH /usr/local/lib64

# install base packages
RUN apt-get update \
 && apt-get install -y sudo less locales zsh build-essential git cmake extra-cmake-modules ninja-build \
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
 && apt-get install -y llvm-15-dev lld-15 clang-15 clang-tidy-15 clang-format-15 clangd-15 libclang-15-dev lldb-15 libomp-15-dev libc\+\+-15-dev libc\+\+abi-15-dev \
 && apt-get clean \
 && /root/update-alternatives-clang.sh 15 1000

# install cmake
#RUN apt-get update \
# && apt-get install -y libssl-dev \
# && apt-get clean \
# && cd /usr/local/src \
# && git clone -b v3.25.0 --depth 1 https://gitlab.kitware.com/cmake/cmake.git \
# && cd cmake \
# && ./bootstrap \
# && make \
# && make install \
# && cd .. \
# && rm -rf cmake

# install extra-cmake-modules
#RUN cd /usr/local/src \
# && git clone -b v5.94.0 --depth 1 https://github.com/KDE/extra-cmake-modules.git \
# && cd extra-cmake-modules \
# && mkdir build \
# && cd build \
# && cmake .. \
# && make \
# && make install \
# && cd .. \
# && rm -rf extra-cmake-modules

# install other software
RUN apt-get update \
 && apt-get install -y tmux vim automake autoconf pkg-config \
 && apt-get clean

# install libraries
RUN apt-get update \
 && apt-get install -y libwayland-dev wayland-protocols libxkbcommon-dev libvulkan-dev glslang-dev glslang-tools libgtest-dev pkg-config \
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
