const GameContext = @import("GameContext.zig");
const Ball = @import("Ball.zig");
const Wall = @import("Wall.zig");
const Flipper = @import("Flipper.zig");
const drawHud = @import("hud.zig").drawHud;
const resolveWallCollisions = @import("collisions.zig").resolveWallCollisions;
const rl = @import("raylib");
const Vector2 = rl.Vector2;
const rg = @import("raygui");
const gui = @import("gui.zig");
const std = @import("std");

const Game = @This();

context: GameContext,
ball: Ball,
walls: []const Wall,
flippers: []Flipper,

pub fn init(walls: []const Wall, flippers: []Flipper) Game {
    return Game{
        .context = GameContext{},
        .ball = Ball.init(100, 50),
        .walls = walls,
        .flippers = flippers,
    };
}

pub fn start(self: *Game) !void {
    rl.initWindow(self.context.window_width, self.context.window_height, "Flipper");
    defer rl.closeWindow();

    rl.setWindowMonitor(2);

    rg.setStyle(
        .default,
        .text_size,
        24,
    );
    rg.setStyle(
        .default,
        .text_alignment_vertical,
        @intFromEnum(rg.TextAlignmentVertical.middle),
    );

    while (!rl.windowShouldClose()) {
        self.context.lives = 3;
        try self.gameOver();
        self.gameLoop();
    }
}

fn gameLoop(self: *Game) void {
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

        if (self.context.lives == 0) break;
    }
}

fn gameOver(self: *Game) !void {
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(.black);
        if (try gui.drawGameOver(self.context)) break;
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
    self.ball.update(dt, &self.context);
    resolveWallCollisions(&self.ball, self.walls);
    for (self.flippers) |*flipper| {
        flipper.update(dt);
        resolveWallCollisions(&self.ball, &flipper.walls);
    }
}

fn draw(self: *Game) void {
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.clearBackground(.black);

    self.ball.draw();
    for (self.walls) |*wall| wall.draw();
    for (self.flippers) |*flipper| flipper.draw();
    drawHud(self.context);
}
