#!/bin/bash

if [[ $1 != "0" && $1 != "1" ]]; then
  echo "Usage: $0 0|1" >&2
  echo "1 inhibits, 0 uninhibits." >&2
  exit 2
fi

echo -n "inhibit: "
echo $1 | sudo tee /sys/devices/platform/i8042/serio1/input/input7/inhibited

