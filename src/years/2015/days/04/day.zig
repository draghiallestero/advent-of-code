const std = @import("std");

const utils = @import("root").utils;

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    var i: u32 = 1;
    while (true) : (i += 1) {
        const input = std.fmt.allocPrint(alloc, "{s}{}", .{ file_contents, i }) catch unreachable;
        var output = [_]u8{0} ** std.crypto.hash.Md5.digest_length;
        std.crypto.hash.Md5.hash(input, &output, .{});
        // var output_str = [_]u8{0} ** (2 * std.crypto.hash.Md5.digest_length);
        // for (output, 0..) |c, j| {
        //     output_str[2 * j] = '0' + (c & 0xF);
        //     output_str[2 * j + 1] = '0' + ((c >> 4) & 0xF);
        // }
        const output_int = @as(u128, @bitCast(output));
        // std.debug.print("0x{d:0>32}\n", .{output_int});
        if (output_int <= 0x00000FFFFFFFFFFFFFFFFFFFFFFFFFFF) {
            std.debug.print("0x{x:0>32}\n", .{output_int});
            std.debug.print("{}\n", .{i});
        }
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{0}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };
    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{0}) catch unreachable;
}
