#!/bin/sh

DIR=$(dirname $(readlink -f "$0"))
mkdir -p $DIR/out

# Loop over a list of dirs that were passed as parameters
for fw in "$@"
do
	pushd $fw
		VERSION=$(grep -Po 'release version="[^"]+"' *.metainfo.xml | \
			cut -d'"' -f2)
		NAME=$(basename $fw)
		MODEL=$(basename $(dirname $fw))

		mkdir $DIR/tmp
		cp *.metainfo.xml $DIR/tmp/firmware.metainfo.xml
		cp *.bin $DIR/tmp/firmware.bin
		cp *.cat $DIR/tmp/firmware.cat
		cp *.inf $DIR/tmp/firmware.inf
		sed -e "s|$(ls *.cat)|firmware.cat|g" -e "s|$(ls *.bin)|firmware.bin|g" \
			-i $DIR/tmp/firmware.inf
		$DIR/tools/lcab -n $DIR/tmp/* $DIR/out/$MODEL\_$NAME\_$VERSION.cab
		rm -r $DIR/tmp
	popd
done
