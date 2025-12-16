# Plants-Vs-Zombies (LZ Linux version)
![C++](https://img.shields.io/badge/language-C%2B%2B-red)
![CMake](https://img.shields.io/badge/build-CMake-blue)
![Ubuntu](https://img.shields.io/badge/Ubuntu-Tests%20Passing-brightgreen?logo=ubuntu)

[Chinese version README click here.](README_zh_cn.md)

## Introduction <br>
This project is developed based on cocos2dx. The prototype of this project was originally developed by LZ and [released on Github](https://github.com/ErLinErYi/PlantsVsZombies). LZ's project is the best open-source Plants vs. Zombies project I've ever seen, with the best performance and the most complete functionality. Since I needed a C++ project to practice on the Ubuntu platform, I made some improvements and adjustments based on this project and re-released it.

## Overview <br>
After learning LZ's project, I discovered the following areas for improvement:
- LZ's project was set up on Windows using Visual Studio 2017, with project files managed through .vcxproj. However, since Visual Studio is not free and open-source software, and the manual configuration is relatively cumbersome, it is not conducive to promoting this project.
- The project's C++ code is approximately 18,000 lines, which is very comprehensive but somewhat overwhelming for beginners.
- The C++11 standard used in the project is becoming outdated.

To address these areas for improvement, I made the following changes:
- Since cocos2dx natively supports CMake configuration, I configured the project using CMake.
- I used the open-source VSCode for development, which is easy to install and configure quickly.
- I removed some secondary game effects and functionalities, reducing the project's size to 8,000 lines of C++ code, making it easier for beginners to learn.
- C++17 standard is applied to the cocos2dx library and project code.

Finally, based on my understanding of C++, I redesigned the basic classes of this project, including decoupling between classes, clarifying semantics, and applying C++17 syntax.

## Example
In the project’s root directory, there’s a video called `pvzExampleVideo.mkv` that shows the project in action. To avoid copyright issues, the game assets shared by LZ has been blurred. The unblurred gameplay is shown in the image below.

![Image(图片)](https://img-blog.csdnimg.cn/20200405101902466.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNjMwMjQ2,size_16,color_FFFFFF,t_70)

## Requirement
* Ubuntu 22.04 (for other Ubuntu versions, please test them on your own).
* CMake >= 3.16.

## Environment
1. Clone this project (install git-lfs first) and install the dependencies required for cocos2dx. Note that cocos2dx itself is already included with the project, so there’s no need for a separate installation.
```shell
git clone --recursive https://github.com/Xi-Gong/Plants-Vs-Zombies.git
cd Plants-Vs-Zombies/cocos2d/
sudo apt install python2.7 libxmu-dev libglu1-mesa-dev \
    libgl2ps-dev libxi-dev libzip-dev libpng-dev \
    libcurl4-gnutls-dev libfontconfig1-dev libsqlite3-dev \
    libglew-dev libssl-dev libgtk-3-dev binutils xorg-dev
python2.7 download-deps.py
cd build
./install-deps-linux.sh
```

2. Install PulseAudio for audio playback. However, be aware that PulseAudio currently has a bug that may cause it to crash when too many sound effects are played simultaneously.
```shell
sudo apt install pulseaudio
```

3. Modify `Plants-Vs-Zombies/Resources/resources/Text/TextPath.xml`, changing the absolute paths according to your cloned project.

4. Compile and run the project. Note that a copy of the game assets from the `Resources` directory will be placed in the `build/bin/pvz` directory.
```shell
sudo apt install cmake build-essential ninja-build
cd Plants-Vs-Zombies
mkdir build && cd build
cmake ..
make
cd bin/pvz
./pvz
```

## Class Diagram
Here, I made some modifications to the basic classes and drew the corresponding UML diagrams. For the original UML diagram, please refer to LZ's project.

![ClassDiagram](https://github.com/Xi-Gong/Plants-Vs-Zombies/blob/main/pvzBasicClassUML.png?raw=true)

## Game Asset
***Note: The game asset files are for learning purposes only. Do not use them for commercial purposes. If there is any infringement, please contact me.***

## Contacts
**Email: gongxi@mail.nankai.edu.cn** <br>

## Portmaster (ARM64 Handhelds)
This fork includes full support for [Portmaster](https://portmaster.games) on ARM64 handhelds with:
- **gl4es** for OpenGL → OpenGL ES translation (no X11 required)
- **FMOD audio** for music and sound effects
- **gptokeyb** controller support

### Quick Start
```bash
# 1. Build ARM64 libraries
./build_arm64_libs.sh

# 2. Download FMOD (auto-creates account)
./download_fmod_arm64.sh

# 3. Build and package
./package_portmaster.sh

# 4. Build gl4es (for KMS/DRM display)
cd /tmp && git clone https://github.com/ptitSeb/gl4es.git
cd gl4es && mkdir build && cd build
cmake .. -DNOX11=ON -DGLX_STUBS=ON -DEGL_WRAPPER=ON -DGBM=ON
make -j$(nproc)
cp /tmp/gl4es/lib/libGL.so.1 /path/to/pvz_portmaster/pvz/libs/
cp /tmp/gl4es/lib/libEGL.so.1 /path/to/pvz_portmaster/pvz/libs/
```

### Package Structure
```
pvz_portmaster/
├── pvz.sh                    # Launch script (goes to /roms/ports/)
└── pvz/                      # Game folder (goes to /roms/ports/pvz/)
    ├── pvz                   # ARM64 binary
    ├── Resources/            # Game assets
    ├── libs/
    │   ├── libGL.so.1        # gl4es (OpenGL → GLES)
    │   ├── libEGL.so.1       # EGL wrapper
    │   └── libfmod.so        # FMOD audio
    ├── game.gptk             # Controller mapping
    └── gameinfo.xml          # EmulationStation metadata
```

### Installation on Device
```bash
# Via SSH
scp -r pvz_portmaster/pvz.sh pvz_portmaster/pvz root@DEVICE_IP:/roms/ports/
```

### Controls (gptokeyb)
- **D-Pad/Analog**: Mouse movement
- **A**: Left click
- **B**: Right click
- **Start**: Enter
- **Back**: Escape

### Device Compatibility

This ARM64 build is compatible with the following devices:

| Device | Chipset | Compatible |
|--------|---------|------------|
| Anbernic RG353P/V/M/PS | RK3566 | ✅ Yes |
| Anbernic RG503 | RK3566 | ✅ Yes |
| Anbernic RG505 | Unisoc T618 | ✅ Yes |
| Anbernic RG35XX H/Plus/SP | H700 | ✅ Yes |
| Anbernic RG28XX | H700 | ✅ Yes |
| Anbernic RG40XX H/V | H700 | ✅ Yes |
| Anbernic RG CubeXX | RK3566 | ✅ Yes |
| Powkiddy RGB30 | RK3566 | ✅ Yes |
| Powkiddy X55 | RK3566 | ✅ Yes |
| Powkiddy RGB20SX | RK3326 | ✅ Yes |
| AYANEO Pocket S | Snapdragon G3x Gen 2 | ✅ Yes |
| Raspberry Pi 4/5 | BCM2711/2712 | ✅ Yes |
| Orange Pi 5 | RK3588S | ✅ Yes |

**Not Compatible (different architecture):**
| Device | Reason |
|--------|--------|
| Anbernic RG351P/M/V | RK3326 (32-bit OS) |
| Anbernic RG350/M | MIPS architecture |
| Miyoo Mini/Plus | ARM32 Sigma Star |
| PCs/Laptops | x86_64 (requires separate build) |

**Requirements:**
- 64-bit ARM Linux OS (ROCKNIX, ArkOS, JELOS, Batocera, muOS, Knulli, etc.)
- OpenGL ES 2.0 support (uses gl4es for OpenGL translation)
- ~20 MB storage for game + libs

**Included Libraries:**
- `libGL.so.1` - gl4es (OpenGL → OpenGL ES 2.0 translation)
- `libEGL.so.1` - EGL wrapper for KMS/DRM output
- `libfmod.so` - FMOD audio library

> **Graphics:** This build uses gl4es for KMS/DRM display output without X11.
> The launch script sets `LIBGL_ES=2`, `LIBGL_GL=21`, `LIBGL_FB=4` for proper gl4es operation.

### Audio Support
This build includes FMOD audio for full sound effects and music.
The FMOD library is included in the `libs/` folder.
