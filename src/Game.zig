const Ball = @import("Ball.zig");
const Wall = @import("Wall.zig");
const Flipper = @import("Flipper.zig");
const resolveWallCollisions = @import("collisions.zig").resolveWallCollisions;
const rl = @import("raylib");

const Game = @This();

ball: *Ball,
walls: []const Wall,
flippers: []Flipper,

pub fn init(ball: *Ball, walls: []const Wall, flippers: []Flipper) Game {
    return Game{
        .ball = ball,
        .walls = walls,
        .flippers = flippers,
    };
}

pub fn start(self: *Game) void {
    rl.initWindow(720, 1280, "Flipper");
    defer rl.closeWindow();

    rl.setWindowMonitor(2);

    const physics_dt: f32 = 1.0 / 120.0;
    var accumulator: f32 = 0.0;

    while (!rl.windowShouldClose()) {
        self.onKeyPress();
        const frame_dt = @min(rl.getFrameTime(), 0.1);
        accumulator += frame_dt;

        while (accumulator >= physics_dt) {
            self.update(physics_dt);
            accumulator -= physics_dt;
        }
        self.draw();
    }
}

fn onKeyPress(self: *Game) void {
    const key = rl.getKeyPressed();
    if (key == rl.KeyboardKey.null) return;
    for (self.flippers) |*flipper| {
        flipper.onKeyPress(key);
    }
}

fn update(self: *Game, dt: f32) void {
    self.ball.update(dt);
    resolveWallCollisions(self.ball, self.walls);
    for (self.flippers) |*flipper| {
        flipper.update(dt);
        resolveWallCollisions(self.ball, &flipper.walls);
    }
}

fn draw(self: *Game) void {
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.clearBackground(.black);

    self.ball.draw();
    for (self.walls) |*wall| wall.draw();
    for (self.flippers) |*flipper| flipper.draw();
}
