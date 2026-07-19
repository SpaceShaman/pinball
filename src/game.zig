const std = @import("std");
const rl = @import("raylib");
const config = @import("config.zig");
const Ball = @import("ball.zig").Ball;

pub const Game = struct {
    allocator: std.mem.Allocator,
    accumulator: f32 = 0,
    balls: std.ArrayList(Ball),

    pub fn init(allocator: std.mem.Allocator) Game {
        return Game{ .allocator = allocator, .balls = .empty };
    }

    pub fn deinit(self: *Game) void {
        self.balls.deinit(self.allocator);
    }

    pub fn start(self: *Game) !void {
        rl.initWindow(config.window_width, config.window_height, "Flipper");
        defer rl.closeWindow();

        const window_center_x = config.window_width / 2;
        try self.addBall(.{ .x = window_center_x, .y = 0 });

        while (!rl.windowShouldClose()) {
            self.loop();
        }
    }

    fn loop(self: *Game) void {
        const frame_time = rl.getFrameTime();
        self.accumulator += frame_time;

        while (self.accumulator >= config.physics_step) {
            self.physics();
            self.accumulator -= config.physics_step;
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
        self.draw();
    }

    fn addBall(self: *Game, ball: Ball) !void {
        try self.balls.append(self.allocator, ball);
    }

    fn draw(self: *const Game) void {
        for (self.balls.items) |*ball| ball.draw();
    }

    fn physics(self: *Game) void {
        for (self.balls.items) |*ball| ball.physics();
    }
};
