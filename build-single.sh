#!/usr/bin/env bash

TARGET_NAME="$1-$2"

TAG_UNIQUE_ID=`(git ls-tree HEAD; git diff-index HEAD) | sha256sum | cut -c-16`
TAG_NAME="${TARGET_NAME}_${TAG_UNIQUE_ID}"
OUT_DIR="out_$TARGET_NAME"

docker pull cgutman/moonlight-packaging:$TAG_NAME
PULL_EXIT_CODE=$?

rm -rf $OUT_DIR

set -e
mkdir $OUT_DIR

if [ $PULL_EXIT_CODE -eq 0 ]; then
  echo Using pre-built Docker image - cgutman/moonlight-packaging:$TAG_NAME
else
  echo Pre-built image not available - building cgutman/moonlight-packaging:$TAG_NAME
  ./build-image.sh $1 $2 $TAG_UNIQUE_ID
  echo Built Docker image - cgutman/moonlight-packaging:$TAG_NAME
fi

docker run --rm --mount type=bind,source="$(pwd)"/$OUT_DIR,target=/out --mount type=bind,source="$(pwd)"/debian,target=/opt/debian -e COMMIT="$3" cgutman/moonlight-packaging:$TAG_NAME

# Push the image now if we're building master in GitHub Actions
if [ $PULL_EXIT_CODE -ne 0 ] && [ "$GITHUB_REF" == "refs/heads/master" ]; then
  docker push cgutman/moonlight-packaging:$TAG_NAME
fi