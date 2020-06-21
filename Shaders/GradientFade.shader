shader_type canvas_item;

uniform float alpha = 0.0;

void fragment() {
  COLOR.rgb = texture(TEXTURE, UV).rgb;
  COLOR.a = clamp(alpha / UV.y, 0.0, 1.0);
}