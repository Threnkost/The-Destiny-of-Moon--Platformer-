shader_type canvas_item;

const vec3 red = vec3(1.0, 0.0, 0.0);
const vec3 blue = vec3(0.0, 0.0, 1.0);

void fragment() {
	
	vec4 color = texture(TEXTURE, UV);
	color += vec4(abs(sin(1.0 * TIME)),0.0,0.0,0.0);
	
	COLOR = color;
}