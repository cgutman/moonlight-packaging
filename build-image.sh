#!/usr/bin/env bash

set -e

DOCKERFILE="Dockerfile.$1.$2"

EXTRA_ARGS="--pull"
if [ "$1" == "aarch64" ] || [ "$1" == "rpi64" ] || [ "$1" == "l4t" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --platform linux/arm64"
elif [ "$1" == "armhf" ] || [ "$1" == "rpi" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --platform linux/arm/v7"
elif [ "$1" == "riscv64" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --platform linux/riscv64"
fi

docker buildx build $EXTRA_ARGS -f $DOCKERFILE -t cgutman/moonlight-packaging:"$1-$2_$3" .
