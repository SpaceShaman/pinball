const std = @import("std");
const rl = @import("raylib");
const config = @import("config.zig");
const Ball = @import("ball.zig").Ball;
const Wall = @import("wall.zig").Wall;

pub const Game = struct {
    allocator: std.mem.Allocator,
    balls: std.ArrayList(Ball),
    walls: std.ArrayList(Wall),

    pub fn init(allocator: std.mem.Allocator) Game {
        return Game{ .allocator = allocator, .balls = .empty, .walls = .empty };
    }

    pub fn deinit(self: *Game) void {
        self.balls.deinit(self.allocator);
        self.walls.deinit(self.allocator);
    }

    pub fn start(self: *Game) !void {
        rl.initWindow(config.window_width, config.window_height, "Flipper");
        defer rl.closeWindow();

        rl.setWindowMonitor(2);

        try self.addWall(Wall.init(0, 400, 400, 720));
        try self.addWall(Wall.init(0, 720, 1280, 720));
        try self.addWall(Wall.init(1280, 0, 1280, 720));

        const ball = Ball.init(0, 0, &self.walls);
        try self.addBall(ball);

        while (!rl.windowShouldClose()) {
            self.loop();
        }
    }

    fn loop(self: *Game) void {
        self.physics();
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
        self.draw();
    }

    fn addBall(self: *Game, ball: Ball) !void {
        try self.balls.append(self.allocator, ball);
    }

    fn addWall(self: *Game, wall: Wall) !void {
        try self.walls.append(self.allocator, wall);
    }

    fn draw(self: *const Game) void {
        for (self.walls.items) |*wall| wall.draw();
        for (self.balls.items) |*ball| ball.draw();
    }

    fn physics(self: *Game) void {
        for (self.balls.items) |*ball| ball.physics();
    }
};
