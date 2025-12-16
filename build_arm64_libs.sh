#!/bin/bash

# Build all external libraries for ARM64
# Run this script from the Plants-Vs-Zombies root directory

set -e

EXTERNAL_DIR="/home/parallels/Plants-Vs-Zombies/cocos2d/external"
BUILD_TMP="/tmp/cocos_arm64_build"

# Create directories
mkdir -p "$BUILD_TMP"

# Create arm64 directories for each library
mkdir -p "$EXTERNAL_DIR/webp/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/openssl/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/websockets/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/freetype2/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/jpeg/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/Box2D/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/bullet/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/uv/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/tiff/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/png/prebuilt/linux/arm64"
mkdir -p "$EXTERNAL_DIR/zlib/prebuilt/linux/arm64"
# Chipmunk already done

echo "Building freetype2..."
cd "$BUILD_TMP"
if [ ! -d "freetype" ]; then
    git clone --depth 1 https://gitlab.freedesktop.org/freetype/freetype.git
fi
cd freetype
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
make -j$(nproc)
cp libfreetype.a "$EXTERNAL_DIR/freetype2/prebuilt/linux/arm64/"

echo "Building libjpeg-turbo..."
cd "$BUILD_TMP"
if [ ! -d "libjpeg-turbo" ]; then
    git clone --depth 1 https://github.com/libjpeg-turbo/libjpeg-turbo.git
fi
cd libjpeg-turbo
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=OFF
make -j$(nproc)
cp libjpeg.a "$EXTERNAL_DIR/jpeg/prebuilt/linux/arm64/"

echo "Building libpng..."
cd "$BUILD_TMP"
if [ ! -d "libpng" ]; then
    git clone --depth 1 https://github.com/glennrp/libpng.git
fi
cd libpng
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DPNG_SHARED=OFF
make -j$(nproc)
cp libpng*.a "$EXTERNAL_DIR/png/prebuilt/linux/arm64/" 2>/dev/null || true

echo "Building zlib..."
cd "$BUILD_TMP"
if [ ! -d "zlib" ]; then
    git clone --depth 1 https://github.com/madler/zlib.git
fi
cd zlib
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
cp libz.a "$EXTERNAL_DIR/zlib/prebuilt/linux/arm64/"

echo "Building libwebp..."
cd "$BUILD_TMP"
if [ ! -d "libwebp" ]; then
    git clone --depth 1 https://chromium.googlesource.com/webm/libwebp
fi
cd libwebp
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
make -j$(nproc)
cp libwebp.a "$EXTERNAL_DIR/webp/prebuilt/linux/arm64/"

echo "Building libuv..."
cd "$BUILD_TMP"
if [ ! -d "libuv" ]; then
    git clone --depth 1 https://github.com/libuv/libuv.git
fi
cd libuv
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF
make -j$(nproc)
cp libuv_a.a "$EXTERNAL_DIR/uv/prebuilt/linux/arm64/"

echo "Building libtiff..."
cd "$BUILD_TMP"
if [ ! -d "libtiff" ]; then
    git clone --depth 1 https://gitlab.com/libtiff/libtiff.git
fi
cd libtiff
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
make -j$(nproc)
cp libtiff/libtiff.a "$EXTERNAL_DIR/tiff/prebuilt/linux/arm64/" 2>/dev/null || cp libtiff.a "$EXTERNAL_DIR/tiff/prebuilt/linux/arm64/" 2>/dev/null || true

echo "Building Box2D..."
cd "$BUILD_TMP"
if [ ! -d "box2d" ]; then
    git clone --depth 1 --branch v2.4.1 https://github.com/erincatto/box2d.git
fi
cd box2d
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBOX2D_BUILD_UNIT_TESTS=OFF -DBOX2D_BUILD_TESTBED=OFF
make -j$(nproc)
cp src/libbox2d.a "$EXTERNAL_DIR/Box2D/prebuilt/linux/arm64/" 2>/dev/null || cp libbox2d.a "$EXTERNAL_DIR/Box2D/prebuilt/linux/arm64/" 2>/dev/null || true

echo "Building bullet..."
cd "$BUILD_TMP"
if [ ! -d "bullet3" ]; then
    git clone --depth 1 https://github.com/bulletphysics/bullet3.git
fi
cd bullet3
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF -DBUILD_EXTRAS=OFF -DBUILD_UNIT_TESTS=OFF
make -j$(nproc)
cp lib/*.a "$EXTERNAL_DIR/bullet/prebuilt/linux/arm64/" 2>/dev/null || true

echo "Building OpenSSL..."
cd "$BUILD_TMP"
if [ ! -d "openssl" ]; then
    git clone --depth 1 https://github.com/openssl/openssl.git
fi
cd openssl
./Configure linux-aarch64 no-shared --prefix="$BUILD_TMP/openssl_install"
make -j$(nproc)
cp libssl.a "$EXTERNAL_DIR/openssl/prebuilt/linux/arm64/"
cp libcrypto.a "$EXTERNAL_DIR/openssl/prebuilt/linux/arm64/"

echo "Building libwebsockets..."
cd "$BUILD_TMP"
if [ ! -d "libwebsockets" ]; then
    git clone --depth 1 https://github.com/warmcat/libwebsockets.git
fi
cd libwebsockets
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DLWS_WITH_SSL=ON -DLWS_WITH_SHARED=OFF -DLWS_WITH_STATIC=ON -DLWS_WITHOUT_TESTAPPS=ON
make -j$(nproc)
cp lib/libwebsockets.a "$EXTERNAL_DIR/websockets/prebuilt/linux/arm64/"

echo "All ARM64 libraries built!"
