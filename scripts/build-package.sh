set -e

# Check out the source without the Windows/Mac prebuilts
[[ ! -z "$COMMIT" ]] || COMMIT="master"
echo "Checking out $COMMIT"
git clone https://github.com/moonlight-stream/moonlight-qt.git
cd moonlight-qt
git checkout $COMMIT
git log -1
git -c submodule.libs.update=none submodule update --init --recursive

# Grab the verson metadata
VERSION=`cat app/version.txt`

# Determine extra target-specific dependencies
if [ "$TARGET" == "rpi" ]; then
    EXTRA_BUILD_DEPS="libraspberrypi-dev | rbp-userland-dev-osmc"
    EXTRA_DEPS="libraspberrypi0 | rbp-userland-osmc"
    EXTRA_CONFIG="CONFIG+=glslow"
elif [ "$TARGET" == "rpi64" ]; then
    EXTRA_CONFIG="CONFIG+=glslow"
elif [ "$TARGET" == "l4t" ]; then
    EXTRA_DEPS=""
elif [ "$TARGET" == "desktop" ]; then
    EXTRA_BUILD_DEPS="libwayland-dev, wayland-protocols, libva-dev, libvdpau-dev"
elif [ "$TARGET" == "embedded" ]; then
    EXTRA_CONFIG="CONFIG+=glslow"
else
    echo "Unrecognized target: $TARGET"
    exit 1
fi

# Determine extra distro-specific dependencies
if [ "$DISTRO" != "buster" ] && [ $DISTRO != "bionic" ]; then
    EXTRA_BUILD_DEPS="$EXTRA_BUILD_DEPS, libfreetype-dev"
else
    EXTRA_BUILD_DEPS="$EXTRA_BUILD_DEPS, libfreetype6-dev"
fi
if [ "$DISTRO" != "bionic" ]; then
    EXTRA_BUILD_DEPS="$EXTRA_BUILD_DEPS, libgl-dev"
else
    EXTRA_BUILD_DEPS="$EXTRA_BUILD_DEPS, libgl1-mesa-dev"
fi

# Create a build directory
mkdir /opt/build

# Generate source tarball
scripts/generate-src.sh

# Move the tarball into the build directory
mv build/source/MoonlightSrc-$VERSION.tar.gz /opt/build/moonlight-qt_$VERSION.orig.tar.gz

# Extract the tarball into the appropriate directory
cd /opt/build
mkdir moonlight-qt-$VERSION
cd moonlight-qt-$VERSION
tar xvf ../moonlight-qt_$VERSION.orig.tar.gz

# Copy the debian directory into the build directory
cp -r /opt/debian .

# Patch the control file with target-specific dependencies
sed -i "s/EXTRA_BUILD_DEPS/$EXTRA_BUILD_DEPS/g" debian/control
sed -i "s/EXTRA_DEPS/$EXTRA_DEPS/g" debian/control
cat debian/control

# Patch the rules file with target-specific config options
sed -i "s/EXTRA_CONFIG/$EXTRA_CONFIG/g" debian/rules
cat debian/rules

# Build the package
debuild -us -uc

# Copy the output to the out directory
cd /opt/build
shopt -s extglob
cp -v -r !(moonlight-qt-$VERSION) /out

# Done!
echo "Build successful!"
