const GameContext = @import("GameContext.zig");
const Ball = @import("Ball.zig");
const Wall = @import("Wall.zig");
const Flipper = @import("Flipper.zig");
const drawHud = @import("hud.zig").drawHud;
const resolveWallCollisions = @import("collisions.zig").resolveWallCollisions;
const rl = @import("raylib");
const rg = @import("raygui");

const Game = @This();

context: GameContext,
ball: Ball,
walls: []const Wall,
flippers: []Flipper,

pub fn init(walls: []const Wall, flippers: []Flipper) Game {
    return Game{
        .context = GameContext{ .lives = 1 },
        .ball = Ball.init(100, 50),
        .walls = walls,
        .flippers = flippers,
    };
}

pub fn start(self: *Game) void {
    rl.initWindow(self.context.window_width, self.context.window_height, "Flipper");
    defer rl.closeWindow();

    rl.setWindowMonitor(2);

    self.gameLoop();
    self.gameOver();
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

fn gameOver(self: *Game) void {
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(.black);

        const window_width: f32 = @floatFromInt(self.context.window_width);
        const window_height: f32 = @floatFromInt(self.context.window_height);
        const box_width: f32 = 400.0;
        const box_height: f32 = 100.0;
        const x = (window_width - box_width) / 2;
        const y = (window_height - box_height) / 2;
        _ = rg.messageBox(
            .{ .height = box_height, .width = box_width, .x = x, .y = y },
            "Game Over",
            "Try again!",
            "Start",
        );
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
