// compiled with: zig build-exe -Drelease-safe=true ./day10.zig
const std = @import("std");

fn absInt(val: i32) i32 {
    if (val < 0) {
        return val * -1;
    } else {
        return val;
    }
}

// Checks if the sprite overlaps with the pixel thats currently being drawn
fn isSpriteVisible(cycle: u32, x_register: i32) bool {
    const modulo: i32 = 40;
    const array_adjusted_cycle = @mod(@intCast(i32, (cycle - 1)), modulo);
    const delta = absInt(array_adjusted_cycle - x_register);

    if (delta > 1) {
        return false;
    } else {
        return true;
    }
}

pub fn main() !void {
    // standard out stream
    const stdout = std.io.getStdOut().writer();

    // why is something this fundamental not a top-level function?
    const allocator = std.heap.page_allocator;

    // get command line arguments
    const argv = try std.process.argsAlloc(allocator);

    // create filestream
    var file = try std.fs.cwd().openFile(argv[1], .{ .mode = .read_only });

    // get filesize in bytes
    const file_size = (try file.stat()).size;

    // allocate memory equal to the filesize
    var buffer = try allocator.alloc(u8, file_size);

    // write file contents to buffer
    try file.reader().readNoEof(buffer);

    // comms system stuff
    const NOOP = "noop";
    const ADDX = "addx";
    var x_register: i32 = 1;
    var cycle: u32 = 1;
    const thresholds = [_]i32{ 20, 60, 100, 140, 180, 220, 999999 };
    var cumulative_signal_strength: i32 = 0;
    var threshold: u32 = 0;
    const display_size: u32 = 40 * 6;
    var display: [display_size]u8 = undefined;

    // create iterators to the instructions
    var program = std.mem.split(u8, buffer, "\n");
    while (program.next()) | instructions | {
        var instruction = std.mem.split(u8, instructions, " ");
        while (instruction.next()) | arg | {
            // NOOP: Do nothing, takes 1 cycle to complete
            if (std.mem.eql(u8, arg, NOOP)) {
                if (isSpriteVisible(cycle, x_register)) {
                    display[cycle - 1] = '#';
                } else {
                    display[cycle - 1] = '.';
                }
                cycle += 1;
                continue;
            }

            // ADDX: Add argument to X Register, takes 2 cycles to complete
            if (std.mem.eql(u8, arg, ADDX)) {
                if (isSpriteVisible(cycle, x_register)) {
                    display[cycle - 1] = '#';
                } else {
                    display[cycle - 1] = '.';
                }
                cycle += 1;

                if (isSpriteVisible(cycle, x_register)) {
                    display[cycle - 1] = '#';
                } else {
                    display[cycle - 1] = '.';
                }
                cycle += 1;
                continue;
            }

            // if target cycle is reached, output the signal strength
            if (thresholds[threshold] < cycle) {
                const signal_strength: i32 = thresholds[threshold] * x_register;
                try stdout.print("Signal strength at cycle {d} is {d} * {d} = {d} \n",
                    .{ thresholds[threshold], thresholds[threshold], x_register, signal_strength });
                cumulative_signal_strength += signal_strength;
                threshold += 1;
            }

            x_register += try std.fmt.parseInt(i32, arg, 10);
        }
    }

    try stdout.print("X Register has value: {d}\n", .{ x_register });
    try stdout.print("Cycles: {d}\n", .{ cycle });
    try stdout.print("Cumulative signal strength: {d}\n", .{ cumulative_signal_strength });

    // paint display
    var i: u32 = 0;
    while (i < display_size) {
        try stdout.print("{c}", .{ display[i] });
        if (i % 40 == 39) {
            try stdout.print("\n", .{});
        }
        i += 1;
    }

    // free allocated heap memory
    std.process.argsFree(allocator, argv);
    allocator.free(buffer);
}
