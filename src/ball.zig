const std = @import("std");
const rl = @import("raylib");
const Wall = @import("wall.zig").Wall;
const print = @import("std").debug.print;

pub const Ball = struct {
    position: rl.Vector2,
    velocity: rl.Vector2 = rl.Vector2.init(0, 0),
    gravity: f32 = 400,
    bounciness: f32 = 0.9,
    radius: f32 = 20,
    walls: *std.ArrayList(Wall),

    pub fn init(x: f32, y: f32, walls: *std.ArrayList(Wall)) Ball {
        return Ball{ .position = rl.Vector2.init(x, y), .walls = walls };
    }

    pub fn draw(self: *const Ball) void {
        rl.drawCircleV(self.position, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        const dt = rl.getFrameTime();
        const dt_velocity = self.velocity.scale(dt);
        self.position = self.position.add(dt_velocity);
        self.velocity.y += dt * self.gravity;

        for (self.walls.items) |*wall| {
            if (rl.checkCollisionCircleLine(
                self.position,
                self.radius,
                wall.start_pos,
                wall.end_pos,
            )) self.resolveWallCollision(wall);
        }
    }

    fn resolveWallCollision(self: *Ball, wall: *Wall) void {
        const reflection = self.lineReflect(wall.start_pos, wall.end_pos);
        const distance = reflection.length();
        const normal_ref = reflection.normalize();
        if (distance < self.radius) {
            const depth = self.radius - distance;
            self.position = self.position.add(normal_ref.negate().scale(depth));
        }
        self.velocity = self.velocity.reflect(normal_ref);
        self.velocity = self.velocity.scale(self.bounciness);
    }

    fn lineReflect(self: *Ball, start: rl.Vector2, end: rl.Vector2) rl.Vector2 {
        const start_end = end.subtract(start);
        const start_point = self.position.subtract(start);
        const t = start_end.dotProduct(start_point) / start_end.dotProduct(start_end);
        const closest_point = start.add(start_end.multiply(rl.Vector2.init(t, t)));
        return closest_point.subtract(self.position);
    }
};
