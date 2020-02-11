set -e

BASE_FFMPEG_ARGS="--enable-pic --enable-static --disable-shared --disable-all --enable-avcodec --enable-decoder=h264 --enable-decoder=hevc"

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

# Remove the existing SDL2 library (but not SDL_ttf)
find /usr/include/SDL2 -type f -not -name 'SDL_ttf.h' -delete
rm -fv /usr/lib/*-linux-*/libSDL2-*
rm -fv /usr/lib/*-linux-*/libSDL2.*
rm -fv /usr/lib/*-linux-*/pkgconfig/sdl2.pc

cd /opt/SDL2
./configure --enable-static --disable-shared --enable-video-kmsdrm
make -j$(nproc)
make install

cd /opt/FFmpeg
./configure $BASE_FFMPEG_ARGS $EXTRA_FFMPEG_ARGS
make -j$(nproc)
make install
