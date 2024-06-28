const std = @import("std");

const utils = @import("root").utils;

pub fn run(alloc: std.mem.Allocator, file_contents: []const u8) void {
    part1(alloc, file_contents);
    part2(alloc, file_contents);
}

fn part1(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const VisitedHouses = std.AutoHashMap(utils.Point, void);
    var visited_houses = VisitedHouses.init(alloc);
    var pos: utils.Point = .{};
    visited_houses.put(pos, {}) catch unreachable;
    for (file_contents) |command| {
        switch (command) {
            '<' => pos.left(),
            '>' => pos.right(),
            '^' => pos.up(),
            'v' => pos.down(),
            else => unreachable,
        }
        visited_houses.put(pos, {}) catch unreachable;
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 1: {}\n", .{visited_houses.count()}) catch unreachable;
}

fn part2(alloc: std.mem.Allocator, file_contents: []const u8) void {
    _ = .{ alloc, file_contents };

    const VisitedHouses = std.AutoHashMap(utils.Point, void);
    var visited_houses_santa = VisitedHouses.init(alloc);
    var visited_houses_robot = VisitedHouses.init(alloc);
    var pos_santa: utils.Point = .{};
    var pos_robot: utils.Point = .{};
    visited_houses_santa.put(pos_santa, {}) catch unreachable;
    visited_houses_robot.put(pos_robot, {}) catch unreachable;
    for (file_contents, 0..) |command, i| {
        if (i % 2 == 0) {
            switch (command) {
                '<' => pos_santa.left(),
                '>' => pos_santa.right(),
                '^' => pos_santa.up(),
                'v' => pos_santa.down(),
                else => unreachable,
            }
            visited_houses_santa.put(pos_santa, {}) catch unreachable;
        } else {
            switch (command) {
                '<' => pos_robot.left(),
                '>' => pos_robot.right(),
                '^' => pos_robot.up(),
                'v' => pos_robot.down(),
                else => unreachable,
            }
            visited_houses_robot.put(pos_robot, {}) catch unreachable;
        }
    }
    var visited_houses_robot_iterator = visited_houses_robot.iterator();
    while (visited_houses_robot_iterator.next()) |pos| {
        visited_houses_santa.put(pos.key_ptr.*, {}) catch unreachable;
    }
    std.fmt.format(std.io.getStdOut().writer(), "Part 2: {}\n", .{visited_houses_santa.count()}) catch unreachable;
}
