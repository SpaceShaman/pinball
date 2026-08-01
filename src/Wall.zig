const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Wall = @This();

start: Vector2,
end: Vector2,
angular_velocity: f32 = 0,

pub fn init(start_x: f32, start_y: f32, end_x: f32, end_y: f32) Wall {
    return Wall{ .start = Vector2.init(start_x, start_y), .end = Vector2.init(end_x, end_y) };
}

pub fn checkCollisionCircle(self: Wall, center: Vector2, radius: f32) bool {
    return rl.checkCollisionCircleLine(center, radius, self.start, self.end);
}

pub fn collisionNormal(self: Wall, point: Vector2) Vector2 {
    return self.reflect(point).normalize();
}

pub fn linearVelocity(self: Wall, point: Vector2) Vector2 {
    const closest_point = self.closestPoint(point);
    const start_to_closest = closest_point.subtract(self.start);

    if (self.angular_velocity != 0)
        return Vector2.init(-start_to_closest.y, start_to_closest.x)
            .scale(self.angular_velocity);

    return Vector2.zero();
}

pub fn draw(self: Wall) void {
    rl.drawLineV(self.start, self.end, .white);
}

pub fn distance(self: Wall, point: Vector2) f32 {
    return self.reflect(point).length();
}

fn reflect(self: Wall, point: Vector2) Vector2 {
    return self.closestPoint(point).subtract(point);
}

fn closestPoint(self: Wall, point: Vector2) Vector2 {
    return self.start.add(self.startToEnd()
        .scale(self.interpolationParameter(point)));
}

fn interpolationParameter(self: Wall, point: Vector2) f32 {
    const start_to_end = self.startToEnd();
    const start_to_point = self.startToPoint(point);
    return start_to_end.dotProduct(start_to_point) / start_to_end.dotProduct(start_to_end);
}

fn startToEnd(self: Wall) Vector2 {
    return self.end.subtract(self.start);
}

fn startToPoint(self: Wall, point: Vector2) Vector2 {
    return point.subtract(self.start);
}

const expectEqual = @import("std").testing.expectEqual;

test "closestPoint" {
    const wall = Wall.init(0, 0, 10, 0);
    try expectEqual(Vector2.init(5, 0), wall.closestPoint(Vector2.init(5, 5)));
}

test "collisionNormal" {
    const wall = Wall.init(0, 0, 10, 0);
    try expectEqual(Vector2.init(0, -1), wall.collisionNormal(Vector2.init(5, 5)));
}

test "collisionNormal negative" {
    const wall = Wall.init(0, 0, 10, 0);
    try expectEqual(Vector2.init(0, 1), wall.collisionNormal(Vector2.init(10, -3)));
}

test "linearVelocity" {
    var wall = Wall.init(0, 0, 2, 0);
    wall.angular_velocity = 3;
    try expectEqual(Vector2.init(0, 6), wall.linearVelocity(Vector2.init(2, 5)));
}

test "linearVelocity negative angular_velocity" {
    var wall = Wall.init(0, 0, 2, 0);
    wall.angular_velocity = -3;
    try expectEqual(Vector2.init(0, -6), wall.linearVelocity(Vector2.init(2, 5)));
}

test "linearVelocity complicated" {
    var wall = Wall.init(10, 10, 13, 14);
    wall.angular_velocity = 2;
    try expectEqual(Vector2.init(-8, 6), wall.linearVelocity(Vector2.init(13, 14)));
}
