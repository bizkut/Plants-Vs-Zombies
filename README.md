## Notes

Thanks to the original Plants vs Zombies game by PopCap Games and the open-source Cocos2d-x community for making this port possible!

This is a Cocos2d-x based recreation/port of the classic tower defense game.

> **Note:** This port uses gl4es for OpenGL to OpenGL ES translation, allowing it to run on devices without X11.

## Controls

| Button | Action |
|--------|--------|
| D-Pad / Left Analog | Move cursor |
| A | Left click (select/place) |
| B | Right click (cancel) |
| Start | Enter/Confirm |
| Select | Escape/Back |

## Building from Source

```bash
# 1. Build ARM64 libraries
./build_arm64_libs.sh

# 2. Download FMOD audio library
./download_fmod_arm64.sh

# 3. Build and package
./package_portmaster.sh
```

## Included Libraries

- **gl4es** - OpenGL to OpenGL ES translation
- **FMOD** - Audio library for ARM64 Linux
- **Cocos2d-x** - Game engine

## License

- Game engine: MIT License (Cocos2d-x)
- gl4es: MIT License
- FMOD: FMOD License (non-commercial)
