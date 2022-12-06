filename = "input.txt";
file = assert(io.open(filename, "r"));
fileContent = file:read("*all");

function contains(table, val)
    for i=1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

itr_1 = 1;
itr_2 = 2;
itr_3 = 3;
itr_4 = 4;

chars = {};

while itr_4 < string.len(fileContent) do
    chars[1] = string.sub(fileContent, itr_1, itr_1);
    chars[2] = string.sub(fileContent, itr_2, itr_2);
    chars[3] = string.sub(fileContent, itr_3, itr_3);
    chars[4] = string.sub(fileContent, itr_4, itr_4);

    collision = false;

    if contains({ chars[2], chars[3], chars[4] }, chars[1]) then
        collision = true;
    end;
    if contains({ chars[1], chars[3], chars[4] }, chars[2]) then
        collision = true;
    end;
    if contains({ chars[1], chars[2], chars[4] }, chars[3]) then
        collision = true;
    end;
    if contains({ chars[1], chars[2], chars[3] }, chars[4]) then
        collision = true;
    end;

    if not collision then
        print("The first time a marker appears is after the character at index " .. itr_4);
        break;
    end

    itr_1 = itr_1 + 1;
    itr_2 = itr_2 + 1;
    itr_3 = itr_3 + 1;
    itr_4 = itr_4 + 1;
end

iterators = {};
-- init iterators
for i=1, 14 do
    iterators[i] = i;
end

chars = {};

while iterators[14] < string.len(fileContent) do
    -- get chars at iterator indizes
    for i=1, 14 do
        chars[i] = string.sub(fileContent, iterators[i], iterators[i]);
    end

    collision = false;

    for i=1, 14 do
        temp = chars[i];
        chars[i] = "-";
        if contains(chars, temp) then
            collision = true;
        end

        chars[i] = temp;
    end

    if not collision then
        print("The message starts after the character at index " .. iterators[14]);
        break;
    end

    -- increment iterators
    for i=1, 14 do
        iterators[i] = iterators[i] + 1;
    end
end

file:close();
