const math = @import("std").math;
const rl = @import("raylib");
const Vector2 = rl.Vector2;

pub const Side = enum(c_int) {
    left = 0,
    right = 1,
};

const default_angle: f32 = 0.5;
const Flipper = @This();

position: Vector2,
points: [4]Vector2,
velocity: f32 = 0,
angle: f32 = 0,
side: Side,

pub fn init(x: f32, y: f32, side: Side) Flipper {
    const position = Vector2.init(x, y);
    const height = 20;
    const width = 100;
    const points = [4]Vector2{
        .{ .x = 0 + position.x, .y = position.y - height / 2 },
        .{ .x = 0 + position.x, .y = position.y + height / 2 },
        .{ .x = width + position.x, .y = position.y + height / 2 },
        .{ .x = width + position.x, .y = position.y - height / 2 },
    };
    var flipper = Flipper{ .position = position, .points = points, .side = side };
    if (side == Side.left) {
        flipper.rotate(default_angle);
    } else {
        flipper.rotate(math.degreesToRadians(180) - default_angle);
    }
    return flipper;
}

pub fn draw(self: *const Flipper) void {
    rl.drawCircleV(self.position, 20, .green);
    rl.drawTriangle(self.points[0], self.points[1], self.points[2], .red);
    rl.drawTriangle(self.points[0], self.points[2], self.points[3], .red);
}

pub fn update(self: *Flipper) void {
    var key = rl.KeyboardKey.right;
    if (self.side == Side.left) {
        key = rl.KeyboardKey.left;
    }

    if (rl.isKeyPressed(key)) {
        self.velocity = 15;
    }

    const dt = rl.getFrameTime();
    var velocity_dt = self.velocity * dt;
    if (self.side == Side.left) velocity_dt = -velocity_dt;

    if (self.velocity != 0) {
        self.angle += velocity_dt;
        self.rotate(velocity_dt);
    }

    if (self.side == Side.left) {
        if (self.angle < -1.5) {
            self.rotate(-self.angle);
            self.angle = 0;
            self.velocity = 0;
        }
    } else {
        if (self.angle > 1.5) {
            self.rotate(-self.angle);
            self.angle = 0;
            self.velocity = 0;
        }
    }
}

pub fn rotate(self: *Flipper, angle: f32) void {
    for (&self.points) |*point| {
        point.* = point.subtract(self.position).rotate(angle).add(self.position);
    }
}
