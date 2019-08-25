#!/bin/sh

echo "Merging bot_names diff..."
translation_tools merge_worksheet_diff bot_names.txt
echo "Done."
