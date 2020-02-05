set -e

# Check out the source
[[ ! -z "$BRANCH" ]] || BRANCH="master"
echo "Checking out $BRANCH"
git clone --recursive --branch $BRANCH --depth 1 https://github.com/moonlight-stream/moonlight-qt.git
cd moonlight-qt
git log -1

# Grab the verson metadata
VERSION=`cat app/version.txt`

# Create a build directory
mkdir /opt/build

# Nuke the libs folder - not needed for Linux
git rm -r libs
git commit -m "Remove pre-built libraries"

# Generate source tarball
scripts/generate-src.sh

# Move the tarball into the build directory
mv build/source/MoonlightSrc-$VERSION.tar.gz /opt/build/moonlight_$VERSION.orig.tar.gz 

# Extract the tarball into the appropriate directory
cd /opt/build
mkdir moonlight-$VERSION
cd moonlight-$VERSION
tar xvf ../moonlight_$VERSION.orig.tar.gz

# Copy the debian directory into the build directory
cp -r /opt/debian .

# Build the package
debuild -us -uc

# Copy the output to the out directory
cp /opt/build/* /out

# Done!
echo "Build successful!"