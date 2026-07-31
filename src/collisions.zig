const rl = @import("raylib");
const Vector2 = rl.Vector2;
const fl = @import("flipper");
const Ball = @import("Ball.zig");
const Wall = fl.Wall;
const Flipper = @import("Flipper.zig");

pub fn resolveFlipperCollisions(ball: *Ball, flipper: Flipper) void {
    const points = flipper.points;
    const walls = [4]Wall{
        .{ .start = points[0], .end = points[1] },
        .{ .start = points[1], .end = points[2] },
        .{ .start = points[0], .end = points[3] },
        .{ .start = points[2], .end = points[3] },
    };

    for (walls) |wall| {
        if (checkCollisionWall(ball, wall)) {
            resolveFlipperCollision(ball, wall, flipper);
        }
        wall.draw();
    }
}

fn resolveFlipperCollision(ball: *Ball, wall: Wall, flipper: Flipper) void {
    const reflection = lineReflect(ball, wall);
    const distance = reflection.length();
    const reflection_n = reflection.normalize();
    if (distance < ball.radius) {
        const depth = ball.radius - distance;
        ball.position = ball.position.add(reflection_n.negate().scale(depth));
    }

    var velocity_n = reflection_n.scale(ball.velocity.dotProduct(reflection_n));

    velocity_n = velocity_n.scale(flipper.velocity * 0.1);
    const velocity_t = ball.velocity.subtract(velocity_n);
    const reduced_velocity_n = velocity_n.scale(ball.bounciness);
    ball.velocity = velocity_t.add(reduced_velocity_n.negate());
}

pub fn resolveWallCollisions(ball: *Ball, walls: []const Wall) void {
    for (walls) |wall| {
        if (checkCollisionWall(ball, wall)) {
            resolveWallCollision(ball, wall);
        }
    }
}

fn checkCollisionWall(ball: *const Ball, wall: Wall) bool {
    return rl.checkCollisionCircleLine(
        ball.position,
        ball.radius,
        wall.start,
        wall.end,
    );
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
