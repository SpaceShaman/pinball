const rl = @import("raylib");
const config = @import("config.zig");

pub const Ball = struct {
    x: i32,
    y: i32,
    radius: f32 = 50,

    pub fn draw(self: *const Ball) void {
        rl.drawCircle(self.x, self.y, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        const radius: i32 = @intFromFloat(self.radius);
        const bottom = config.window_height - radius - 2;
        if (self.y <= bottom) self.y += config.gravity;
    }
};
