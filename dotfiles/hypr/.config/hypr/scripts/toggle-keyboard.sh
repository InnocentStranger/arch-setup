#!/bin/bash

# The executable is named wvkbd-mobintl
if pgrep -x "wvkbd-mobintl" > /dev/null; then
    # If it's running, close it
    killall wvkbd-mobintl
else
    # If it isn't running, launch it in the background.
    # Setting both -H and -L ensures it is 300px tall regardless of screen orientation.
    wvkbd-mobintl -H 300 -L 300 &
fi
