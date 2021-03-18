FROM debian:unstable
MAINTAINER ago

ARG USER_UID
ARG USER_NAME
ARG LOGIN_SHELL=/bin/bash
ENV SHELL=$LOGIN_SHELL

# add library path
ENV LD_LIBRARY_PATH /usr/local/lib64

# add apt repository
RUN apt-get update \
 && apt-get -y install software-properties-common curl gnupg \
 && curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && apt-add-repository "deb http://apt.llvm.org/unstable/ llvm-toolchain main"

# install base packages
RUN apt-get update \
 && apt-get install -y sudo less locales zsh build-essential git flex libssl-dev \
 && apt-get clean

# set environment
RUN ln -s -f /usr/share/zoneinfo/Japan /etc/localtime
RUN echo "${USER_NAME} ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen

# build gcc
RUN cd /usr/local/src \
 && git clone --depth 1 -b master git://gcc.gnu.org/git/gcc.git \
 && cd gcc \
 && ./contrib/download_prerequisites \
 && mkdir build \
 && cd build \
 && ../configure --enable-languages=c,c++ --prefix=/usr/local --disable-bootstrap --disable-multilib \
 && make -j4 \
 && make install \
 && make clean \
 && update-alternatives --install /usr/bin/cc cc /usr/local/bin/gcc 1000 \
 && update-alternatives --install /usr/bin/c++ c++ /usr/local/bin/g++ 1000

# install cmake
RUN cd /usr/local/src \
 && git clone -b v3.20.0-rc4 --depth 1 https://gitlab.kitware.com/cmake/cmake.git \
 && cd cmake \
 && ./bootstrap \
 && make \
 && make install \
 && cd .. \
 && rm -rf cmake

# install clang
RUN apt-get update \
 && apt-get install -y clang-11 lldb-11 lld-11 clang-tools-11 clang-format-11 clang-tidy-11 libc++-11-dev libc++abi-11-dev libclang-11-dev \
 && apt-get clean \
 && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 1000 \
 && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 1000 \
 && update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-11 1000 \
 && update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-11 1000 \
 && update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-11 1000

# install libraries
RUN apt-get update \
 && apt-get install -y libvulkan-dev libgtest-dev xorg-dev \
 && apt-get clean

# install other software
RUN apt-get update \
 && apt-get install -y tmux vim emacs-nox rtags \
 && apt-get clean \
 && update-alternatives --install /usr/bin/rc rc /usr/bin/rtags-rc 1000 \
 && update-alternatives --install /usr/bin/rdm rdm /usr/bin/rtags-rdm 1000

# create user
RUN useradd --uid "${USER_UID}" -d "/home/${USER_NAME}" -s "${LOGIN_SHELL}" "${USER_NAME}"
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

CMD LANG=ja_JP.UTF-8 $SHELL --login
