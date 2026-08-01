const Vector2 = @import("raylib").Vector2;

const GameContext = @This();

window_width: i32 = 720,
window_height: i32 = 1280,
lives: u4 = 3,

pub fn getWindowCenter(self: *const GameContext) Vector2 {
    const window_width: f32 = @floatFromInt(self.window_width);
    const window_height: f32 = @floatFromInt(self.window_height);
    return Vector2.init(
        window_width / 2,
        window_height / 2,
    );
}
