const std = @import("std");
const rl = @import("raylib");
const Ball = @import("ball.zig").Ball;
const Wall = @import("wall.zig").Wall;

pub const window_width = 720;
pub const window_height = 1280;

pub const Game = struct {
    ball: Ball,
    walls: []const Wall,

    pub fn init() Game {
        const walls = [_]Wall{
            Wall.init(1, 0, 1, 1280), // left
            Wall.init(720, 0, 720, 1280), // right
            Wall.init(0, 1280, 720, 1280), // bottom
            Wall.init(0, 1, 720, 1), // top
            Wall.init(0, 980, 300, 1280),
            Wall.init(720, 980, 720 - 300, 1280),
        };
        const ball = Ball.init(100, 50, &walls);
        return Game{ .ball = ball, .walls = &walls };
    }

    pub fn start(self: *Game) !void {
        rl.initWindow(window_width, window_height, "Flipper");
        defer rl.closeWindow();

        rl.setWindowMonitor(2);

        while (!rl.windowShouldClose()) {
            self.update();
        }
    }
};
