#!/bin/sh

DIR=$(dirname $(readlink -f "$0"))
mkdir -p $DIR/out

# Loop over a list of dirs that were passed as parameters
for fw in "$@"
do
	pushd $fw
		VERSION=$(grep -Po 'version: "[^"]+"' *.metainfo.xml | \
			cut -d'"' -f2)
		NAME=$(basename $fw)
		MODEL=$(basename $(dirname $fw))

		BINFILE=$(ls *.{bin,cap})
		CATFILE=$(ls *.cat)
		INFFILE=$(ls *.inf)

		mkdir $DIR/tmp
		cp *.metainfo.xml $DIR/tmp/firmware.metainfo.xml
		cp $BINFILE $DIR/tmp/firmware.bin
		cp $CATFILE $DIR/tmp/firmware.cat
		cp $INFFILE $DIR/tmp/firmware.inf
		sed -e "s|$CATFILE|firmware.cat|g" \
			-e "s|$BINFILE|firmware.bin|g" \
			-i $DIR/tmp/firmware.inf
		$DIR/tools/lcab -n $DIR/tmp/* \
			$DIR/out/$MODEL\_$NAME\_$VERSION.cab
		rm -r $DIR/tmp
	popd
done
