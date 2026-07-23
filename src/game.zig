const std = @import("std");
const rl = @import("raylib");
const Ball = @import("ball.zig").Ball;
const Wall = @import("wall.zig").Wall;

pub const window_width = 720;
pub const window_height = 1280;

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
        rl.initWindow(window_width, window_height, "Flipper");
        defer rl.closeWindow();

        rl.setWindowMonitor(2);

        try self.addWall(Wall.init(1, 0, 1, 1280)); // left
        try self.addWall(Wall.init(720, 0, 720, 1280)); // right
        try self.addWall(Wall.init(0, 1280, 720, 1280)); // bottom
        try self.addWall(Wall.init(0, 1, 720, 1)); // top
        try self.addWall(Wall.init(0, 980, 300, 1280));
        try self.addWall(Wall.init(720, 980, 720 - 300, 1280));

        const ball = Ball.init(100, 50, &self.walls);
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
