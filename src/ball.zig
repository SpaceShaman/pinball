const std = @import("std");
const rl = @import("raylib");
const config = @import("config.zig");
const Wall = @import("wall.zig").Wall;
const print = @import("std").debug.print;

pub const Ball = struct {
    position: rl.Vector2,
    velocity: rl.Vector2 = rl.Vector2.init(150, 0),
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
        const closest_point = closestPointOnLine(self.position, wall.start_pos, wall.end_pos);
        const reflection = closest_point.subtract(self.position);
        const distance = reflection.length();
        const normal_ref = reflection.normalize();
        print("distance: {}\n", .{distance});
        print("normal_ref: {}\n", .{normal_ref});
        if (distance < self.radius) {
            const inside = self.radius - distance;
            print("inside: {}\n", .{inside});
            self.position = self.position.add(normal_ref.negate().multiply(rl.Vector2.init(inside, inside)));
        }
        self.velocity = self.velocity.reflect(normal_ref);
    }
};

fn closestPointOnLine(point: rl.Vector2, start: rl.Vector2, end: rl.Vector2) rl.Vector2 {
    const start_end = end.subtract(start);
    const start_point = point.subtract(start);
    const t = start_end.dotProduct(start_point) / start_end.dotProduct(start_end);
    return start.add(start_end.multiply(rl.Vector2.init(t, t)));
}
