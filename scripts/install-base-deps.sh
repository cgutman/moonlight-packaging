
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl g++ make ninja-build devscripts fakeroot debhelper git nasm libgbm-dev libdrm-dev libasound2-dev libdbus-1-dev libegl1-mesa-dev libgl1-mesa-dev libgles2-mesa-dev libglu1-mesa-dev libibus-1.0-dev libpulse-dev libudev-dev libx11-dev libxcursor-dev libxext-dev libxi-dev libxinerama-dev libxkbcommon-dev libxrandr-dev libxss-dev libxt-dev libxv-dev libxxf86vm-dev cmake libgl-dev meson
apt-get install -y --no-install-recommends libssl-dev qtbase5-dev qtquickcontrols2-5-dev qtdeclarative5-dev libqt5svg5-dev libopus-dev gnupg

if [ "$DISTRO" != "buster" ]; then
    apt-get install -y libfreetype-dev libpipewire-0.3-dev
else
    apt-get install -y libfreetype6-dev
fi

if [ "$DISTRO" != "buster" ] && [ "$DISTRO" != "bullseye" ]; then
    apt-get install -y wayland-protocols libwayland-dev libdecor-0-dev
fi

if [ "$TARGET" == "embedded" ] && [ "$DISTRO" != "sid" ]; then
   # Grab latest kernel headers from Bookworm to pick up the latest V4L2 defs
   apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6ED0E7B82643E131
   echo "deb http://deb.debian.org/debian bookworm-backports main" >> /etc/apt/sources.list
   apt-get update
   apt-get install -y --no-install-recommends linux-libc-dev/bookworm-backports
fi
