const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Flipper = @This();

position: Vector2,
points: [4]Vector2,
velocity: f32 = 0,

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
    return Flipper{ .position = position, .points = points };
}

pub fn draw(self: *const Flipper) void {
    rl.drawCircleV(self.position, 20, .green);
    rl.drawTriangle(self.points[0], self.points[1], self.points[2], .red);
    rl.drawTriangle(self.points[0], self.points[2], self.points[3], .red);
}

pub fn update(self: *Flipper) void {
    if (rl.isKeyDown(rl.KeyboardKey.left)) {
        self.velocity = -10;
    } else if (rl.isKeyDown(rl.KeyboardKey.right)) {
        self.velocity = 10;
    } else {
        self.velocity = 0;
    }
    if (self.velocity != 0) {
        const dt = rl.getFrameTime();
        self.rotate(self.velocity * dt);
    }
}

fn rotate(self: *Flipper, angle: f32) void {
    for (&self.points) |*point| {
        point.* = point.subtract(self.position).rotate(angle).add(self.position);
    }
}
