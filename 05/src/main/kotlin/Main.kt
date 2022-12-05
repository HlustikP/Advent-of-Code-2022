import java.io.File

fun main() {
    val fileName = "input.txt";
    var line = 0;
    val MAX_INITIAL_CRATESTACK_SIZE = 8;
    val STACK_PADDING = 4;

    val crateStacks = List(9) { CrateStack() };

    File(fileName).forEachLine {
        if (line == MAX_INITIAL_CRATESTACK_SIZE) {
            // no `break` available in forEach
            return@forEachLine
        }

        // Init CrateStacks
        if (it.isNotEmpty()) {
            var stackIndex = 0;

            for (stackPosition in 1..it.length step STACK_PADDING) {
                if (it[stackPosition] != ' ') {
                    crateStacks[stackIndex].addCrate(Crate(it[stackPosition]));
                }
                stackIndex++;
            }
        }
        line++;
    };

    // Crates were initially inserted in inverse order
    for (crateStack in crateStacks) {
        crateStack.reverse();
    }

    File(fileName).forEachLine {
        if (it.isEmpty()) {
            // no `break` available in forEach
            return@forEachLine
        }

        // If its no move instruction, continue loop
        if (it[0] != 'm') {
            // no `break` available in forEach
            return@forEachLine
        }

        val instructionArguments = it.split(" ");
        // Uncomment this and comment the function call below for Task 1
        /*Crane.moveCrate(instructionArguments[1].toInt(),
            crateStacks[instructionArguments[3].toInt() - 1],
            crateStacks[instructionArguments[5].toInt() - 1]);*/

        Crane.moveCrates(instructionArguments[1].toInt(),
            crateStacks[instructionArguments[3].toInt() - 1],
            crateStacks[instructionArguments[5].toInt() - 1]);
    };

    for (crateStack in crateStacks) {
        crateStack.print();
        println("")
    }
}
