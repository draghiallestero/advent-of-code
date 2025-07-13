const std = @import("std");

const utils = @import("../../../../utils.zig");

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const up = std.mem.count(u8, file_contents, "(");
    const down = std.mem.count(u8, file_contents, ")");
    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{up - down}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    var floor: i32 = 0;
    for (file_contents, 0..) |step, i| {
        floor += if (step == '(') 1 else -1;
        if (floor == -1) {
            std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{i + 1}) catch unreachable;
            break;
        }
    }
}
