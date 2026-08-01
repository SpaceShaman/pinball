const rl = @import("raylib");

pub fn drawHud(window_width: i32, lives: u4) void {
    for (1..lives + 1) |i| {
        const index: i32 = @intCast(i);
        rl.drawCircle(window_width + 10 - 30 * index, 20, 10, .gold);
    }
}
