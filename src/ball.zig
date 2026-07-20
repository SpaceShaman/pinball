const rl = @import("raylib");
const config = @import("config.zig");

pub const Ball = struct {
    position: rl.Vector2,
    velocity: rl.Vector2 = rl.Vector2.init(150, 0),
    gravity: f32 = 400,
    bounciness: f32 = 0.8,
    radius: f32 = 20,

    pub fn init(x: f32, y: f32) Ball {
        return Ball{ .position = rl.Vector2.init(x, y) };
    }

    pub fn draw(self: *const Ball) void {
        rl.drawCircleV(self.position, self.radius, .white);
    }

    pub fn physics(self: *Ball) void {
        const bottom: f32 = config.window_height - self.radius;

        if (self.position.y > bottom) {
            self.position.y = bottom;
            if (self.velocity.x < 1 and self.velocity.y < 1) {
                self.position.y = 0.0;
                self.position.x = 0.0;
                self.velocity.x = 150;
                self.velocity.y = 0.0;
            }
            self.velocity = self.velocity.reflect(rl.Vector2.init(0, 1));
            self.velocity = self.velocity.scale(self.bounciness);
        }
        const dt = rl.getFrameTime();
        self.velocity.y += dt * self.gravity;
        const dt_velocity = self.velocity.scale(dt);
        self.position = self.position.add(dt_velocity);
    }
};
