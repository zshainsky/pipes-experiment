shader_type canvas_item;

// CORRECT SYNTAX (Godot 4.3+)
// To apply a hint to a built-in variable like TEXTURE, you now
// place the hint on its own line. This gets the pure, un-modulated color.


// CORRECT SYNTAX (Godot 4.3+)
// Hints for custom uniforms now use the @annotation syntax.
uniform sampler2D mask_texture;

void fragment() {
    // 1. Get the original color from the sprite's texture.
    vec4 original_color = texture(TEXTURE, UV);

    // 2. Get the alpha value from our mask texture (the drawn curve).
    // The .a at the end gets only the alpha channel.
    float mask_alpha = texture(mask_texture, UV).a;

    // 3. This is the fix for the visual bug (premultiplied alpha).
    // We multiply the sprite's entire color vector (R,G,B, and A)
    // by the mask's alpha. This scales color and transparency together,
    // preventing weird halos or color fringes at the edges.
    original_color *= mask_alpha;

    // 4. Set the final pixel color.
    COLOR = original_color;
}