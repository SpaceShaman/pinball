const rl = @import("raylib");

const windowWidth = 1280;
const windowHeight = 720;
const windowCenterX = windowWidth / 2;
const windowCenterY = windowHeight / 2;

const Ball = struct {
    x: i32,
    y: i32,
    radius: f32 = 30,

    pub fn init(x: i32, y: i32) Ball {
        return Ball{
            .x = x,
            .y = y,
        };
    }

    pub fn draw(self: Ball) void {
        rl.drawCircle(self.x, self.y, self.radius, .white);
    }
};

pub fn main() !void {
    rl.initWindow(windowWidth, windowHeight, "Flipper");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        const ball = Ball.init(windowCenterX, windowCenterY);
        ball.draw();
    }
}
