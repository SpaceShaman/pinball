const rl = @import("raylib");

pub const Wall = struct {
    start: rl.Vector2,
    end: rl.Vector2,

    pub fn init(start_x: f32, start_y: f32, end_x: f32, end_y: f32) Wall {
        return Wall{ .start = rl.Vector2.init(start_x, start_y), .end = rl.Vector2.init(end_x, end_y) };
    }

    pub fn draw(self: *const Wall) void {
        rl.drawLineV(self.start, self.end, .white);
    }
};
