#!/bin/bash

# PortMaster PvZ Launch Script
# Get the PortMaster directory
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
source $controlfolder/device_info.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"

get_controls

GAMEDIR="/$directory/ports/pvz"
cd $GAMEDIR

# Library path for game libs and FMOD
export LD_LIBRARY_PATH="$GAMEDIR/libs:$LD_LIBRARY_PATH"

# GL4ES settings for OpenGL → OpenGL ES translation
export LIBGL_ES=2
export LIBGL_GL=21
export LIBGL_FB=4

# If GL4ES library exists in libs, use it
if [ -f "$GAMEDIR/libs/libGL.so.1" ]; then
    export LIBGL_DRIVERS_PATH="$GAMEDIR/libs"
fi

# Launch gptokeyb for gamepad → mouse/keyboard
$GPTOKEYB "pvz" -c "$GAMEDIR/game.gptk" &

# Run the game
./pvz 2>&1 | tee "$GAMEDIR/log.txt"

# Cleanup
$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" > /dev/tty0
