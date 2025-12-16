#!/bin/bash

# Plants Vs Zombies - Portmaster Launch Script

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"

get_controls

GAMEDIR="/$directory/ports/plantsvsz"
cd $GAMEDIR

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

# Library path for game libs, gl4es, and FMOD
export LD_LIBRARY_PATH="$GAMEDIR/libs:$LD_LIBRARY_PATH"

# GL4ES settings for OpenGL -> OpenGL ES translation
export LIBGL_ES=2
export LIBGL_GL=21
export LIBGL_FB=4

# SDL controller config
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

# Use gl4es from controlfolder if available
if [ -f "${controlfolder}/libgl_${CFW_NAME}.txt" ]; then
  source "${controlfolder}/libgl_${CFW_NAME}.txt"
else
  if [ -f "${controlfolder}/libgl_default.txt" ]; then
    source "${controlfolder}/libgl_default.txt"
  fi
fi

# Launch gptokeyb for gamepad -> mouse/keyboard
$GPTOKEYB "pvz" -c "$GAMEDIR/game.gptk" &

pm_platform_helper "$GAMEDIR/pvz"

# Run the game
./pvz

pm_finish
