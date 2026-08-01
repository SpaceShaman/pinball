const std = @import("std");
pub const Game = @import("Game.zig");
pub const Ball = @import("Ball.zig");
pub const Wall = @import("Wall.zig");
pub const Flipper = @import("Flipper.zig");
pub const collisions = @import("collisions.zig");

test {
    std.testing.refAllDecls(@This());
}
