TAG_NAME="l4t-bionic"
OUT_DIR="out_$TAG_NAME"
DOCKERFILE="Dockerfile.l4t.bionic"

rm -rf $OUT_DIR

set -e
mkdir $OUT_DIR

docker build -f $DOCKERFILE -t cgutman/moonlight-packaging:$TAG_NAME .
docker run --rm --runtime nvidia --mount type=bind,source="$(pwd)"/$OUT_DIR,target=/out --mount type=bind,source="$(pwd)"/debian,target=/opt/debian -e COMMIT="$1" cgutman/moonlight-packaging:$TAG_NAME