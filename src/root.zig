const std = @import("std");

// Declare these as public so their tests get found
pub const year2015 = @import("years/2015/year.zig");

test {
    std.testing.refAllDecls(@This());
}
