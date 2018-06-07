#!/bin/sh

set -eu

cd $(dirname $(realpath $0))

TAG="agoenv"
USER_UID=$(id -u)
USER_NAME=$(whoami)
USER_HOME_DIR="$PWD/home/"
LOGIN_SHELL="/bin/zsh"

docker build --tag $TAG --label $TAG --build-arg USER_UID=$USER_UID --build-arg USER_NAME=$USER_NAME --build-arg LOGIN_SHELL=$LOGIN_SHELL --rm $* .
docker run --hostname $TAG --interactive --tty --volume $USER_HOME_DIR:/home/$USER_NAME --volume $HOME/.ssh:/home/$USER_NAME/.ssh --rm $TAG

UNNECESSARY_IMAGES=$(docker images --quiet --filter "label=$TAG" --filter "before=$TAG:latest")
if [ -n "$UNNECESSARY_IMAGES" ]; then
  docker rmi $UNNECESSARY_IMAGES
fi
