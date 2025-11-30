fail()
{
	echo "$1" 1>&2
	exit 1
}

git diff-index --quiet HEAD -- || fail "Release builds must not have unstaged changes!"

set -e

# Build the packages
./build-single.sh l4t noble $1 &
./build-single.sh rpi trixie $1 &
./build-single.sh rpi64 trixie $1 &
wait
./build-single.sh aarch64 jammy $1 &
./build-single.sh riscv64 trixie $1 &
./build-single.sh armhf jammy $1 &
wait
./build-single.sh armhf trixie $1 &
./build-single.sh aarch64 trixie $1 &
./build-single.sh armhf noble $1 &
wait
./build-single.sh aarch64 noble $1 &
./build-single.sh rpi bookworm $1 &
./build-single.sh rpi64 bookworm $1 &
wait
./build-single.sh armhf bookworm $1 &
./build-single.sh aarch64 bookworm $1 &
./build-single.sh l4t jammy $1 &
wait

# Push the moonlight-qt packages to Cloudsmith repos
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/jammy out_l4t-jammy/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/noble out_l4t-noble/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/trixie out_rpi-trixie/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bookworm out_rpi-bookworm/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/trixie out_rpi64-trixie/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bookworm out_rpi64-bookworm/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bookworm out_armhf-bookworm/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/trixie out_armhf-trixie/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bookworm out_aarch64-bookworm/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/trixie out_aarch64-trixie/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/trixie out_riscv64-trixie/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/ubuntu/jammy out_armhf-jammy/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/ubuntu/noble out_armhf-noble/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/ubuntu/jammy out_aarch64-jammy/moonlight-qt_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/ubuntu/noble out_aarch64-noble/moonlight-qt_*.deb

# Push the moonlight-qt-dbgsym packages to Cloudsmith repos
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/jammy out_l4t-jammy/moonlight-qt-dbgsym_*.ddeb
cloudsmith push deb moonlight-game-streaming/moonlight-l4t/ubuntu/noble out_l4t-noble/moonlight-qt-dbgsym_*.ddeb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bookworm out_rpi-bookworm/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/trixie out_rpi-trixie/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/bookworm out_rpi64-bookworm/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/raspbian/trixie out_rpi64-trixie/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bookworm out_armhf-bookworm/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/trixie out_armhf-trixie/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/bookworm out_aarch64-bookworm/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/trixie out_aarch64-trixie/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/debian/trixie out_riscv64-trixie/moonlight-qt-dbgsym_*.deb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/ubuntu/jammy out_armhf-jammy/moonlight-qt-dbgsym_*.ddeb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/ubuntu/noble out_armhf-noble/moonlight-qt-dbgsym_*.ddeb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/ubuntu/jammy out_aarch64-jammy/moonlight-qt-dbgsym_*.ddeb
cloudsmith push deb moonlight-game-streaming/moonlight-qt/ubuntu/noble out_aarch64-noble/moonlight-qt-dbgsym_*.ddeb
