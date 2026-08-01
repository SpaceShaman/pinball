const GameContext = @import("GameContext.zig");
const rl = @import("raylib");

pub fn drawHud(context: GameContext) void {
    for (1..context.lives + 1) |i| {
        const index: i32 = @intCast(i);
        rl.drawCircle(context.window_width + 10 - 30 * index, 20, 10, .gold);
    }
}
