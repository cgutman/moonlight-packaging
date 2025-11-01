set -e

BASE_FFMPEG_ARGS="--fatal-warnings --enable-pic --enable-static --disable-shared --disable-all --disable-vulkan --enable-avcodec --enable-swscale --enable-decoder=h264 --enable-decoder=hevc --enable-decoder=av1 --enable-libdav1d --enable-decoder=libdav1d --enable-libdrm --enable-decoder=h264_v4l2m2m --enable-decoder=hevc_v4l2m2m --extra-cflags=-I/usr/include/libdrm"
USE_PLATFORM_FFMPEG=0

echo "Building dependencies for $TARGET"
if [ "$TARGET" == "rpi" ] || [ "$TARGET" == "rpi64" ]; then
    # Use the platform-provided FFmpeg version on Raspberry Pi OS
    USE_PLATFORM_FFMPEG=1
elif [ "$TARGET" == "l4t" ]; then
    # Enable NVV4L2 decoders (and VP9 decoder to work around compilation error in NVV4L2 fallback code)
    EXTRA_FFMPEG_ARGS="--enable-nvv4l2 --enable-decoder=h264_nvv4l2 --enable-decoder=hevc_nvv4l2 --enable-decoder=vp9"
elif [ "$TARGET" == "desktop" ]; then
    # Enable VAAPI and VDPAU decoders (TODO: Add Vulkan Video if we ever actually ship this for desktop platforms)
    EXTRA_FFMPEG_ARGS="--enable-hwaccel=h264_vaapi --enable-hwaccel=hevc_vaapi --enable-hwaccel=av1_vaapi --enable-hwaccel=h264_vdpau --enable-hwaccel=hevc_vdpau --enable-hwaccel=av1_vdpau"
elif [ "$TARGET" == "embedded" ]; then
    # Enable stateless V4L2 support
    EXTRA_FFMPEG_ARGS="--enable-v4l2-request --enable-hwaccel=h264_v4l2request --enable-hwaccel=hevc_v4l2request"
else
    echo "Unrecognized target: $TARGET"
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
./autogen.sh
./configure --enable-static --disable-shared
make -j$(nproc)
sed -i 's/-lSDL2_ttf/-lSDL2_ttf -lfreetype/g' SDL2_ttf.pc
cat SDL2_ttf.pc
make install

# Build FFmpeg and its dependencies if we're not using the platform version
if [ "$USE_PLATFORM_FFMPEG" == "0" ]; then
    # Build and install libdav1d
    cd /opt/dav1d
    meson setup build -Ddefault_library=static -Dbuildtype=debugoptimized -Denable_tools=false -Denable_tests=false
    ninja -C build
    ninja install -C build

    # Build and install FFmpeg
    cd /opt/FFmpeg
    ./configure $BASE_FFMPEG_ARGS $EXTRA_FFMPEG_ARGS $DAV1D_FFMPEG_ARGS
    make -j$(nproc)
    make install
fi
