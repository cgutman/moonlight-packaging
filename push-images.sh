fail()
{
	echo "$1" 1>&2
	exit 1
}

git diff-index --quiet HEAD -- || fail "Images must not be pushed with uncommitted changes!"

set -e

TAG_UNIQUE_ID=`git ls-tree HEAD | sha256sum | cut -c-16`

docker build --pull -f Dockerfile.rpi.buster -t cgutman/moonlight-packaging:rpi-buster_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.rpi64.buster -t cgutman/moonlight-packaging:rpi64-buster_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.rpi.bookworm -t cgutman/moonlight-packaging:rpi-bookworm_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.rpi64.bookworm -t cgutman/moonlight-packaging:rpi64-bookworm_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.l4t.bionic -t cgutman/moonlight-packaging:l4t-bionic_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.l4t.noble -t cgutman/moonlight-packaging:l4t-noble_$TAG_UNIQUE_ID . &
wait
docker build --pull -f Dockerfile.aarch64.bullseye -t cgutman/moonlight-packaging:aarch64-bullseye_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.aarch64.bookworm -t cgutman/moonlight-packaging:aarch64-bookworm_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.armhf.bullseye -t cgutman/moonlight-packaging:armhf-bullseye_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.armhf.bookworm -t cgutman/moonlight-packaging:armhf-bookworm_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.riscv64.sid -t cgutman/moonlight-packaging:riscv64-sid_$TAG_UNIQUE_ID . &
docker build --pull -f Dockerfile.l4t.jammy -t cgutman/moonlight-packaging:l4t-jammy_$TAG_UNIQUE_ID . &
wait

docker push cgutman/moonlight-packaging:rpi-buster_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:rpi64-buster_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:rpi-bookworm_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:rpi64-bookworm_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:l4t-bionic_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:l4t-jammy_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:l4t-noble_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:armhf-bullseye_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:armhf-bookworm_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:aarch64-bullseye_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:aarch64-bookworm_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:riscv64-sid_$TAG_UNIQUE_ID
