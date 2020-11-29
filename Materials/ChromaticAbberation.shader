shader_type canvas_item;

uniform int amount : hint_range(0, 10);

void fragment() {
	
	vec4 texture_color = texture(TEXTURE, UV);
	if (amount > 0) {
		float adjusted_amount = float(amount) / 100.0;
		texture_color.r = texture(TEXTURE, vec2(UV.x + adjusted_amount, UV.y)).r;
		texture_color.g = texture(TEXTURE, UV).g;
		texture_color.b = texture(TEXTURE, vec2(UV.x - adjusted_amount, UV.y)).b;
	}
	COLOR = texture_color;

}