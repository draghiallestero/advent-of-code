const std = @import("std");

const utils = @import("root").utils;

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const lines = utils.split_lines(alloc, file_contents);
    var grid = std.StaticBitSet(1000 * 1000).initEmpty();
    for (lines.items) |line| {
        if (std.mem.startsWith(u8, line, "turn on ")) {
            const line_copy = line["turn on ".len..];
            const instructions_ranges = utils.split(alloc, line_copy, " through ");
            const start_range = utils.split(alloc, instructions_ranges.items[0], ",");
            const start_x = std.fmt.parseInt(u32, start_range.items[0], 0) catch unreachable;
            const start_y = std.fmt.parseInt(u32, start_range.items[1], 0) catch unreachable;
            const end_range = utils.split(alloc, instructions_ranges.items[1], ",");
            const end_x = std.fmt.parseInt(u32, end_range.items[0], 0) catch unreachable;
            const end_y = std.fmt.parseInt(u32, end_range.items[1], 0) catch unreachable;
            for (start_x..end_x + 1) |x| {
                for (start_y..end_y + 1) |y| {
                    grid.set(1000 * x + y);
                }
            }
        } else if (std.mem.startsWith(u8, line, "turn off ")) {
            const line_copy = line["turn off ".len..];
            const instructions_ranges = utils.split(alloc, line_copy, " through ");
            const start_range = utils.split(alloc, instructions_ranges.items[0], ",");
            const start_x = std.fmt.parseInt(u32, start_range.items[0], 0) catch unreachable;
            const start_y = std.fmt.parseInt(u32, start_range.items[1], 0) catch unreachable;
            const end_range = utils.split(alloc, instructions_ranges.items[1], ",");
            const end_x = std.fmt.parseInt(u32, end_range.items[0], 0) catch unreachable;
            const end_y = std.fmt.parseInt(u32, end_range.items[1], 0) catch unreachable;
            for (start_x..end_x + 1) |x| {
                for (start_y..end_y + 1) |y| {
                    grid.unset(1000 * x + y);
                }
            }
        } else {
            const line_copy = line["toggle ".len..];
            const instructions_ranges = utils.split(alloc, line_copy, " through ");
            const start_range = utils.split(alloc, instructions_ranges.items[0], ",");
            const start_x = std.fmt.parseInt(u32, start_range.items[0], 0) catch unreachable;
            const start_y = std.fmt.parseInt(u32, start_range.items[1], 0) catch unreachable;
            const end_range = utils.split(alloc, instructions_ranges.items[1], ",");
            const end_x = std.fmt.parseInt(u32, end_range.items[0], 0) catch unreachable;
            const end_y = std.fmt.parseInt(u32, end_range.items[1], 0) catch unreachable;
            for (start_x..end_x + 1) |x| {
                for (start_y..end_y + 1) |y| {
                    grid.toggle(1000 * x + y);
                }
            }
        }
    }

    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{grid.count()}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const lines = utils.split_lines(alloc, file_contents);
    var grid = [_][1000]u32{[_]u32{0} ** 1000} ** 1000;
    for (lines.items) |line| {
        if (std.mem.startsWith(u8, line, "turn on ")) {
            const line_copy = line["turn on ".len..];
            const instructions_ranges = utils.split(alloc, line_copy, " through ");
            const start_range = utils.split(alloc, instructions_ranges.items[0], ",");
            const start_x = std.fmt.parseInt(u32, start_range.items[0], 0) catch unreachable;
            const start_y = std.fmt.parseInt(u32, start_range.items[1], 0) catch unreachable;
            const end_range = utils.split(alloc, instructions_ranges.items[1], ",");
            const end_x = std.fmt.parseInt(u32, end_range.items[0], 0) catch unreachable;
            const end_y = std.fmt.parseInt(u32, end_range.items[1], 0) catch unreachable;
            for (start_x..end_x + 1) |x| {
                for (start_y..end_y + 1) |y| {
                    grid[x][y] += 1;
                }
            }
        } else if (std.mem.startsWith(u8, line, "turn off ")) {
            const line_copy = line["turn off ".len..];
            const instructions_ranges = utils.split(alloc, line_copy, " through ");
            const start_range = utils.split(alloc, instructions_ranges.items[0], ",");
            const start_x = std.fmt.parseInt(u32, start_range.items[0], 0) catch unreachable;
            const start_y = std.fmt.parseInt(u32, start_range.items[1], 0) catch unreachable;
            const end_range = utils.split(alloc, instructions_ranges.items[1], ",");
            const end_x = std.fmt.parseInt(u32, end_range.items[0], 0) catch unreachable;
            const end_y = std.fmt.parseInt(u32, end_range.items[1], 0) catch unreachable;
            for (start_x..end_x + 1) |x| {
                for (start_y..end_y + 1) |y| {
                    if (grid[x][y] > 0) {
                        grid[x][y] -= 1;
                    }
                }
            }
        } else {
            const line_copy = line["toggle ".len..];
            const instructions_ranges = utils.split(alloc, line_copy, " through ");
            const start_range = utils.split(alloc, instructions_ranges.items[0], ",");
            const start_x = std.fmt.parseInt(u32, start_range.items[0], 0) catch unreachable;
            const start_y = std.fmt.parseInt(u32, start_range.items[1], 0) catch unreachable;
            const end_range = utils.split(alloc, instructions_ranges.items[1], ",");
            const end_x = std.fmt.parseInt(u32, end_range.items[0], 0) catch unreachable;
            const end_y = std.fmt.parseInt(u32, end_range.items[1], 0) catch unreachable;
            for (start_x..end_x + 1) |x| {
                for (start_y..end_y + 1) |y| {
                    grid[x][y] += 2;
                }
            }
        }
    }
    var sum: u32 = 0;
    for (grid) |grid_line| {
        for (grid_line) |light| {
            sum += light;
        }
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{sum}) catch unreachable;
}
