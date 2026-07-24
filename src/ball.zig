const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;
const physics = @import("physics.zig");
const Wall = @import("wall.zig").Wall;
const print = @import("std").debug.print;

pub const Ball = struct {
    position: Vector2,
    velocity: Vector2 = Vector2.init(0, 0),
    gravity: f32 = 300,
    bounciness: f32 = 0.6,
    radius: f32 = 20,
    walls: []const Wall,

    pub fn init(x: f32, y: f32, walls: []const Wall) Ball {
        return Ball{ .position = Vector2.init(x, y), .walls = walls };
    }

    pub fn draw(self: *const Ball) void {
        rl.drawCircleV(self.position, self.radius, .white);
    }

    pub fn update(self: *Ball) void {
        const dt = rl.getFrameTime();
        const dt_velocity = self.velocity.scale(dt);
        self.position = self.position.add(dt_velocity);
        self.velocity.y += dt * self.gravity;

        physics.resolveWallCollisions(self, self.walls);
    }
};
