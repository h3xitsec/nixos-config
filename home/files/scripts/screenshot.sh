#!/usr/bin/env bash

grim -g "$(slurp -b 1B1F28CC -c E06B74ff -s C778DD0D -w 2)" - | satty --filename - --output-filename ~/Pictures/Screenshots/Screenshot_$time.png --init-tool brush --copy-command wl-copy
