#!/bin/bash

declare inputFile="./input.txt"
mapfile rucksacks < "$inputFile"

declare sum=0

# Get from char value to rucksack item points
declare lowercasePointsSubtraction=96
declare uppercasePointsSubtraction=38

for rucksack in "${rucksacks[@]}"
do
  declare rucksackSize=${#rucksack}
  rucksackSize=$((rucksackSize - 1)) #excluding the newline char
  declare compartmentSize=$((rucksackSize / 2))
  declare compartmentFront="${rucksack:0:compartmentSize}"
  declare compartmentBack="${rucksack:compartmentSize:compartmentSize}"

  # O(n log n) per compartment, though its implementation defined
  compartmentFront=$(echo "$compartmentFront" | grep -o . | sort |tr -d "\n")
  compartmentBack=$(echo "$compartmentBack" | grep -o . | sort |tr -d "\n")

  declare frontIterator=0
  declare backIterator=0

  # Two-Iterator/Pointer-Solution, this implementation here assumes an intersection to be present
  while :
  do
    declare frontChar=$(printf %d\\n \'"${compartmentFront:frontIterator:1}")
    declare backChar=$(printf %d\\n \'"${compartmentBack:backIterator:1}")

    # Exit condition
    if (( frontChar == backChar )); then
      # subtract value from char to get to the desired item point value
      if (( frontChar < 91 )); then # Uppercase char
        frontChar=$((frontChar - uppercasePointsSubtraction))
        sum=$((sum + frontChar))
      else
        frontChar=$((frontChar - lowercasePointsSubtraction))
        sum=$((sum + frontChar))
      fi
      break
    fi

    if (( frontChar < backChar )); then
      frontIterator=$((frontIterator + 1))
    else
      backIterator=$((backIterator + 1))
    fi
  done

done

echo "Task 1: $sum"
