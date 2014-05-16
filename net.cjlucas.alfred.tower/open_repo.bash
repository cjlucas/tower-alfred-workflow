#!/bin/bash

TOWER_PATH="/Applications/Tower.app"

if ! [ -d $TOWER_PATH ]; then
    TOWER_PATH=`find /Applications -type d -maxdepth 3 -name Tower.app`
fi

GITTOWER_PATH="$TOWER_PATH/Contents/MacOS/gittower"

# query comes from the arg key in the selected item attributes
query="{query}"

args="-s $1"

eval $GITTOWER_PATH $args
