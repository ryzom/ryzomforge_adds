#!/bin/sh

cd bin

rm -f log.log
input_output_service -Q

LOG_ANALYSER_PATH=$(which log_analyser)

if [ -x "$LOG_ANALYSER_PATH" ]
then
	log_analyser log.log
else
	less log.log
fi

cd ..
