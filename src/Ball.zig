const GameContext = @import("GameContext.zig");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Ball = @This();

position: Vector2,
velocity: Vector2 = Vector2.init(0, 0),
gravity: f32 = 500,
bounciness: f32 = 0.4,
radius: f32 = 20,

pub fn init(x: f32, y: f32) Ball {
    return Ball{ .position = Vector2.init(x, y) };
}

pub fn draw(self: *const Ball) void {
    rl.drawCircleV(self.position, self.radius, .white);
}

pub fn update(self: *Ball, dt: f32, context: *GameContext) void {
    const dt_velocity = self.velocity.scale(dt);
    self.position = self.position.add(dt_velocity);
    self.velocity.y += dt * self.gravity;

    const y: i32 = @intFromFloat(self.position.y);
    if (y > context.window_height) {
        self.position.x = 100;
        self.position.y = 50;
        self.velocity.x = 0;
        self.velocity.y = 0;
        context.lives -= 1;
    }
}
