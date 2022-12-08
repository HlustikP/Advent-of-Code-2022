class Directory:
    def __init__(self, name, parent):
        self.name = name
        self.parent_directory = parent
        self.subdirectories = {}
        self.files = {}

cd_command = "cd"
ls_command = "ls"
cd_get_parent = ".."
directory_initial = "d"
command_initial = "$"

head = Directory("/", None)
cwd = head

memory_map = {}

def update_memory_map(memory_size):
    path_itr = cwd
    path = ""
    # reconstruct path
    while True:
        path += path_itr.name
        path += "-"
        if path_itr.parent_directory is None:
            break
        path_itr = path_itr.parent_directory

    # update the memory map
    while True:
        if path == "":
            break
        if path in memory_map:
            memory_map[path] += memory_size
        else:
            memory_map[path] = memory_size
        path = path.replace(path.split("-")[0] + "-", "")
    return

def handle_ls_output(argv):
    argv = argv.split(" ")
    if argv[0][0] == directory_initial:
        directory = argv[1]
        if directory not in cwd.subdirectories:
            cwd.subdirectories[directory] = Directory(directory, cwd)
        return
    filename = argv[1]
    if filename not in cwd.files:
        cwd.files[filename] = argv[0]
        update_memory_map(int(argv[0]))
    return

def eval_command(argv):
    argv = argv.split(" ")
    global cwd
    if argv[1] == ls_command:
        return
    if argv[1] == cd_command:
        if argv[2] == cd_get_parent and cwd.parent_directory is not None:
            cwd = cwd.parent_directory
            return
        child_path = argv[2]
        if child_path not in cwd.subdirectories:
            cwd.subdirectories[child_path] = Directory(child_path, cwd)
        cwd = cwd.subdirectories[child_path]
    return

file_name = "input.txt"
with open(file_name) as file:
    content = file.read()

lines = content.split("\n")
lines.pop(0)

for line in lines:
    if line[0] == command_initial:
        eval_command(line)
    else:
        handle_ls_output(line)

memory_sum = 0
for memory in memory_map.values():
    if memory <= 100000:
        memory_sum += memory

print("Task 1: ", memory_sum)

disk_size = 70000000
needed_space = 30000000
used_space = memory_map["/-"]
target_delta = needed_space - (disk_size - used_space)

delete_target = target_delta

for memory_size in memory_map.values():
    delta = target_delta - memory_size
    if delta > 0:
        continue
    delta = delta *-1
    if delta < target_delta:
        delete_target = memory_size

print("Task 2: ", delete_target)
