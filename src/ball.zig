const rl = @import("raylib");
const config = @import("config.zig");

pub const Ball = struct {
    x: i32,
    y: i32,
    radius: f32 = 30,

    pub fn draw(self: *const Ball) void {
        rl.drawCircle(self.x, self.y, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        if (self.y <= config.window_height) self.y += config.gravity;
    }
};
