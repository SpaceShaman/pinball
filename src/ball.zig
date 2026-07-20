const rl = @import("raylib");
const config = @import("config.zig");
const print = @import("std").debug.print;

pub const Ball = struct {
    position: rl.Vector2,
    velocity: rl.Vector2 = rl.Vector2.init(50, 0),
    gravity: f32 = 100,
    radius: f32 = 10,

    pub fn init(x: f32, y: f32) Ball {
        const vel = rl.Vector2.init(100, 5);
        const comp = vel.reflect(rl.Vector2.init(0, 1));
        print("Velocity: {}", .{comp});
        return Ball{ .position = rl.Vector2.init(x, y) };
    }

    pub fn draw(self: *const Ball) void {
        const x: i32 = @intFromFloat(self.position.x);
        const y: i32 = @intFromFloat(self.position.y);
        rl.drawCircle(x, y, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        const bottom: f32 = @floatFromInt(config.window_height);
        if (self.position.y > bottom) {
            self.velocity = self.velocity.reflect(rl.Vector2.init(0, 1));
            print("Velocity: {}", .{self.velocity});
        }
        const dt = rl.getFrameTime();
        self.velocity.y += dt * self.gravity;
        const dt_velocity = self.velocity.scale(dt);
        self.position = self.position.add(dt_velocity);
    }
};
