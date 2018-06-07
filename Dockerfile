FROM debian:buster
MAINTAINER ago

ENV USER_NAME=user USER_HOME_DIR=/home/user SHELL=/bin/zsh

RUN apt-get update && apt-get install -y vim sudo less locales zsh build-essential cmake git locales clang libclang-dev 'libc\+\+-dev' 'libc\+\+abi-dev'
RUN echo "${USER_NAME} ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN echo ja_JP.UTF-8 UTF-8 > /etc/locale.gen && locale-gen && update-locale LANG=ja_JP.UTF-8

RUN useradd --uid 1000 -m -d ${USER_HOME_DIR} -s ${SHELL} ${USER_NAME}
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}

RUN sudo gpasswd -a ${USER_NAME} sudo

COPY dotfiles/* ${USER_HOME_DIR}/
RUN sudo chown -R ${USER_NAME}:${USER_NAME} .

RUN sudo apt-get install -y emacs25-nox
RUN git clone https://github.com/agot/dot.emacs.d.git .emacs.d

CMD ["/bin/zsh"]
