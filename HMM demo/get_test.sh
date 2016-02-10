#!/bin/bash
#	This file is to get audio files from test set for small subset
# of words.  This file must be placed inside 'etc' directory of an4 db.
words=(YES NO GO STOP HELP)

echo "Please input locatio you would like data, followed by [ENTER]:"
read datadir

for word in ${words[*]}; do
	echo Copying data from $word
	if [ ! -d $datadir/$word ]; then
		mkdir $datadir/$word
	fi
	for filename in $(cat an4_test.transcription | grep $word | grep -o -P '(?<=\().*(?=\))'); do
		for file in $(cat an4_test.fileids | grep $filename | tr -s '[:space:]'); do
			if [ -a "../wav/$file.raw" ]; then
				cp ../wav/$file.raw $datadir/$word/
			fi
		done
	done
done
