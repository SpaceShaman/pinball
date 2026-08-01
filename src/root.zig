const std = @import("std");
pub const Wall = @import("Wall.zig");
pub const Flipper = @import("Flipper.zig");
pub const Ball = @import("Ball.zig");

test {
    std.testing.refAllDecls(@This());
}
