const rl = @import("raylib");
const Vector2 = rl.Vector2;
const Ball = @import("Ball.zig");
const pinball = @import("pinball");
const Wall = pinball.Wall;
const Flipper = @import("Flipper.zig");

pub fn resolveWallCollisions(ball: *Ball, walls: []const Wall) void {
    for (walls) |wall| {
        if (wall.checkCollisionCircle(ball.position, ball.radius)) {
            resolveWallCollision(ball, wall);
        }
    }
}

fn resolveWallCollision(ball: *Ball, wall: Wall) void {
    reduceDepth(ball, wall);
    const collision_normal = wall.collisionNormal(ball.position);
    const velocity_n = collision_normal.scale(ball.velocity.dotProduct(collision_normal));
    const velocity_t = ball.velocity.subtract(velocity_n);
    const reduced_velocity_n = velocity_n.scale(ball.bounciness);
    ball.velocity = velocity_t.add(reduced_velocity_n.negate()).add(wall.linearVelocity(ball.position));
}

fn reduceDepth(ball: *Ball, wall: Wall) void {
    const distance = wall.distance(ball.position);
    if (distance < ball.radius) {
        const depth = ball.radius - distance;
        const collision_normal = wall.collisionNormal(ball.position);
        ball.position = ball.position.add(collision_normal.negate().scale(depth));
    }
}
