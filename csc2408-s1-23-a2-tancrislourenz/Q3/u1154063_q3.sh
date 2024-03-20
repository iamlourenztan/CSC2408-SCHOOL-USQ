#!/bin/bash



# Check for options

allow_hints=false

allow_multiple_attempts=false

while getopts "h&m" opt; do

    case $opt in

        h) allow_hints=true ;;

        m) allow_multiple_attempts=true ;;

    esac

done



# Shift positional parameters to remove options

shift $((OPTIND - 1))



# Get input file name from command line argument

file_name=$1



# Check if input file name is provided

if [[ -z $file_name ]]; then

    echo "Error: Input file name not provided."

    exit 1

fi



# Check if input file exists

if [[ ! -f $file_name ]]; then

    echo "Error: Input file '$file_name' not found."

    exit 1

fi



# Read word-pairs from input file

compare=($(cat $file_name))



# Shuffle word pairs

shuf_compare=($(shuf -e "${compare[@]}"))



# Set initial values for counters

question_number=0

total_questions=${#shuf_compare[@]}

correct_answers=0



# Start timer

start_time=$(date +%s)



# Loop through shuffled word pairs

for languages in "${shuf_compare[@]}"; do

    # Increment question number

    question_number=$((question_number + 1))



    # Split word pair into English and foreign language words

    IFS=',' read -ra words <<< "$languages"

    english_word=${words[0]}

    foreign_word=${words[1]}



    # Ask user for foreign language equivalent

    while true; do

        echo "Question $question_number: What is the foreign language of '$english_word'?"

        read answer



        # Check if user wants to exit

        if [[ $answer == "exit" ]]; then

            break 2

        fi



        # Check if user wants a hint

        if [[ $allow_hints == true && $answer == "help" ]]; then

            first_letter=${foreign_word:0:1}

            echo "Hint: The first letter is '$first_letter'."

            continue

        fi



        # Check if user wants to skip question

        if [[ $allow_multiple_attempts == true && $answer == "skip" ]]; then

            break

        fi



        # Check if answer is correct

        if [[ $answer == $foreign_word ]]; then

            echo "Correct!"

            correct_answers=$((correct_answers + 1))

            break

        else

            echo "Incorrect. The correct answer is '$foreign_word'."

            if [[ $allow_multiple_attempts == false ]]; then

                break

            fi

        fi

    done



done



# End timer and calculate time used

end_time=$(date +%s)

time_used=$((end_time - start_time))



# Print results

echo "Quiz ended. You answered $correct_answers out of $total_questions questions correctly."

echo "Total time used: $time_used seconds."
