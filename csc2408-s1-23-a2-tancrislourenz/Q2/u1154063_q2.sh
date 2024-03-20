#!/bin/bash



#default directories.

dailyingest_dir=~/dailyingest

audio_dir=~/audio

byDate_dir=$audio_dir/byDate

byContributor_dir=$audio_dir/byContributor

byTopic_dir=$audio_dir/byTopic

badfiles_dir=~/badfiles



# replacement directories (if specified)

if [ $# -eq 3 ]; then

dailyingest_dir=$1

audio_dir=$2

badfiles_dir=$3

fi



#creating needed directories.

mkdir -p $dailyingest_dir

mkdir -p $audio_dir

mkdir -p $byDate_dir

mkdir -p $byContributor_dir/Stan

mkdir -p $byContributor_dir/Livia

mkdir -p $byContributor_dir/Mark

mkdir -p $byTopic_dir/sport

mkdir -p $byTopic_dir/politics

mkdir -p $byTopic_dir/business

mkdir -p $byTopic_dir/technology

mkdir -p $badfiles_dir



# checking each files in the dailyingest directory.

for files in $dailyingest_dir/*; do



#checking if files exist and being formatted correctly.

if [ -f "$files" ] && [[ "$(basename $files)" =~ ^[0-9]{8}-(sport|politics|business|technology)-([A-Za-z]+)-.+\.mp3$ ]]; then

        

#distributing each files from their specified information name.

filename=$(basename $files)

date=$(echo $filename | cut -d '-' -f1)

contributor=$(echo $filename | cut -d '-' -f3)

topic=$(echo $filename | cut -d '-' -f2)

        



#moving files to byDate

mv $files $byDate_dir/$filename



#symbolic links will be placed in the audios contributor name.

if [ ! -d "$byContributor_dir/$contributor" ]; then

mkdir $byContributor_dir/$contributor

fi

ln -s $byDate_dir/$filename $byContributor_dir/$contributor/$filename



#symbolic links will be placed in the audios topic name.

if [ ! -d "$byTopic_dir/$topic" ]; then

mkdir $byTopic_dir/$topic

fi

ln -s $byDate_dir/$filename $byTopic_dir/$topic/$filename

else

        

#will move the file if it's not in good labeling.

mv $files $badfiles_dir/



#If a filename does not meet the required structure, this must be reported on STDERR.

echo "Invalid file format: $files" >&2

fi



done
