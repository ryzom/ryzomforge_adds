#!/bin/bash

function convert_image {
	cd $1
	for a in *.png
	do
		echo $a
		if [ ! -f ../$2/$a ]
		then
			convert -resize 50% $a ../$2/$a
		fi
	done
	cd ..
}


convert_image texture_interfaces_dxtc_2x texture_interfaces_dxtc
convert_image texture_interfaces_v3_2x texture_interfaces_v3


