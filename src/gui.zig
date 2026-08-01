const rl = @import("raylib");
const rg = @import("raygui");

pub fn drawText(text: [:0]const u8, x: f32, y: f32) !void {
    const font = try rl.getFontDefault();
    const font_size = 30.0;
    const spacing = 1.0;
    const text_size = rl.measureTextEx(font, text, font_size, spacing);
    const position = rl.Vector2.init(x - text_size.x / 2, y - font_size / 2);

    rl.drawTextEx(
        font,
        text,
        position,
        font_size,
        spacing,
        .white,
    );
}

pub fn button(text: [:0]const u8, x: f32, y: f32) bool {
    const padding: f32 = 10.0;
    const text_width: f32 = @floatFromInt(rg.getTextWidth(text));
    const text_height: f32 = @floatFromInt(rg.getStyle(.default, .text_size));
    const width = text_width + padding * 2;
    const height = text_height + padding * 2;

    return rg.button(
        .{
            .x = x - width / 2,
            .y = y - height / 2,
            .width = width,
            .height = height,
        },
        "Try again!",
    );
}
