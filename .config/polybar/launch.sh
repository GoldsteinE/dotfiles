#!/bin/sh
pkill polybar
for m in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do
	POLYBAR_MONITOR="$m" polybar main &
	POLYBAR_MONITOR="$m" polybar top &
done
