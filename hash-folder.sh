#!/bin/sh

pushd $1
	for file in $(ls); do
		mv $file $(sha256sum $file | cut -d' ' -f1)-$(basename $file)
	done
popd
