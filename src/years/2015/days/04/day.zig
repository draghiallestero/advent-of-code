const std = @import("std");

const utils = @import("../../../../utils.zig");

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    var i: u32 = 1;
    while (true) : (i += 1) {
        const input = std.fmt.allocPrint(alloc, "{s}{}", .{ file_contents, i }) catch unreachable;
        const hash = utils.md5_hash(alloc, input);
        if (hash >> 108 == 0) {
            break;
        }
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{i}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    var i: u32 = 1;
    while (true) : (i += 1) {
        const input = std.fmt.allocPrint(alloc, "{s}{}", .{ file_contents, i }) catch unreachable;
        const hash = utils.md5_hash(alloc, input);
        if (hash >> 104 == 0) {
            break;
        }
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{i}) catch unreachable;
}
