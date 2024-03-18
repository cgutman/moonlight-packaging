fail()
{
	echo "$1" 1>&2
	exit 1
}

git diff-index --quiet HEAD -- || fail "Release builds must not have unstaged changes!"

set -e

# Ensure build images are pushed to DockerHub
./push-images.sh

# Build the packages
./build-l4t-bionic.sh $1 &
./build-rpi-buster.sh $1 &
./build-rpi64-buster.sh $1 &
./build-armhf-bullseye.sh $1 &
./build-aarch64-bullseye.sh $1 &
wait
./build-rpi-bookworm.sh $1 &
./build-rpi64-bookworm.sh $1 &
./build-armhf-bookworm.sh $1 &
./build-aarch64-bookworm.sh $1 &
./build-riscv64-sid.sh $1 &
./build-l4t-jammy.sh $1 &
wait

# Push the moonlight-qt packages to Cloudsmith repos
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/bionic out_l4t-bionic/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/jammy out_l4t-jammy/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/buster out_rpi-buster/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bullseye out_rpi-buster/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bookworm out_rpi-bookworm/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/buster out_rpi64-buster/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bullseye out_rpi64-buster/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bookworm out_rpi64-bookworm/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bullseye out_armhf-bullseye/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bookworm out_armhf-bookworm/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bullseye out_aarch64-bullseye/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bookworm out_aarch64-bookworm/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/sid out_riscv64-sid/moonlight-qt_*.deb

# Push the moonlight-qt-dbgsym packages to Cloudsmith repos
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/bionic out_l4t-bionic/moonlight-qt-dbgsym_*.ddeb
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/jammy out_l4t-jammy/moonlight-qt-dbgsym_*.ddeb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/buster out_rpi-buster/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bullseye out_rpi-buster/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bookworm out_rpi-bookworm/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/buster out_rpi64-buster/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bullseye out_rpi64-buster/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bookworm out_rpi64-bookworm/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bullseye out_armhf-bullseye/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bookworm out_armhf-bookworm/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bullseye out_aarch64-bullseye/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bookworm out_aarch64-bookworm/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/sid out_riscv64-sid/moonlight-qt-dbgsym_*.deb
