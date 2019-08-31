#!/bin/sh

VER=$1

MAJOR=$(($(($VER >> 24)) & 0xff))
MINOR=$(($(($VER >> 16)) & 0xff))
REV=$(($VER & 0xffff))

echo "$MAJOR.$MINOR.$REV"
