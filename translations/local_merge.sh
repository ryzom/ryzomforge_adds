#!/bin/sh

# cleanup diff directory
rm -f translation/bin/.#*.*
rm -f translation/diff/*.*
rm -f translation/history/*.*
rm -f translation/translated/*.*
rm -f translation/work/*.*
rm -f translation/.#*.*
rm -f translation/*.log

# get lastest Hg clean copy
hg pull && hg update

validate_diffs()
{
	# remove the last 2 lines from the 'diff' files
	cd diff

	for filename in $(ls *.?xt)
  do
	  # we remove 3 lines because there is a pending new line at end of file that count for 1 line
	  translation_tools crop_lines $filename 3
	done

	cd ..
}

make_translation()
{
	# run the 'make' batch files
	./1_make_phrase_diff.sh
	./5_make_words_diff.sh
	./A_make_string_diff.sh
	./C_make_bot_names_diff.sh

	validate_diffs

	# run the 'merge' batch files
	./2_merge_phrase_diff.sh
	./6_merge_words_diff.sh
	./B_merge_string_diff.sh
	./D_merge_bot_names_diff.sh

	# second run for the clause diff
	./3_make_clause_diff.sh
	validate_diffs
	./4_merge_clause_diff.sh
}

# First run, translate wk to translation
make_translation
# Second run, translate wk to other languages
make_translation

# run the 'install' batch files
for f in $(ls *install*.sh)
do
  ./$f
done
