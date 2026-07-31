const std = @import("std");
const expectEqual = std.testing.expectEqual;
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Wall = @This();

start: Vector2,
end: Vector2,

pub fn init(start_x: f32, start_y: f32, end_x: f32, end_y: f32) Wall {
    return Wall{ .start = Vector2.init(start_x, start_y), .end = Vector2.init(end_x, end_y) };
}

pub fn collisionNormal(self: Wall, point: Vector2) Vector2 {
    return self.reflect(point).normalize();
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

pub fn draw(self: Wall) void {
    rl.drawLineV(self.start, self.end, .white);
}

test "closestPoint" {
    const wall = Wall{ .start = Vector2.zero(), .end = Vector2.init(10, 0) };
    const point = Vector2.init(5, 5);
    try expectEqual(Vector2.init(5, 0), wall.closestPoint(point));
}

test "collisionNormal" {
    const wall = Wall{ .start = Vector2.zero(), .end = Vector2.init(10, 0) };
    const point = Vector2.init(5, 5);
    try expectEqual(Vector2.init(0, -1), wall.collisionNormal(point));
}

test "collisionNormal negative" {
    const wall = Wall{ .start = Vector2.zero(), .end = Vector2.init(10, 0) };
    const point = Vector2.init(10, -3);
    try expectEqual(Vector2.init(0, 1), wall.collisionNormal(point));
}
