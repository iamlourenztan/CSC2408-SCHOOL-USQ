#!/bin/bash



# Verify that input files Students.txt and Marks.txt exist and can be read by the script.

if [[ ! -r Students.txt || ! -r Marks.txt ]]; then

    echo "Input files Students.txt and Marks.txt must exist and be readable"

    exit 1

fi



# Verify that Marks.txt is not empty

if [[ ! -s Marks.txt ]]; then

    echo "Marks.txt should not be empty"

    exit 1

fi



# Verify that reportTemplate.md exists

if [[ ! -e reportTemplate.md ]]; then

    echo "reportTemplate.md must exist"

    exit 1

fi





# Verify that the output directory OUTPUT exists

if [ ! -d "OUTPUT" ]

then

    mkdir OUTPUT

    echo "OUTPUT directory created."

else

    echo "OUTPUT directory already exists."

fi



# For each student, produce a .md document which replaces the placeholder information in reportTemplate.md file

while read -r line; do

    studentid=$(echo "$line" | cut -d ',' -f 1)

    name=$(echo "$line" | cut -d ',' -f 2-)



    # Find the marks for the student

    marks=$(grep "$studentid" Marks.txt | cut -d ',' -f 2-)

    if [[ -z $marks ]]; then

        echo "Marks not found for student $studentid"

        continue

    fi



    # Calculate the total marks
    total=$(echo "$marks" | tr ',' ',' ',' '+' | bc)


    # Set comments

    comments="Good job!"



    # Replace placeholders and save to a .md file

    sed "s/STUDENTID/$studentid/g; s/NAME/$name/g; s/MARKS/$marks/g; s/TOTAL/$total/g; s/COMMENTS/$comments/g" reportTemplate.md > "$studentid".md



    # Transform the .md document using pandoc and place the resulting .pdf file in the OUTPUT directory

    pandoc "$studentid".md -o OUTPUT/"$studentid".pdf



    # Clean up intermediate files and remove the created studentid.md document

    rm "$studentid".md



    # Inform the user of what is happening

    echo "Processed student $studentid"

done < Students.txt



echo "All students processed"
