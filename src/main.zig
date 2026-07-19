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

    pub fn draw(self: *Ball) void {
        rl.drawCircle(self.x, self.y, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        if (self.y <= window_height) self.y += gravity;
    }
};

pub fn main() !void {
    rl.initWindow(window_width, window_height, "Flipper");
    defer rl.closeWindow();

    var ball = Ball{ .x = window_center_x, .y = window_center_y };

    var accumulator: f32 = 0;

    while (!rl.windowShouldClose()) {
        const frame_time = rl.getFrameTime();
        accumulator += frame_time;

        while (accumulator >= physics_step) {
            ball.physics();
            accumulator -= physics_step;
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
        ball.draw();
    }
}
