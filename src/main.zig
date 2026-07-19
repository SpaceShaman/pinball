const rl = @import("raylib");

const windowWidth = 1280;
const windowHeight = 720;
const windowCenterX = windowWidth / 2;
const windowCenterY = windowHeight / 2;

pub fn main() anyerror!void {
    rl.initWindow(windowWidth, windowHeight, "Flipper");
    defer rl.closeWindow();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        rl.drawCircle(windowCenterX, windowCenterY, 50, .white);
    }
}
