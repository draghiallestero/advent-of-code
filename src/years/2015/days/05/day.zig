const std = @import("std");

const utils = @import("../../../../utils.zig");

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    var nice_lines: u32 = 0;
    const lines = utils.split_lines(alloc, file_contents);
    for (lines.items) |line| {
        const a_count = std.mem.count(u8, line, "a");
        const e_count = std.mem.count(u8, line, "e");
        const i_count = std.mem.count(u8, line, "i");
        const o_count = std.mem.count(u8, line, "o");
        const u_count = std.mem.count(u8, line, "u");
        const vowel_count = a_count + e_count + i_count + o_count + u_count;
        var nice_pairs: u32 = 0;
        var naughty_pairs: u32 = 0;
        for (0..line.len - 1) |i| {
            if (line[i] == line[i + 1]) {
                nice_pairs += 1;
            }
            if (std.mem.eql(u8, line[i .. i + 2], "ab") or std.mem.eql(u8, line[i .. i + 2], "cd") or std.mem.eql(u8, line[i .. i + 2], "pq") or std.mem.eql(u8, line[i .. i + 2], "xy")) {
                naughty_pairs += 1;
            }
        }
        if (vowel_count >= 3 and nice_pairs >= 1 and naughty_pairs == 0) {
            nice_lines += 1;
        }
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{nice_lines}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    var nice_lines: u32 = 0;
    const lines = utils.split_lines(alloc, file_contents);
    for (lines.items) |line| {
        var nice_pairs: u32 = 0;
        for (0..line.len - 2) |i| {
            if (std.mem.count(u8, line, line[i .. i + 2]) >= 2) {
                nice_pairs += 1;
            }
        }
        var nice_chars: u32 = 0;
        for (0..line.len - 2) |i| {
            if (line[i] == line[i + 2]) {
                nice_chars += 1;
            }
        }
        if (nice_pairs >= 1 and nice_chars >= 1) {
            nice_lines += 1;
        }
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{nice_lines}) catch unreachable;
}
