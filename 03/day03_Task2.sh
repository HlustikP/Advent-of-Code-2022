#!/bin/bash

declare inputFile="./input.txt"
mapfile rucksacks < "$inputFile"

declare rucksackCount=${#rucksacks[@]}

declare sum=0

# Get from char value to rucksack item points
declare lowercasePointsSubtraction=96
declare uppercasePointsSubtraction=38

declare rucksackTopIndex=0
declare rucksackMidIndex=1
declare rucksackBotIndex=2

# returns the minimum of three inputs, returning i
# where i is the index of the lowest variable starting at 1
function getMinimum () {
  declare result=0
  if (( $1 < $2 )); then
    result=$1
  else
    result=$2
  fi

  if (( result == $1 && $1 < $3 )); then
    echo $(( 1 ))
    return
  elif (( result == $1 && $1 >= $3 )); then
    echo $(( 3 ))
    return
  fi

  if (( $2 < $3 )); then
    echo $(( 2 ))
    return
  else
    echo $(( 3 ))
    return
  fi
}

while :
do
  # sorting with O(n log n) per compartment, though its implementation defined
  rucksackTop=$(echo "${rucksacks[rucksackTopIndex]}" | grep -o . | sort |tr -d "\n")
  rucksackMid=$(echo "${rucksacks[rucksackMidIndex]}" | grep -o . | sort |tr -d "\n")
  rucksackBot=$(echo "${rucksacks[rucksackBotIndex]}" | grep -o . | sort |tr -d "\n")

  declare topIterator=0
  declare midIterator=0
  declare botIterator=0

  # Two-Iterator/Pointer-Solution, this implementation here assumes an intersection to be present
  while :
  do
    declare topChar=$(printf %d\\n \'"${rucksackTop:topIterator:1}")
    declare midChar=$(printf %d\\n \'"${rucksackMid:midIterator:1}")
    declare botChar=$(printf %d\\n \'"${rucksackBot:botIterator:1}")

    # Exit condition
    if (( topChar == midChar && midChar == botChar )); then
      # subtract value from char to get to the desired item point value
      if (( topChar < 91 )); then # Uppercase char
        topChar=$((topChar - uppercasePointsSubtraction))
        sum=$((sum + topChar))
      else
        topChar=$((topChar - lowercasePointsSubtraction))
        sum=$((sum + topChar))
      fi
      break
    fi

    minimum=$(getMinimum $topChar $midChar $botChar)

    if [ $minimum == 1 ]; then
      topIterator=$((topIterator + 1))
    elif [ $minimum == 2 ]; then
      midIterator=$((midIterator + 1))
    else
      botIterator=$((botIterator + 1))
    fi
  done

  # Increment rucksacks
  rucksackTopIndex=$(( rucksackTopIndex + 3 ))
  rucksackMidIndex=$(( rucksackMidIndex + 3 ))
  rucksackBotIndex=$(( rucksackBotIndex + 3 ))

  # Exit condition (reached end of file)
  if (( rucksackCount == rucksackTopIndex )); then
    break
  fi
done

echo "Task 2: $sum"
