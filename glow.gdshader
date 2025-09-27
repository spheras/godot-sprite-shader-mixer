uniform bool GLOW_active = true;
uniform vec4 glow_color : source_color = vec4(1.0);
uniform float glow_power: hint_range(0.0, 100.0, .1) = 2.0;
uniform float glow_shift: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float glow_radius: hint_range(1.0, 50.0, 1.0) = 1.0;


void glow(in vec2 uv, in sampler2D tex, in vec2 size, in vec2 pix_size, inout vec4 color) {
	vec4 glow = vec4(0.0);
	float count = 0.0;
	for (float x = -glow_radius; x <= glow_radius; x += 1.0) {
		for (float y = -glow_radius; y <= glow_radius; y += 1.0) {
			vec2 offset = vec2(x, y) * glow_shift * pix_size;
			glow += texture(tex, uv + offset) * glow_color;
			count += 1.0;
		}
	}
	glow *= glow_power / count;
	color = mix(texture(tex, uv), glow, glow.a) ;
}
