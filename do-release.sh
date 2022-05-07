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
./build-l4t.sh
./build-rpi.sh
./build-rpi64.sh

# Push the moonlight-qt packages to Cloudsmith repos
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/bionic out_l4t-bionic/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/buster out_rpi-buster/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bullseye out_rpi-buster/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/buster out_rpi-buster64/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bullseye out_rpi-buster64/moonlight-qt_*.deb

# Push the moonlight-qt-dbgsym packages to Cloudsmith repos
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/bionic out_l4t-bionic/moonlight-qt-dbgsym_*.ddeb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/buster out_rpi-buster/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bullseye out_rpi-buster/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/buster out_rpi-buster64/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bullseye out_rpi-buster64/moonlight-qt-dbgsym_*.deb
