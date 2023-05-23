#!/bin/zsh
# vim:ft=sh

OUTPUTS=($(xrandr -q | sed -n "s/^\(\S*\) connected.*$/\1/p"))
FADE_STEPS=200
FADE_DURATION=10
BRIGHTNESS=($(xrandr --verbose | sed -n 's/\s*Brightness: \([0-9]*\.[0-9]*\).*$/\1/p'))


reset_brightness() {
  for ((i=1; i<=$#OUTPUTS; i++)); do
    xrandr --output ${OUTPUTS[$i]} --brightness ${BRIGHTNESS[$i]}
  done
}


fade() {
  local level
  start_time=$(date +%s.%6N)
  for factor in {$FADE_STEPS..0};do
    factor=$((1.0 * $factor / $FADE_STEPS))
    sleep_until=$(( $start_time + (1.0 - $factor) * $FADE_DURATION ))
    for ((i=1; i<=$#OUTPUTS; i++));do
      xrandr --output ${OUTPUTS[$i]} --brightness $(($factor * ${BRIGHTNESS[$i]}))
    done
    now=$(date +%s.%6N)
    sleep_time=$(( $sleep_until - $now ))
    [[ $sleep_time > 0.0 ]] && sleep $sleep_time
  done 
}

trap 'exit 0' TERM INT

trap "reset_brightness; kill %%" EXIT
fade
sleep 2147483647 &
wait
