fail()
{
	echo "$1" 1>&2
	exit 1
}

git diff-index --quiet HEAD -- || fail "Images must not be pushed with uncommitted changes!"

set -e

TAG_UNIQUE_ID=`git ls-tree HEAD | sha256sum | cut -c-16`

./build-image.sh l4t noble $TAG_UNIQUE_ID &
./build-image.sh rpi trixie $TAG_UNIQUE_ID &
./build-image.sh rpi64 trixie $TAG_UNIQUE_ID &
wait
./build-image.sh aarch64 jammy $TAG_UNIQUE_ID &
./build-image.sh riscv64 trixie $TAG_UNIQUE_ID &
./build-image.sh armhf jammy $TAG_UNIQUE_ID &
wait
./build-image.sh armhf trixie $TAG_UNIQUE_ID &
./build-image.sh aarch64 trixie $TAG_UNIQUE_ID &
./build-image.sh armhf noble $TAG_UNIQUE_ID &
wait
./build-image.sh aarch64 noble $TAG_UNIQUE_ID &
./build-image.sh rpi bookworm $TAG_UNIQUE_ID &
./build-image.sh rpi64 bookworm $TAG_UNIQUE_ID &
wait
./build-image.sh armhf bookworm $TAG_UNIQUE_ID &
./build-image.sh aarch64 bookworm $TAG_UNIQUE_ID &
./build-image.sh l4t jammy $TAG_UNIQUE_ID &
wait

docker push cgutman/moonlight-packaging:rpi-bookworm_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:rpi64-bookworm_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:rpi-trixie_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:rpi64-trixie_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:l4t-jammy_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:l4t-noble_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:armhf-bookworm_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:armhf-trixie_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:aarch64-bookworm_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:aarch64-trixie_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:armhf-jammy_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:armhf-noble_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:aarch64-jammy_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:aarch64-noble_$TAG_UNIQUE_ID
docker push cgutman/moonlight-packaging:riscv64-trixie_$TAG_UNIQUE_ID
