const rl = @import("raylib");

pub fn main() anyerror!void {
    rl.initWindow(1280, 720, "Flipper");
    defer rl.closeWindow();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        rl.drawText("Welcome in Flipper game ;)", 200, 310, 40, .black);
    }
}
