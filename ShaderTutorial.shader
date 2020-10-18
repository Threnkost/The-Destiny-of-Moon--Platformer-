shader_type canvas_item;

vec4 get_red() {
	return vec4(1.0, 0.0, 0.0, 1.0);
}

void fragment() {
	
	float red = abs(sin(UV));
	COLOR = vec4(red, 1.0, 1.0, 1.0);
	
}