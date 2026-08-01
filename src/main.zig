const std = @import("std");
const rl = @import("raylib");
const collisions = @import("collisions.zig");
const pinball = @import("pinball");
const Wall = pinball.Wall;
const Flipper = pinball.Flipper;
const Ball = pinball.Ball;

const window_width = 720;
const window_height = 1280;
const physics_dt: f32 = 1.0 / 120.0;

pub fn main() !void {
    const walls = [_]Wall{
        Wall.init(1, 0, 1, 1280), // left
        Wall.init(720, 0, 720, 1280), // right
        Wall.init(0, 1280, 720, 1280), // bottom
        Wall.init(0, 1, 720, 1), // top
        Wall.init(0, 980, 300, 1280),
        Wall.init(720, 980, 720 - 300, 1280),
    };
    var ball = Ball.init(100, 50);

    var flippers = [2]Flipper{
        Flipper.init(230, 1230, Flipper.Side.left),
        Flipper.init(720 - 230, 1230, Flipper.Side.right),
    };

    rl.initWindow(window_width, window_height, "Flipper");
    defer rl.closeWindow();

    rl.setWindowMonitor(2);

    var accumulator: f32 = 0.0;

    while (!rl.windowShouldClose()) {
        onKeyPress(&flippers);
        const frame_dt = @min(rl.getFrameTime(), 0.1);
        accumulator += frame_dt;

        draw(&ball, &walls, &flippers);
        while (accumulator >= physics_dt) {
            update(&ball, &walls, &flippers, physics_dt);
            accumulator -= physics_dt;
        }
    }
}

fn onKeyPress(flippers: []Flipper) void {
    for (flippers) |*flipper| {
        flipper.onKeyPress();
    }
}

fn update(ball: *Ball, walls: []const Wall, flippers: []Flipper, dt: f32) void {
    ball.update(dt);
    collisions.resolveWallCollisions(ball, walls);
    for (flippers) |*flipper| {
        flipper.update(dt);
        collisions.resolveWallCollisions(ball, &flipper.walls);
    }
}

fn draw(ball: *Ball, walls: []const Wall, flippers: []const Flipper) void {
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.clearBackground(.black);

    ball.draw();
    for (walls) |*wall| wall.draw();
    for (flippers) |*flipper| flipper.draw();
}
