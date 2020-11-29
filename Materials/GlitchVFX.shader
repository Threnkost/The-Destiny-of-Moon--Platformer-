shader_type canvas_item;

uniform sampler2D fx_texture;
uniform float amount = 0;
uniform float wavelength = 1.0;
uniform float abberation_amount = 1.0;
uniform bool chromatic_abberation = false;
uniform bool random = false;

float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void fragment() {
	vec4 color = texture(fx_texture, UV);
	float adjusted_amount = amount;
	vec2 newUV;
	if (random) {
		newUV = UV + color.xy * rand(vec2(TIME, amount)) / 100.0 * wavelength;	
	}
	else {
		newUV = UV + color.xy * amount / 100.0 * wavelength;
	}
	vec4 adjusted_color = texture(TEXTURE, newUV);

	if (chromatic_abberation) {
		float adjusted_abberation_amount = abberation_amount / 100.0;
		adjusted_color.r = texture(TEXTURE, vec2(UV.x + adjusted_abberation_amount, UV.y)).r;
		adjusted_color.g = texture(TEXTURE, UV).g;
		adjusted_color.b = texture(TEXTURE, vec2(UV.x - adjusted_abberation_amount, UV.y)).b;
	}
 
	COLOR = adjusted_color;
}