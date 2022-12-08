import std/strutils

# compiled with: nim c --run -d:release ./day08.nim

const filename = "input.txt";
var forrest = readFile(filename);
forrest = forrest.replace("\n", "");

let forest_size = len(forrest) - 1;
const row_size: int = 99;
const col_size: int = 99;

########### TASK 1

proc try_up(tree_height: int, tree_index: int): bool =
    var index = tree_index;
    while true:
        index -= row_size
        if index < 0:
            return true
        if tree_height <= parseInt($(forrest[index])):
            return false

proc try_down(tree_height: int, tree_index: int): bool =
    var index = tree_index;
    while true:
        index += col_size;
        if index > forest_size:
            return true;
        if tree_height <= parseInt($(forrest[index])):
            return false;

proc try_left(tree_height: int, tree_index: int): bool =
    var index = tree_index;
    while true:
        if (index mod row_size) == 0:
            return true;
        if tree_height <= parseInt($(forrest[index - 1])):
            return false;
        index -= 1;

proc try_right(tree_height: int, tree_index: int): bool =
    var index = tree_index;
    while true:
        if (index mod row_size) == (row_size - 1):
            return true;
        if tree_height <= parseInt($(forrest[index + 1])):
            return false;
        index += 1;

var sum_visible_trees: int = 0;

for index, char_tree in forrest:
    # value from loop cant be mutated, so create a copy
    var int_tree = parseInt($char_tree);
    if try_up(int_tree, index):
        sum_visible_trees += 1;
        continue;
    if try_down(int_tree, index):
       sum_visible_trees += 1;
       continue;
    if try_left(int_tree, index):
        sum_visible_trees += 1;
        continue;
    if try_right(int_tree, index):
        sum_visible_trees += 1;
        continue;
   
echo(sum_visible_trees, " trees are visible.");

########### TASK 2
var up_value, down_value, left_value, right_value: int
var highest_scenic_score: int = 0;

proc viewable_up(tree_height: int, tree_index: int): int =
    var index = tree_index;
    var viewable_trees: int = 0;
    while true:
        index -= row_size
        if index < 0:
            return viewable_trees;
        if tree_height <= parseInt($(forrest[index])):
            # increment because we see the tree that blocks the view
            return viewable_trees + 1;
        viewable_trees += 1;

proc viewable_down(tree_height: int, tree_index: int): int =
    var index = tree_index;
    var viewable_trees: int = 0;
    while true:
        index += col_size;
        if index > forest_size:
            return viewable_trees;
        if tree_height <= parseInt($(forrest[index])):
            # increment because we see the tree that blocks the view
            return viewable_trees + 1;
        viewable_trees += 1;

proc viewable_left(tree_height: int, tree_index: int): int =
    var index = tree_index;
    var viewable_trees: int = 0;
    while true:
        if (index mod row_size) == 0:
            return viewable_trees;
        if tree_height <= parseInt($(forrest[index - 1])):
            return viewable_trees;
        index -= 1;
        viewable_trees += 1;

proc viewable_right(tree_height: int, tree_index: int): int =
    var index = tree_index;
    var viewable_trees: int = 0;
    while true:
        if (index mod row_size) == (row_size - 1):
            return viewable_trees;
        if tree_height <= parseInt($(forrest[index + 1])):
            return viewable_trees;
        index += 1;
        viewable_trees += 1;

for index, char_tree in forrest:
    var int_tree = parseInt($char_tree);

    up_value = viewable_up(int_tree, index);
    down_value = viewable_down(int_tree, index);
    left_value = viewable_left(int_tree, index);
    right_value = viewable_right(int_tree, index);

    let scenic_score = up_value * down_value * left_value * right_value;
    if scenic_score > highest_scenic_score:
        highest_scenic_score = scenic_score;
   
echo(highest_scenic_score, " is the highest score possible.");
