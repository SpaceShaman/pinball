const Game = @import("Game.zig");
const Ball = @import("Ball.zig");
const Wall = @import("Wall.zig");
const Flipper = @import("Flipper.zig");
const rl = @import("raylib");

pub fn main() !void {
    const walls = [_]Wall{
        Wall.init(1, 0, 1, 1280), // left
        Wall.init(720, 0, 720, 1280), // right
        Wall.init(0, 1, 720, 1), // top
        Wall.init(0, 980, 300, 1280),
        Wall.init(720, 980, 720 - 300, 1280),
    };

    var flippers = [2]Flipper{
        Flipper.init(220, 1230, Flipper.Side.left),
        Flipper.init(720 - 220, 1230, Flipper.Side.right),
    };

    var game = Game.init(&walls, &flippers);
    try game.start();
}
