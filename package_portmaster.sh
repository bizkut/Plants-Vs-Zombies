#!/bin/bash

# Configuration
BUILD_DIR="build_portmaster"
PACKAGE_DIR="pvz_portmaster"
BINARY_NAME="pvz"

# Clean previous build
rm -rf $BUILD_DIR $PACKAGE_DIR

# Create directories
mkdir -p $BUILD_DIR
mkdir -p $PACKAGE_DIR/pvz
mkdir -p $PACKAGE_DIR/pvz/libs

# Build
cd $BUILD_DIR
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
cd ..

# Check if binary exists
if [ -f "$BUILD_DIR/bin/pvz/$BINARY_NAME" ]; then
    echo "Build successful!"
else 
    # Try looking in root build dir if not in bin/ (depends on cmake/cocos config)
    if [ -f "$BUILD_DIR/$BINARY_NAME" ]; then
         echo "Build successful (in root)!"
    else
        echo "Build failed. Binary not found."
        exit 1
    fi
fi

# Locate binary
if [ -f "$BUILD_DIR/bin/pvz/$BINARY_NAME" ]; then
    CP_BIN="$BUILD_DIR/bin/pvz/$BINARY_NAME"
else
    CP_BIN="$BUILD_DIR/$BINARY_NAME"
fi

# Copy Files
cp "$CP_BIN" "$PACKAGE_DIR/pvz/"
cp -r Resources "$PACKAGE_DIR/pvz/"
cp launch.sh "$PACKAGE_DIR/pvz/"
cp game.gptk "$PACKAGE_DIR/pvz/"
cp gameinfo.xml "$PACKAGE_DIR/pvz/"

# Instructions for libs
echo ""
echo "Packaging complete in ./$PACKAGE_DIR"
echo "IMPORTANT: You may need to populate '$PACKAGE_DIR/pvz/libs' with ARM64 shared libraries."
echo "If cross-compiling, copy the necessary .so files there."
echo "You can zip the 'pvz' folder and the 'launch.sh' (wait, launch.sh usually goes in root of ports?)"
echo "Standard Portmaster structure:"
echo "  /roms/ports/pvz/ (all game files)"
echo "  /roms/ports/pvz.sh (script pointing to the game dir)"
echo ""
echo "Correcting structure..."

# Fix structure for Portmaster distribution
# Usually:
#   pvz.zip
#     |-- pvz/ (directory with data)
#     |-- pvz.sh (launch script)

# But we defined launch.sh INSIDE the dir in our script. 
# Portmaster often likes: /roms/ports/GameName.sh -> /roms/ports/GameName/launch.sh
# Let's clean this up to match standard practice.
# We will put the launch script inside the game dir as launch.sh, and creating a wrapper script ??
# Or just renaming launch.sh to pvz.sh and putting it outside.

# Re-reading my own launch.sh:
# GAMEDIR="/$directory/ports/pvz"
# This implies launch.sh is pvz.sh and is outside? OR it is inside and $directory is resolved?
# Usually in Portmaster:
# /roms/ports/MyGame.sh
# /roms/ports/MyGame/ (data)

# Let's adjust packaging:
mv "$PACKAGE_DIR/pvz/launch.sh" "$PACKAGE_DIR/pvz.sh"

echo "Final structure ready in $PACKAGE_DIR"
