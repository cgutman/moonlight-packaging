set -e

# Check out the source
[[ ! -z "$COMMIT" ]] || COMMIT="master"
echo "Checking out $COMMIT"
git clone https://github.com/moonlight-stream/moonlight-qt.git
cd moonlight-qt
git checkout $COMMIT
git log -1

# Grab the verson metadata
VERSION=`cat app/version.txt`

# Create a build directory
mkdir /opt/build

# Nuke the libs folder - not needed for Linux
git rm -r libs
git -c user.name="Docker Build" -c user.email="docker@build" commit -m "Remove pre-built libraries"

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

# Build the package
debuild -us -uc

# Copy the output to the out directory
cd /opt/build
shopt -s extglob
cp -v -r !(moonlight-qt-$VERSION) /out

# Done!
echo "Build successful!"