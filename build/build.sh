#!/bin/bash

MODE=${1:-"build"}

if [ "$MODE" = "dev" ]; then
    INPUT_FILE="main.lua"
    OUTPUT_FILE="dist/main.lua"
    CONFIG_FILE="build/darklua.dev.config.json"
    # echo "Running in DEV mode (processing main.lua)"
else
    INPUT_FILE="src/init.lua"
    OUTPUT_FILE="dist/main.lua"
    CONFIG_FILE="build/darklua.dev.config.json"
    # echo "Running in BUILD mode (processing init.lua)"
fi

echo "-- Generated from package.json | build/build.sh \n\nreturn [[$(cat package.json)]]" > build/package.lua

DARKLUA_OUTPUT=$(darklua process "$INPUT_FILE" "$OUTPUT_FILE" --config "$CONFIG_FILE" 2>&1)

if [ $? -ne 0 ]; then
    echo "DarkLua ended with an error:"
    echo "$DARKLUA_OUTPUT"
    exit 1
fi

if echo "$DARKLUA_OUTPUT" | grep -q "successfully processed"; then
    FILE_COUNT=$(echo "$DARKLUA_OUTPUT" | sed -n 's/.*successfully processed \([0-9]\+\) file.*/\1/p')
    PROCESSING_TIME=$(echo "$DARKLUA_OUTPUT" | sed -n 's/.*in \([0-9.]\+\)ms).*/\1/p')
    
    lua build/init.lua "$FILE_COUNT" "$PROCESSING_TIME" "$MODE"
else
    echo "Failed to find successful processing data in the DarkLua output:"
    echo "$DARKLUA_OUTPUT"
    exit 1
fi