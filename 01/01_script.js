import { readFileSync } from 'fs';

const elvesStrings = readFileSync('01_input.txt', 'utf8').split('\n\n');
const elvesNums = elvesStrings.map((caloriesString) => {
    return caloriesString.split('\n').reduce((totalCalories, currentCalories) => {
        return parseInt(totalCalories) + parseInt(currentCalories);
    });
});

elvesNums.forEach((calories, index) => elvesNums[index] = parseInt(calories));
console.log(Math.max(...elvesNums));

const topThree = elvesNums.sort((lhs, rhs) => {
    if (lhs > rhs) {
        return -1;
    }
    else if (lhs < rhs) {
        return 1;
    }
    return 0;
}).splice(0, 3).reduce((totalCalories, currentCalories) => {
        return totalCalories + currentCalories;
});
console.log(topThree);
