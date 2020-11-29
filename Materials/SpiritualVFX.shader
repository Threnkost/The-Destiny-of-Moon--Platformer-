shader_type canvas_item;

uniform bool active = false;
uniform sampler2D noise;


void fragment() {
	if (active) {
		vec3 noise_texture = texture(noise,UV).rgb;
		vec4 color = vec4(0, noise_texture.x, 0, 0.0);
		color.a = clamp(sin(TIME*0.65), -0.5, 0.5);
		COLOR = color;
		
		
	} else {
		COLOR = vec4(0,0,0,0);
	}
}