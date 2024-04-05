set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl g++ make ninja-build meson devscripts fakeroot debhelper git nasm libgbm-dev libdrm-dev libasound2-dev libdbus-1-dev libegl1-mesa-dev libgl1-mesa-dev libgles2-mesa-dev libglu1-mesa-dev libibus-1.0-dev libpulse-dev libudev-dev libx11-dev libxcursor-dev libxext-dev libxi-dev libxinerama-dev libxkbcommon-dev libxrandr-dev libxss-dev libxt-dev libxv-dev libxxf86vm-dev cmake
apt-get install -y --no-install-recommends libssl-dev qtbase5-dev qtquickcontrols2-5-dev qtdeclarative5-dev libqt5svg5-dev libopus-dev

if [ "$DISTRO" != "buster" ] && [ "$DISTRO" != "bionic" ]; then
    apt-get install -y libfreetype-dev libpipewire-0.3-dev
else
    apt-get install -y libfreetype6-dev
fi

if [ "$DISTRO" != "bionic" ]; then
    apt-get install -y libgl-dev
else
    apt-get install -y libgl1-mesa-dev
fi

if [ "$DISTRO" != "buster" ] && [ "$DISTRO" != "bullseye" ] && [ "$DISTRO" != "bionic" ]; then
    apt-get install -y wayland-protocols libwayland-dev libdecor-0-dev
fi
