const std = @import("std");

const utils = @import("../../../../utils.zig");

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const lines = utils.split_lines(alloc, file_contents);
    var escaped_lines = std.ArrayList(std.ArrayList(u8)).initCapacity(alloc, lines.items.len) catch unreachable;
    for (lines.items) |line| {
        var escaped_line = std.ArrayList(u8).initCapacity(alloc, line.len - 2) catch unreachable;
        var i: usize = 1;
        while (i < line.len - 1) : (i += 1) {
            switch (line[i]) {
                'a'...'z', '"' => |c| escaped_line.appendAssumeCapacity(c),
                '\\' => |c| {
                    if (i + 1 == line.len - 1) {
                        escaped_line.appendAssumeCapacity(c);
                    } else {
                        switch (line[i + 1]) {
                            '"', '\\' => |c2| {
                                escaped_line.appendAssumeCapacity(c2);
                                i += 1;
                            },
                            'x' => {
                                const HexUtils = struct {
                                    fn isHex(val: u8) bool {
                                        switch (val) {
                                            '0'...'9', 'a'...'f' => return true,
                                            else => return false,
                                        }
                                    }
                                    fn toNum(val: u8) u8 {
                                        switch (val) {
                                            '0'...'9' => return val - '0',
                                            'a'...'f' => return val - 'a',
                                            else => unreachable,
                                        }
                                    }
                                };
                                if (i + 3 < line.len - 1 and HexUtils.isHex(line[i + 2]) and HexUtils.isHex(line[i + 3])) {
                                    escaped_line.appendAssumeCapacity(HexUtils.toNum(line[i + 2]) * 10 + HexUtils.toNum(line[i + 3]));
                                    i += 3; // should be += 4, but loop handles that
                                } else {
                                    escaped_line.appendAssumeCapacity(c);
                                }
                            },
                            else => unreachable,
                        }
                    }
                },
                else => unreachable,
            }
        }
        escaped_lines.appendAssumeCapacity(escaped_line);
    }

    const total_chars_in_lines = blk: {
        var count: usize = 0;
        for (lines.items) |line| {
            count += line.len;
        }
        break :blk count;
    };
    const total_chars_in_escaped_lines = blk: {
        var count: usize = 0;
        for (escaped_lines.items) |escaped_line| {
            count += escaped_line.items.len;
        }
        break :blk count;
    };

    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{total_chars_in_lines - total_chars_in_escaped_lines}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const lines = utils.split_lines(alloc, file_contents);
    var escaped_lines = std.ArrayList(std.ArrayList(u8)).initCapacity(alloc, lines.items.len) catch unreachable;
    for (lines.items) |line| {
        var escaped_line = std.ArrayList(u8).initCapacity(alloc, line.len + 2) catch unreachable;
        escaped_line.append('"') catch unreachable;
        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            switch (line[i]) {
                'a'...'z', '0'...'9' => |c| escaped_line.append(c) catch unreachable,
                '"', '\\' => |c| {
                    escaped_line.append('\\') catch unreachable;
                    escaped_line.append(c) catch unreachable;
                },
                else => unreachable,
            }
        }
        escaped_line.append('"') catch unreachable;
        escaped_lines.append(escaped_line) catch unreachable;
    }

    const total_chars_in_lines = blk: {
        var count: usize = 0;
        for (lines.items) |line| {
            count += line.len;
        }
        break :blk count;
    };
    const total_chars_in_escaped_lines = blk: {
        var count: usize = 0;
        for (escaped_lines.items) |escaped_line| {
            count += escaped_line.items.len;
        }
        break :blk count;
    };

    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{total_chars_in_escaped_lines - total_chars_in_lines}) catch unreachable;
}
