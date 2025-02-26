const std = @import("std");

const utils = @import("root").utils;

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };
    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{0}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };
    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{0}) catch unreachable;
}
