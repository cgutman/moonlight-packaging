TAG_NAME="l4t-bionic"
OUT_DIR="out_$TAG_NAME"
DOCKERFILE="Dockerfile.l4t.bionic"

rm -rf $OUT_DIR

set -e
mkdir $OUT_DIR

docker build -f $DOCKERFILE -t cgutman/moonlight-packaging:$TAG_NAME .
docker run -it --rm --runtime nvidia --mount type=bind,source="$(pwd)"/$OUT_DIR,target=/out --mount type=bind,source="$(pwd)"/debian,target=/opt/debian cgutman/moonlight-packaging:$TAG_NAME