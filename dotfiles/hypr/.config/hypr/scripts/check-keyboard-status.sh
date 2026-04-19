#!/bin/bash

if pgrep -x "wvkbd-mobintl" > /dev/null; then
    echo "Active"
else
    echo "Inactive"
fi
