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

pub fn swap_bytes(T: type, val: T) T {
    const num_bytes = @sizeOf(T);
    const val_arr: [num_bytes]u8 = @bitCast(val);
    var new_val_arr: [num_bytes]u8 = undefined;
    for (0..num_bytes) |i| {
        new_val_arr[num_bytes - 1 - i] = val_arr[i];
    }
    const new_val: T = @bitCast(new_val_arr);
    return new_val;
}

pub fn md5_hash(alloc: std.mem.Allocator, msg: []const u8) u128 {
    // Figure out how long the new message needs to be
    var new_len = msg.len;
    // Append a single 1 to the message
    new_len += 1;
    // Pad with zeros until 56 mod 64
    const new_len_mod_64 = new_len % 64;
    // the compiler is fucking with me here
    const new_len_mod_64_add: usize = if (new_len_mod_64 < 56) 0 else 64;
    new_len += 56 - new_len_mod_64 + new_len_mod_64_add;
    // Insert original length
    new_len += 8;

    // Allocate new message. Honestly you could get away with calculating the
    // required byte at each step instead of making a new buffer, but eh
    const new_msg = alloc.alloc(u8, new_len) catch unreachable;
    defer alloc.free(new_msg);

    // Copy over original message
    std.mem.copyForwards(u8, new_msg, msg);
    // Append a single 1 to the message
    new_msg[msg.len] = 0x80;
    // Pad with zeros until 56 mod 64
    @memset(new_msg[msg.len + 1 .. new_msg.len - 8], 0);
    // Insert original length
    const msg_bits: u64 = msg.len * 8;
    std.mem.copyForwards(u8, new_msg[new_msg.len - 8 ..], std.mem.asBytes(&msg_bits));

    // Precalculated values
    const shifts = [64]u32{ 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21 };
    const constants = [64]u32{ 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501, 0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be, 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821, 0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8, 0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a, 0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c, 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70, 0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05, 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665, 0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1, 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1, 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391 };

    // These will be modified as the message is processed
    var a: u32 = 0x67452301;
    var b: u32 = 0xefcdab89;
    var c: u32 = 0x98badcfe;
    var d: u32 = 0x10325476;

    // Process 512-bit chunks. Done in terms of 32-bit words, each chunk holds
    // 16 of those
    const chunks = std.mem.bytesAsSlice(u512, new_msg);
    for (chunks) |chunk| {
        // Get words
        const words: [16]u32 = @bitCast(chunk);
        // Initial values for chunk
        var a_chunk: u32 = a;
        var b_chunk: u32 = b;
        var c_chunk: u32 = c;
        var d_chunk: u32 = d;
        // Process each chunk
        for (0..64) |i_size| {
            const i: u32 = @intCast(i_size);
            var f: u32 = undefined;
            var j: u32 = undefined;
            switch (i) {
                0...15 => {
                    f = (b_chunk & c_chunk) | (~b_chunk & d_chunk);
                    j = i;
                },
                16...31 => {
                    f = (d_chunk & b_chunk) | (~d_chunk & c_chunk);
                    j = (5 * i + 1) % 16;
                },
                32...47 => {
                    f = b_chunk ^ c_chunk ^ d_chunk;
                    j = (3 * i + 5) % 16;
                },
                48...63 => {
                    f = c_chunk ^ (b_chunk | ~d_chunk);
                    j = (7 * i) % 16;
                },
                else => unreachable,
            }
            f +%= a_chunk +% constants[i] +% words[j];
            a_chunk = d_chunk;
            d_chunk = c_chunk;
            c_chunk = b_chunk;
            const b_add = std.math.rotl(u32, f, shifts[i]);
            b_chunk +%= b_add;

            j += 1 - 1;
        }
        a +%= a_chunk;
        b +%= b_chunk;
        c +%= c_chunk;
        d +%= d_chunk;
    }
    const a_u128: u128 = swap_bytes(u32, a);
    const b_u128: u128 = swap_bytes(u32, b);
    const c_u128: u128 = swap_bytes(u32, c);
    const d_u128: u128 = swap_bytes(u32, d);
    const hash: u128 = (a_u128 << 96) + (b_u128 << 64) + (c_u128 << 32) + d_u128;
    return hash;
}
