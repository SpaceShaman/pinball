const std = @import("std");
const rl = @import("raylib");
const Ball = @import("Ball.zig");
const Flipper = @import("Flipper.zig");
const collisions = @import("collisions.zig");
const fl = @import("flipper");
const Wall = fl.Wall;

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

    var flipper_left = Flipper.init(230, 1230, Flipper.Side.left);
    var flipper_right = Flipper.init(720 - 230, 1230, Flipper.Side.right);

    rl.initWindow(window_width, window_height, "Flipper");
    defer rl.closeWindow();

    rl.setWindowMonitor(2);

    while (!rl.windowShouldClose()) {
        ball.update();
        flipper_left.update();
        flipper_right.update();
        collisions.resolveWallCollisions(&ball, &walls);
        collisions.resolveFlipperCollisions(&ball, flipper_left);
        collisions.resolveFlipperCollisions(&ball, flipper_right);
        draw(&ball, &walls);
        flipper_left.draw();
        flipper_right.draw();
    }
}

fn draw(ball: *Ball, walls: []const Wall) void {
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.clearBackground(.black);

    ball.draw();
    for (walls) |*wall| wall.draw();
}
