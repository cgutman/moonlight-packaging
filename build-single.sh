TARGET_NAME="$1-$2"
DOCKERFILE="Dockerfile.$1.$2"

EXTRA_ARGS="--pull"
if [ "$1" == "aarch64" ] || [ "$1" == "rpi64" ] || [ "$1" == "l4t" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --platform linux/arm64"
elif [ "$1" == "armhf" ] || [ "$1" == "rpi" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --platform linux/arm/v7"
elif [ "$1" == "riscv64" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --platform linux/riscv64"
fi

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
  docker buildx build $EXTRA_ARGS -f $DOCKERFILE -t cgutman/moonlight-packaging:$TAG_NAME .
  echo Built Docker image - cgutman/moonlight-packaging:$TAG_NAME
fi

docker run --rm --mount type=bind,source="$(pwd)"/$OUT_DIR,target=/out --mount type=bind,source="$(pwd)"/debian,target=/opt/debian -e COMMIT="$3" cgutman/moonlight-packaging:$TAG_NAME
