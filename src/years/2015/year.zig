const std = @import("std");

const day01 = @import("days/01/day.zig");
const day02 = @import("days/02/day.zig");
const day03 = @import("days/03/day.zig");
const day04 = @import("days/04/day.zig");
const day05 = @import("days/05/day.zig");
const day06 = @import("days/06/day.zig");
const day07 = @import("days/07/day.zig");
const day08 = @import("days/08/day.zig");
const day09 = @import("days/09/day.zig");
const day10 = @import("days/10/day.zig");
const day11 = @import("days/11/day.zig");
const day12 = @import("days/12/day.zig");
const day13 = @import("days/13/day.zig");
const day14 = @import("days/14/day.zig");
const day15 = @import("days/15/day.zig");
const day16 = @import("days/16/day.zig");
const day17 = @import("days/17/day.zig");
const day18 = @import("days/18/day.zig");
const day19 = @import("days/19/day.zig");
const day20 = @import("days/20/day.zig");
const day21 = @import("days/21/day.zig");
const day22 = @import("days/22/day.zig");
const day23 = @import("days/23/day.zig");
const day24 = @import("days/24/day.zig");
const day25 = @import("days/25/day.zig");

pub fn run(alloc: std.mem.Allocator, day: u32) void {
    // Read file
    const file_path = std.fmt.allocPrint(alloc, "src/years/2015/days/{:0>2}/day.txt", .{day}) catch unreachable;
    const file_contents = std.fs.cwd().readFileAlloc(alloc, file_path, std.math.maxInt(usize)) catch unreachable;

    // Call day
    switch (day) {
        1 => day01.run(alloc, file_contents),
        2 => day02.run(alloc, file_contents),
        3 => day03.run(alloc, file_contents),
        4 => day04.run(alloc, file_contents),
        5 => day05.run(alloc, file_contents),
        6 => day06.run(alloc, file_contents),
        7 => day07.run(alloc, file_contents),
        8 => day08.run(alloc, file_contents),
        9 => day09.run(alloc, file_contents),
        10 => day10.run(alloc, file_contents),
        11 => day11.run(alloc, file_contents),
        12 => day12.run(alloc, file_contents),
        13 => day13.run(alloc, file_contents),
        14 => day14.run(alloc, file_contents),
        15 => day15.run(alloc, file_contents),
        16 => day16.run(alloc, file_contents),
        17 => day17.run(alloc, file_contents),
        18 => day18.run(alloc, file_contents),
        19 => day19.run(alloc, file_contents),
        20 => day20.run(alloc, file_contents),
        21 => day21.run(alloc, file_contents),
        22 => day22.run(alloc, file_contents),
        23 => day23.run(alloc, file_contents),
        24 => day24.run(alloc, file_contents),
        25 => day25.run(alloc, file_contents),
        else => unreachable,
    }
}
