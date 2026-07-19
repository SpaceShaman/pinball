const std = @import("std");
const Game = @import("game.zig").Game;

pub fn main(init: std.process.Init) !void {
    var game = Game.init(init.gpa);
    defer game.deinit();
    try game.start();
}
