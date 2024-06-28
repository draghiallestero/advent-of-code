const std = @import("std");

pub const Splits = std.ArrayList([]const u8);

pub fn split(alloc: std.mem.Allocator, chars: []const u8, separator: []const u8) Splits {
    // Copy arguments
    var chars_copy = chars;

    // Initialize output list
    var splits = Splits.init(alloc);

    // Split on separator
    while (chars_copy.len != 0) {
        if (std.mem.indexOf(u8, chars_copy, separator)) |i| {
            splits.append(chars_copy[0..i]) catch unreachable;
            chars_copy = chars_copy[i + separator.len ..];
        } else {
            splits.append(chars_copy) catch unreachable;
            chars_copy = chars_copy[chars_copy.len..];
        }
    }

    return splits;
}

pub fn split_lines(alloc: std.mem.Allocator, chars: []const u8) Splits {
    return split(alloc, chars, "\n");
}

pub const Point = struct {
    x: i32 = 0,
    y: i32 = 0,

    pub fn left(self: *Point) void {
        self.x -= 1;
    }
    pub fn right(self: *Point) void {
        self.x += 1;
    }
    pub fn up(self: *Point) void {
        self.y += 1;
    }
    pub fn down(self: *Point) void {
        self.y -= 1;
    }
    pub fn add(self: *Point, p: Point) Point {
        return .{ .x = self.x + p.x, .y = self.y + p.y };
    }
    pub fn neg(self: *Point) Point {
        return .{ .x = -self.x, .y = -self.y };
    }
};
