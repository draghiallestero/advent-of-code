const std = @import("std");

pub const utils = @import("utils.zig");

const year2015 = @import("years/2015/year.zig");

pub fn main() !void {
    // Initialize allocator
    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    // Figure out year and day
    var arg_itr = std.process.args();
    _ = arg_itr.skip();
    const year = std.fmt.parseUnsigned(u32, arg_itr.next().?, 0) catch unreachable;
    const day = std.fmt.parseUnsigned(u32, arg_itr.next().?, 0) catch unreachable;

    switch (year) {
        2015 => year2015.run(alloc.allocator(), day),
        else => unreachable,
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
