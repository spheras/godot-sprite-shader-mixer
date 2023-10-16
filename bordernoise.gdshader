uniform bool BORDERNOISE_active = true;
uniform float BORDERNOISE_max_line_width:hint_range(0.0, 50.0, 0.1) = 10.0;
uniform float BORDERNOISE_min_line_width:hint_range(0.0, 1000.0, 0.1) = 88.0;
uniform float BORDERNOISE_freq:hint_range(0.0, 12.0, 0.1) = 1.0;
uniform float BORDERNOISE_block_size:hint_range(0.0, 100.0, 0.1) = 20.0;
uniform vec4 BORDERNOISE_starting_colour : source_color= vec4(0,0,0,1);
uniform vec4 BORDERNOISE_ending_colour: source_color = vec4(1,0,0,1);
const float BORDERNOISE_pi = 3.1415;
const int BORDERNOISE_ang_res = 16;
const int BORDERNOISE_grad_res = 8;
float BORDERNOISE_hash(vec2 p, float s) {
	return fract(35.1 * sin(dot(vec3(112.3, 459.2, 753.2), vec3(p, s))));
}
float BORDERNOISE_noise(vec2 p, float s) {
	vec2 d = vec2(0, 1)*sin(TIME);
	vec2 b = floor(p)*sin(TIME);
	vec2 f = fract(p);
	return mix(
		mix(BORDERNOISE_hash(b + d.xx, s), BORDERNOISE_hash(b + d.yx, s), f.x),
		mix(BORDERNOISE_hash(b + d.xy, s), BORDERNOISE_hash(b + d.yy, s), f.x), f.y);
}
float BORDERNOISE_getLineWidth(vec2 p, float s) {
	p /= BORDERNOISE_block_size;
	float w = 0.0;
	float intensity = 1.0;
	for (int i = 0; i < 3; i++) {
		w = mix(w, BORDERNOISE_noise(p, s), intensity);
		p /= 2.0;
		intensity /= 2.0;
	}
	
	return mix(BORDERNOISE_max_line_width, BORDERNOISE_min_line_width, w);
}
bool BORDERNOISE_pixelInRange(sampler2D text, vec2 uv, vec2 dist) {
	float alpha = 0.0;
	for (int i = 0; i < BORDERNOISE_ang_res; i++) {
		float angle = 2.0 * BORDERNOISE_pi * float(i) / float(BORDERNOISE_ang_res);
		vec2 disp = dist * vec2(cos(angle), sin(angle));
		if (texture(text, uv + disp).a > 0.0) return true;
	}
	return false;
}
float BORDERNOISE_getClosestDistance(sampler2D text, vec2 uv, vec2 maxDist) {
	if (!BORDERNOISE_pixelInRange(text, uv, maxDist)) return -1.0;
	
	float hi = 1.0; float lo = 0.0;
	
	for (int i = 1; i <= BORDERNOISE_grad_res; i++) {
		float curr = (hi + lo) / 2.0;
		if (BORDERNOISE_pixelInRange(text, uv, curr * maxDist)) {
			hi = curr;
		}
		else {
			lo = curr;
		}
	}
	return hi;
	
}
void borderNoise(in vec2 uv, in sampler2D txt, vec2 size, vec2 pixelSize, inout vec4 color){
	float timeStep = floor(BORDERNOISE_freq * TIME);
	vec2 scaledDist = pixelSize;
	scaledDist *= BORDERNOISE_getLineWidth(uv / pixelSize, timeStep);
	float w = BORDERNOISE_getClosestDistance(txt, uv, scaledDist);
	
	if (( w > 0.0) && (texture(txt, uv).a < 0.2)) {
		color = mix(BORDERNOISE_starting_colour, BORDERNOISE_ending_colour, tanh(3.0*w));
	}
}