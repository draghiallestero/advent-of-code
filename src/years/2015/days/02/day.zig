const std = @import("std");

const utils = @import("../../../../utils.zig");

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    var total: u32 = 0;
    const lines = utils.split_lines(alloc, file_contents);
    for (lines.items) |line| {
        const dimension_strs = utils.split(alloc, line, "x");
        var dimensions = std.ArrayList(u32).init(alloc);
        for (dimension_strs.items) |dimension_str| {
            dimensions.append(std.fmt.parseInt(u32, dimension_str, 0) catch unreachable) catch unreachable;
        }
        var areas = std.ArrayList(u32).init(alloc);
        areas.append(dimensions.items[0] * dimensions.items[1]) catch unreachable;
        areas.append(dimensions.items[1] * dimensions.items[2]) catch unreachable;
        areas.append(dimensions.items[0] * dimensions.items[2]) catch unreachable;
        total += 2 * (areas.items[0] + areas.items[1] + areas.items[2]) + std.mem.min(u32, areas.items);
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{total}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    var total: u32 = 0;
    const lines = utils.split_lines(alloc, file_contents);
    for (lines.items) |line| {
        const dimension_strs = utils.split(alloc, line, "x");
        var dimensions = std.ArrayList(u32).init(alloc);
        for (dimension_strs.items) |dimension_str| {
            dimensions.append(std.fmt.parseInt(u32, dimension_str, 0) catch unreachable) catch unreachable;
        }
        var perimeters = std.ArrayList(u32).init(alloc);
        perimeters.append(2 * (dimensions.items[0] + dimensions.items[1])) catch unreachable;
        perimeters.append(2 * (dimensions.items[1] + dimensions.items[2])) catch unreachable;
        perimeters.append(2 * (dimensions.items[0] + dimensions.items[2])) catch unreachable;
        total += std.mem.min(u32, perimeters.items) + dimensions.items[0] * dimensions.items[1] * dimensions.items[2];
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{total}) catch unreachable;
}
