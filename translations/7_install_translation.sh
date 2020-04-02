#!/bin/sh
echo "Installing translation file into ryzom..."

# Copy translated files in client directory...
cp -a translated/*.uxt ../../client/data/gamedev/language
cp -a translated/skill_*.txt ../../client/data/gamedev/language
cp -a translated/item_*.txt ../../client/data/gamedev/language
cp -a translated/creature_*.txt ../../client/data/gamedev/language
cp -a translated/sbrick_*.txt ../../client/data/gamedev/language
cp -a translated/sphrase_*.txt ../../client/data/gamedev/language
cp -a translated/place_*.txt ../../client/data/gamedev/language
cp -a translated/faction_*.txt ../../client/data/gamedev/language
cp -a translated/title_*.txt ../../client/data/gamedev/language
cp -a translated/outpost_*.txt ../../client/data/gamedev/language

# Copy translated files in server directory...
cp -a translated/*.txt ../data_shard/language

echo Done.
