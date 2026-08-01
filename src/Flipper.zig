const std = @import("std");
const print = std.debug.print;
const math = @import("std").math;
const rl = @import("raylib");
const Vector2 = rl.Vector2;
const pinball = @import("pinball");
const Wall = pinball.Wall;

pub const Side = enum(c_int) {
    left = 0,
    right = 1,
};

const default_angle: f32 = 0.5;
const Flipper = @This();

position: Vector2,
walls: [4]Wall,
velocity: f32 = 0,
angle: f32 = 0,
side: Side,

pub fn init(x: f32, y: f32, side: Side) Flipper {
    const position = Vector2.init(x, y);
    const height = 20;
    const width = 100;

    const left_top = Vector2.init(position.x, position.y - height / 2);
    const left_bottom = Vector2.init(position.x, position.y + height / 2);
    const right_top = Vector2.init(position.x + width, position.y - height / 2);
    const right_bottom = Vector2.init(position.x + width, position.y + height / 2);

    const walls = [4]Wall{
        .{ .start = left_top, .end = right_top },
        .{ .start = left_bottom, .end = right_bottom },
        .{ .start = left_top, .end = left_bottom },
        .{ .start = right_top, .end = right_bottom },
    };

    var flipper = Flipper{ .position = position, .walls = walls, .side = side };
    if (side == Side.left) {
        flipper.rotate(default_angle);
    } else {
        flipper.rotate(math.degreesToRadians(180) - default_angle);
    }
    return flipper;
}

pub fn draw(self: *const Flipper) void {
    rl.drawCircleV(self.position, 20, .green);
    for (self.walls) |wall| {
        wall.draw();
    }
}

pub fn onKeyPress(self: *Flipper) void {
    var key = rl.KeyboardKey.right;
    var vel: f32 = 10;
    if (self.side == Side.left) {
        key = rl.KeyboardKey.left;
        vel = -10;
    }

    if (rl.isKeyPressed(key)) {
        self.velocity = vel;
    }
}

pub fn update(self: *Flipper, dt: f32) void {
    const velocity_dt = self.velocity * dt;

    if (self.velocity != 0) {
        self.angle += velocity_dt;
        self.rotate(velocity_dt);
        self.setWallsVelocity();
    }

    if (self.angle < -1.5 or self.angle > 1.5) {
        self.rotate(-self.angle);
        self.angle = 0;
        self.velocity = 0;
        self.setWallsVelocity();
    }
}

fn setWallsVelocity(self: *Flipper) void {
    self.walls[0].angular_velocity = self.velocity;
    self.walls[1].angular_velocity = self.velocity;
}

fn rotate(self: *Flipper, angle: f32) void {
    for (&self.walls) |*wall| {
        wall.start = wall.start.subtract(self.position).rotate(angle).add(self.position);
        wall.end = wall.end.subtract(self.position).rotate(angle).add(self.position);
    }
}
