#!/bin/bash
logger "Running $0"

/usr/bin/synclient MaxTapTime=180 TapButton1=1 \
  PalmDetect=1 PalmMinWidth=4 PalmMinZ=40 \
  VertEdgeScroll=0 ClickFinger2=3 \
  HorizHysteresis=50 VertHysteresis=50 \
  CoastingSpeed=0 \
  RightButtonAreaLeft=0 RightButtonAreaRight=0 \
  RightButtonAreaTop=0 RightButtonAreaBottom=0 \
  VertScrollDelta=-111 HorizScrollDelta=-111

