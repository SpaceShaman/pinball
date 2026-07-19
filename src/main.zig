const std = @import("std");
const rl = @import("raylib");
const print = @import("std").debug.print;

const window_width = 1280;
const window_height = 720;
const window_center_x = window_width / 2;
const window_center_y = window_height / 2;
const gravity = 2;
const physics_step: f32 = 1.0 / 60.0;

const Ball = struct {
    x: i32,
    y: i32,
    radius: f32 = 30,

    pub fn draw(self: *const Ball) void {
        rl.drawCircle(self.x, self.y, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        if (self.y <= window_height) self.y += gravity;
    }
};

const Game = struct {
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
        rl.initWindow(window_width, window_height, "Flipper");
        defer rl.closeWindow();

        try self.addBall(.{ .x = window_center_x, .y = window_center_y });

        while (!rl.windowShouldClose()) {
            self.loop();
        }
    }

    fn loop(self: *Game) void {
        const frame_time = rl.getFrameTime();
        self.accumulator += frame_time;

        while (self.accumulator >= physics_step) {
            self.physics();
            self.accumulator -= physics_step;
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

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    var game = Game.init(allocator);
    defer game.deinit();

    try game.start();
}
