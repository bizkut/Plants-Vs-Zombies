#!/bin/bash
# Package script for Portmaster submission
# Creates the proper port structure per https://portmaster.games/packaging.html

set -e

PORTNAME="plantsvsz"
PORTSCRIPT="Plants Vs Zombies.sh"
BUILD_DIR="build_portmaster"
OUTPUT_DIR="$PORTNAME"

echo "=== Plants Vs Zombies Portmaster Packager ==="

# Step 1: Build the game
echo "Step 1: Building game..."
mkdir -p $BUILD_DIR
cd $BUILD_DIR
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
cd ..

# Check if build succeeded
if [ ! -f "$BUILD_DIR/bin/pvz/pvz" ]; then
    echo "ERROR: Build failed - binary not found at $BUILD_DIR/bin/pvz/pvz"
    exit 1
fi

echo "Build successful!"

# Step 2: Create Portmaster package structure
echo "Step 2: Creating Portmaster package structure..."
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/$PORTNAME/libs"
mkdir -p "$OUTPUT_DIR/$PORTNAME/licenses"

# Copy port metadata files (goes in root portname folder)
cp port.json "$OUTPUT_DIR/"
cp README.md "$OUTPUT_DIR/"
cp gameinfo.xml "$OUTPUT_DIR/"

# Copy launch script with proper name
cp launch.sh "$OUTPUT_DIR/$PORTSCRIPT"
chmod +x "$OUTPUT_DIR/$PORTSCRIPT"

# Copy game files to subfolder
cp "$BUILD_DIR/bin/pvz/pvz" "$OUTPUT_DIR/$PORTNAME/"
chmod +x "$OUTPUT_DIR/$PORTNAME/pvz"
cp -r Resources "$OUTPUT_DIR/$PORTNAME/"
cp game.gptk "$OUTPUT_DIR/$PORTNAME/"

# Copy licenses
cp licenses/* "$OUTPUT_DIR/$PORTNAME/licenses/"

# Copy libraries (FMOD)
if [ -f "cocos2d/external/linux-specific/fmod/prebuilt/arm64/libfmod.so" ]; then
    cp cocos2d/external/linux-specific/fmod/prebuilt/arm64/libfmod.so "$OUTPUT_DIR/$PORTNAME/libs/"
    echo "  - FMOD library copied"
fi

# Build and copy gl4es if not present
if [ ! -f "$OUTPUT_DIR/$PORTNAME/libs/libGL.so.1" ]; then
    echo "Step 3: Building gl4es..."
    if [ -d "/tmp/gl4es" ]; then
        rm -rf /tmp/gl4es
    fi
    git clone --depth 1 https://github.com/ptitSeb/gl4es.git /tmp/gl4es
    mkdir -p /tmp/gl4es/build
    cd /tmp/gl4es/build
    cmake .. -DNOX11=ON -DGLX_STUBS=ON -DEGL_WRAPPER=ON -DGBM=ON 2>/dev/null
    make -j$(nproc) 2>/dev/null
    cd -
    cp /tmp/gl4es/lib/libGL.so.1 "$OUTPUT_DIR/$PORTNAME/libs/"
    cp /tmp/gl4es/lib/libEGL.so.1 "$OUTPUT_DIR/$PORTNAME/libs/"
    echo "  - gl4es libraries copied"
fi

# Step 4: Create the zip file
echo "Step 4: Creating zip package..."
cd "$OUTPUT_DIR"
zip -r "../${PORTNAME}.zip" .
cd ..

echo ""
echo "=== Package Complete ==="
echo "Output: ${PORTNAME}.zip"
echo ""
echo "Structure:"
find "$OUTPUT_DIR" -type f | head -20
echo ""
echo "To submit to Portmaster:"
echo "  1. Add screenshot.png (gameplay, 640x480 min, 4:3 ratio)"
echo "  2. Fork https://github.com/PortMaster/PortMaster-New"
echo "  3. Add $PORTNAME folder to ports/"
echo "  4. Create Pull Request"
