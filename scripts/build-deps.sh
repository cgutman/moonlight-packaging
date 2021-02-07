set -e

BASE_FFMPEG_ARGS="--enable-pic --enable-static --disable-shared --disable-all --enable-avcodec --enable-decoder=h264 --enable-decoder=hevc --enable-decoder=h264_v4l2m2m --enable-decoder=hevc_v4l2m2m --extra-cflags=-I/usr/include/libdrm"

ARCH=`uname -m`
echo "Building dependencies for $ARCH"
if [ "$ARCH" == "armv7l" ]; then
    # Copy libraspberrypi-dev pkgconfig files into the default location
    mkdir -p /usr/local/lib/pkgconfig
    cp /opt/vc/lib/pkgconfig/* /usr/local/lib/pkgconfig/

    # Enable MMAL decoders
    EXTRA_FFMPEG_ARGS="--enable-mmal --enable-decoder=h264_mmal"
elif [ "$ARCH" == "aarch64" ]; then
    # Enable NVMPI decoders
    EXTRA_FFMPEG_ARGS="--enable-nvmpi --enable-decoder=h264_nvmpi --enable-decoder=hevc_nvmpi"
elif [ "$ARCH" == "x86_64" ]; then
    # We need to install the NVDEC headers
    cd /opt/nv-codec-headers
    make install

    # Enable VAAPI, VDPAU, and NVDEC decoders
    EXTRA_FFMPEG_ARGS="--enable-nvdec --enable-hwaccel=h264_nvdec --enable-hwaccel=hevc_nvdec --enable-hwaccel=h264_vaapi --enable-hwaccel=hevc_vaapi --enable-hwaccel=h264_vdpau --enable-hwaccel=hevc_vdpau"
else
    echo "Unrecognized architecture: $ARCH"
    exit 1
fi

# Build and install our SDL2 build
cd /opt/SDL2
./configure --enable-static --disable-shared --enable-video-kmsdrm --disable-video-rpi
make -j$(nproc)
cat sdl2.pc
make install

# Build and install SDL_ttf
# Since we'll be linking statically, we need to use Libs.private instead of Libs, but
# there's no way to tell QMake to use the Libs.private section, so we have to replace
# Libs with Libs.private ourselves prior to installation.
cd /opt/SDL_ttf
./configure --enable-static --disable-shared
make -j$(nproc)
sed -i 's/-lSDL2_ttf/-lSDL2_ttf -lfreetype/g' SDL2_ttf.pc
cat SDL2_ttf.pc
make install

cd /opt/FFmpeg
./configure $BASE_FFMPEG_ARGS $EXTRA_FFMPEG_ARGS
make -j$(nproc)
make install
