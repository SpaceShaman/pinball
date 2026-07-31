const std = @import("std");
pub const Wall = @import("Wall.zig");

test {
    std.testing.refAllDecls(@This());
}
