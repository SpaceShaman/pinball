const std = @import("std");
const rl = @import("raylib");
const Ball = @import("Ball.zig");
const Wall = @import("Wall.zig");
const Flipper = @import("Flipper.zig");
const collisions = @import("collisions.zig");

const window_width = 720;
const window_height = 1280;

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

    var flipper = Flipper.init(240, 1230);

    rl.initWindow(window_width, window_height, "Flipper");
    defer rl.closeWindow();

    rl.setWindowMonitor(2);

    while (!rl.windowShouldClose()) {
        update(&ball, &walls);
        draw(&ball, &walls);
        flipper.update();
        flipper.draw();
    }
}

fn update(ball: *Ball, walls: []const Wall) void {
    ball.update();
    collisions.resolveWallCollisions(ball, walls);
}

fn draw(ball: *Ball, walls: []const Wall) void {
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.clearBackground(.black);

    ball.draw();
    for (walls) |*wall| wall.draw();
}
