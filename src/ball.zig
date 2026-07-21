const std = @import("std");
const rl = @import("raylib");
const config = @import("config.zig");
const Wall = @import("wall.zig").Wall;
const print = @import("std").debug.print;

pub const Ball = struct {
    position: rl.Vector2,
    velocity: rl.Vector2 = rl.Vector2.init(150, 0),
    gravity: f32 = 400,
    bounciness: f32 = 0.8,
    radius: f32 = 20,
    walls: *std.ArrayList(Wall),

    pub fn init(x: f32, y: f32, walls: *std.ArrayList(Wall)) Ball {
        return Ball{ .position = rl.Vector2.init(x, y), .walls = walls };
    }

    pub fn draw(self: *const Ball) void {
        rl.drawCircleV(self.position, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        const bottom: f32 = config.window_height - self.radius;

        for (self.walls.items) |*wall| {
            if (rl.checkCollisionCircleLine(
                self.position,
                self.radius,
                wall.start_pos,
                wall.end_pos,
            )) {
                print("start_pos: {}\n", .{wall.start_pos});
                print("end_pos: {}\n", .{wall.end_pos});
                print("velocity: {}\n", .{self.velocity});
                const wall_vec = wall.end_pos.subtract(wall.start_pos).normalize();
                print("wall_vec: {}\n", .{wall_vec});
                const wall_refl = self.velocity.reflect(wall_vec).normalize().multiply(rl.Vector2.init(3, 3));
                print("wall_refl: {}\n", .{wall_refl});
                self.position = self.position.add(wall_refl.negate());
                self.velocity = self.velocity.reflect(wall_vec).negate();
                print("velocity: {}\n", .{self.velocity});
                self.velocity = self.velocity.scale(self.bounciness);
            }
        }

        if (self.position.y > bottom) {
            self.position.y = bottom;
            if (self.velocity.x < 1 and self.velocity.y < 1) {
                self.position.y = 0.0;
                self.position.x = 0.0;
                self.velocity.x = 150;
                self.velocity.y = 0.0;
            }
            self.velocity = self.velocity.reflect(rl.Vector2.init(0, 1));
            self.velocity = self.velocity.scale(self.bounciness);
        }

        const dt = rl.getFrameTime();
        self.velocity.y += dt * self.gravity;
        const dt_velocity = self.velocity.scale(dt);
        self.position = self.position.add(dt_velocity);
    }
};
