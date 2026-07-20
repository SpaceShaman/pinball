const rl = @import("raylib");
const config = @import("config.zig");

pub const Ball = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    radius: f32 = 25,

    pub fn init(x: f32, y: f32) Ball {
        return Ball{ .position = rl.Vector2.init(x, y), .velocity = rl.Vector2.init(0, 100) };
    }

    pub fn draw(self: *const Ball) void {
        const x: i32 = @intFromFloat(self.position.x);
        const y: i32 = @intFromFloat(self.position.y);
        rl.drawCircle(x, y, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        const radius: i32 = @intFromFloat(self.radius);
        const bottom: f32 = @floatFromInt(config.window_height - radius);
        if (self.position.y <= bottom) {
            const dt = rl.getFrameTime();
            const dt_velocity = self.velocity.scale(dt);
            self.position = self.position.add(dt_velocity);
        }
    }
};
