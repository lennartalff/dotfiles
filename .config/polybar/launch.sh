#!/bin/bash


polybar-msg cmd quit

echo "---" | tee -a /tmp/polybar1.log 
if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload bar1 &
    done
else
    polybar --reload bar1 &
fi

# polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
