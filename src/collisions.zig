const rl = @import("raylib");
const Vector2 = rl.Vector2;
const fl = @import("flipper");
const Ball = @import("Ball.zig");
const Wall = fl.Wall;
const Flipper = @import("Flipper.zig");

pub fn resolveWallCollisions(ball: *Ball, walls: []const Wall) void {
    for (walls) |wall| {
        if (wall.checkCollisionCircle(ball.position, ball.radius)) {
            resolveWallCollision(ball, wall);
        }
    }
}

fn resolveWallCollision(ball: *Ball, wall: Wall) void {
    const collision_normal = wall.collisionNormal(ball.position);

    const distance = wall.distance(ball.position);
    if (distance < ball.radius) {
        const depth = ball.radius - distance;
        ball.position = ball.position.add(collision_normal.negate().scale(depth));
    }

    const velocity_n = collision_normal.scale(ball.velocity.dotProduct(collision_normal));
    const velocity_t = ball.velocity.subtract(velocity_n);
    const reduced_velocity_n = velocity_n.scale(ball.bounciness);
    ball.velocity = velocity_t.add(reduced_velocity_n.negate());
}

fn lineReflect(ball: *Ball, wall: Wall) Vector2 {
    const start_end = wall.end.subtract(wall.start);
    const start_point = ball.position.subtract(wall.start);
    const t = start_end.dotProduct(start_point) / start_end.dotProduct(start_end);
    const closest_point = wall.start.add(start_end.scale(t));
    return closest_point.subtract(ball.position);
}
