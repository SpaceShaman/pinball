const rl = @import("raylib");
const Vector2 = rl.Vector2;

const default_angle: f32 = 0.5;
const Flipper = @This();

position: Vector2,
points: [4]Vector2,
velocity: f32 = 0,
angle: f32 = 0,

pub fn init(x: f32, y: f32) Flipper {
    const position = Vector2.init(x, y);
    const height = 20;
    const width = 100;
    const points = [4]Vector2{
        .{ .x = 0 + position.x, .y = position.y - height / 2 },
        .{ .x = 0 + position.x, .y = position.y + height / 2 },
        .{ .x = width + position.x, .y = position.y + height / 2 },
        .{ .x = width + position.x, .y = position.y - height / 2 },
    };
    var flipper = Flipper{ .position = position, .points = points };
    flipper.rotate(default_angle);
    return flipper;
}

pub fn draw(self: *const Flipper) void {
    rl.drawCircleV(self.position, 20, .green);
    rl.drawTriangle(self.points[0], self.points[1], self.points[2], .red);
    rl.drawTriangle(self.points[0], self.points[2], self.points[3], .red);
}

pub fn update(self: *Flipper) void {
    if (rl.isKeyPressed(rl.KeyboardKey.left)) {
        self.velocity = 15;
    }
    if (self.velocity != 0) {
        const dt = rl.getFrameTime();
        self.angle += -self.velocity * dt;
        self.rotate(-self.velocity * dt);
    }
    if (self.angle < -2) {
        self.rotate(-self.angle);
        self.angle = 0;
        self.velocity = 0;
    }
}

pub fn rotate(self: *Flipper, angle: f32) void {
    for (&self.points) |*point| {
        point.* = point.subtract(self.position).rotate(angle).add(self.position);
    }
}
