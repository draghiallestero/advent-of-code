const std = @import("std");

const utils = @import("../../../../utils.zig");

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

const GateOpInput = union(enum) {
    num: u16,
    gate: []const u8,
    fn eval(self: *const GateOpInput, map: *const GateOpMap) u16 {
        switch (self.*) {
            .num => return self.num,
            .gate => return map.getEntry(self.gate).?.value_ptr.eval(map),
        }
    }
};

const GateUnaryOp = struct {
    const Type = enum { noop, not };
    type: Type,
    input: GateOpInput,
};
const GateBinaryOp = struct {
    const Type = enum { @"and", @"or", lshift, rshift };
    type: Type,
    input1: GateOpInput,
    input2: GateOpInput,
};

const GateOp = struct {
    const Op = union(enum) { unary: GateUnaryOp, binary: GateBinaryOp };
    op: Op,
    opt_val: ?u16,

    fn eval(self: *GateOp, map: *const GateOpMap) u16 {
        if (self.opt_val) |val| {
            return val;
        }
        switch (self.op) {
            .unary => |unary| {
                const input = unary.input.eval(map);
                switch (unary.type) {
                    .noop => self.opt_val = input,
                    .not => self.opt_val = ~input,
                }
            },
            .binary => |binary| {
                const input1 = binary.input1.eval(map);
                const input2 = binary.input2.eval(map);
                switch (binary.type) {
                    .@"and" => self.opt_val = input1 & input2,
                    .@"or" => self.opt_val = input1 | input2,
                    .lshift => self.opt_val = input1 << @as(u4, @intCast(input2)),
                    .rshift => self.opt_val = input1 >> @as(u4, @intCast(input2)),
                }
            },
        }
        return self.opt_val.?;
    }
};

const GateOpMap = std.StringHashMap(GateOp);

fn get_gate_op_input(val: []const u8) GateOpInput {
    switch (val[0]) {
        '0'...'9' => {
            const num = std.fmt.parseInt(u16, val, 0) catch unreachable;
            return .{ .num = num };
        },
        else => {
            return .{ .gate = val };
        },
    }
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const lines = utils.split_lines(alloc, file_contents);
    var gate_op_map = GateOpMap.init(alloc);
    for (lines.items) |line| {
        const line_elems = utils.split(alloc, line, " -> ");
        const op_elems = utils.split(alloc, line_elems.items[0], " ");
        const dest_gate = line_elems.items[1];
        // Always make the gate entry if missing
        const dest_gate_op = (gate_op_map.getOrPut(dest_gate) catch unreachable).value_ptr;
        dest_gate_op.opt_val = null;
        // Easy case: single gate input
        if (op_elems.items.len == 1) {
            dest_gate_op.op = .{ .unary = .{ .type = .noop, .input = get_gate_op_input(op_elems.items[0]) } };
            continue;
        }
        // Check for NOT
        if (op_elems.items[0][0] == 'N') {
            dest_gate_op.op = .{ .unary = .{ .type = .not, .input = get_gate_op_input(op_elems.items[1]) } };
            continue;
        }
        // We are left with binary ops
        const binary_op_type: GateBinaryOp.Type = switch (op_elems.items[1][0]) {
            'A' => .@"and",
            'O' => .@"or",
            'L' => .lshift,
            'R' => .rshift,
            else => unreachable,
        };
        dest_gate_op.op = .{ .binary = .{ .type = binary_op_type, .input1 = get_gate_op_input(op_elems.items[0]), .input2 = get_gate_op_input(op_elems.items[2]) } };
    }
    const signal = gate_op_map.getEntry("a").?.value_ptr.eval(&gate_op_map);

    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{signal}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const lines = utils.split_lines(alloc, file_contents);
    var gate_op_map = GateOpMap.init(alloc);
    for (lines.items) |line| {
        const line_elems = utils.split(alloc, line, " -> ");
        const op_elems = utils.split(alloc, line_elems.items[0], " ");
        const dest_gate = line_elems.items[1];
        // Always make the gate entry if missing
        const dest_gate_op = (gate_op_map.getOrPut(dest_gate) catch unreachable).value_ptr;
        dest_gate_op.opt_val = null;
        // Easy case: single gate input
        if (op_elems.items.len == 1) {
            dest_gate_op.op = .{ .unary = .{ .type = .noop, .input = get_gate_op_input(op_elems.items[0]) } };
            continue;
        }
        // Check for NOT
        if (op_elems.items[0][0] == 'N') {
            dest_gate_op.op = .{ .unary = .{ .type = .not, .input = get_gate_op_input(op_elems.items[1]) } };
            continue;
        }
        // We are left with binary ops
        const binary_op_type: GateBinaryOp.Type = switch (op_elems.items[1][0]) {
            'A' => .@"and",
            'O' => .@"or",
            'L' => .lshift,
            'R' => .rshift,
            else => unreachable,
        };
        dest_gate_op.op = .{ .binary = .{ .type = binary_op_type, .input1 = get_gate_op_input(op_elems.items[0]), .input2 = get_gate_op_input(op_elems.items[2]) } };
    }
    const signal = gate_op_map.getEntry("a").?.value_ptr.eval(&gate_op_map);

    // New for part 2
    var gate_op_map_itr = gate_op_map.iterator();
    while (gate_op_map_itr.next()) |entry| {
        entry.value_ptr.opt_val = null;
    }
    gate_op_map.getEntry("b").?.value_ptr.opt_val = signal;
    const signal2 = gate_op_map.getEntry("a").?.value_ptr.eval(&gate_op_map);

    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{signal2}) catch unreachable;
}
