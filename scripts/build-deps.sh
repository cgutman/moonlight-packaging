set -e

BASE_FFMPEG_ARGS="--enable-pic --enable-static --disable-shared --disable-all --enable-avcodec --enable-decoder=h264 --enable-decoder=hevc --enable-hwaccel=h264_vaapi --enable-hwaccel=hevc_vaapi --enable-hwaccel=h264_vdpau --enable-hwaccel=hevc_vdpau"

ARCH=`uname -m`
echo "Building dependencies for $ARCH"
if [ "$ARCH" == "armv7l" ]; then
    # Enable MMAL decoders
    EXTRA_FFMPEG_ARGS="--enable-mmal --enable-decoder=h264_mmal"
elif [ "$ARCH" == "aarch64" ]; then
    # Enable NVMPI decoders
    EXTRA_FFMPEG_ARGS="--enable-nvmpi --enable-decoder=h264_nvmpi --enable-decoder=hevc_nvmpi"
elif [ "$ARCH" == "x86_64" ]; then
    # We need to install the NVDEC headers
    cd /opt/nv-codec-headers
    make install PREFIX=/usr

    # Enable NVDEC decoders
    EXTRA_FFMPEG_ARGS="--enable-nvdec --enable-hwaccel=h264_nvdec --enable-hwaccel=hevc_nvdec"
else
    echo "Unrecognized architecture: $ARCH"
    exit 1
fi

cd /opt/FFmpeg
./configure $BASE_FFMPEG_ARGS $EXTRA_FFMPEG_ARGS
make -j$(nproc)
make install
