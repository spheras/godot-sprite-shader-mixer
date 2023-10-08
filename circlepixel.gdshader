//CIRCLE PIXEL
uniform bool CIRCLEPIXEL_active=true;
uniform float CIRCLEPIXEL_amount_x: hint_range(0, 256) = 8;
uniform float CIRCLEPIXEL_amount_y: hint_range(0, 256) = 8;
uniform float CIRCLEPIXEL_mix: hint_range(0.0, 1.0, 0.1)=0;
void circlePixel(in vec2 uv, in sampler2D sampler, vec2 size, vec2 pixelSize, inout vec4 color){
	vec2 pos = uv;
	pos *= vec2(CIRCLEPIXEL_amount_x, CIRCLEPIXEL_amount_y);
	pos = ceil(pos);
	pos /= vec2(CIRCLEPIXEL_amount_x, CIRCLEPIXEL_amount_y);
	vec2 cellpos = pos - (0.5 / vec2(CIRCLEPIXEL_amount_x, CIRCLEPIXEL_amount_y));
	
	pos -= uv;
	pos *= vec2(CIRCLEPIXEL_amount_x, CIRCLEPIXEL_amount_y);
	pos = vec2(1.0) - pos;
	
	float dist = distance(pos, vec2(0.5));

	vec4 c = texture(sampler, cellpos);
	if(c.a==0.){
		c=c+color;
	}
	vec4 newColor = c * step(0.0, (0.5* c.a) - dist);
	color = mix(newColor, color, CIRCLEPIXEL_mix);
}