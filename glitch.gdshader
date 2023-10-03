//GLITCH
uniform bool  GLITCH_active  = true;
uniform float GLITCH_offset: hint_range(0, 100) = 0;
uniform float GLITCH_speed : hint_range(0, 10) = 3;
uniform float GLITCH_size : hint_range(0.0, 10.0) = 0.75;
uniform float GLITCH_amount : hint_range(0.0, 24.0) = 10.0;
uniform float GLITCH_mix: hint_range(0.0, 1.0)=1.0;
float rand1(vec2 co, float random_seed)
{
    return fract(sin(dot(co.xy * random_seed, vec2(12.,85.5))) * 120.01);
}
float rand2(vec2 co, float random_seed)
{
    float r1 = fract(sin(dot(co.xy * random_seed ,vec2(12.9898, 78.233))) * 43758.5453);
    return fract(sin(dot(vec2(r1 + co.xy * 1.562) ,vec2(12.9898, 78.233))) * 43758.5453);
}
void glitch(in vec2 uv, in sampler2D tex, vec2 size, vec2 pixelSize, inout vec4 color) {
	float seed = floor(TIME * GLITCH_speed) / 20.0;
	vec2 blockS = floor(uv * vec2 (GLITCH_offset, 50.) * GLITCH_size) * 2.0;
	vec2  blockL = floor(uv * vec2 (GLITCH_offset, 50.) * GLITCH_size) * 1.3;

	float line_noise = pow(rand2(blockS, seed), 5.0) * GLITCH_amount * pow(rand2(blockL, seed), 3.0);
	
	float negative=-1.;
	float random = rand1(vec2(0.1), seed);
	if(  random < 0.5 ){
		negative=1.;
	}	
	vec4 newColor=texture(tex, uv + vec2 (line_noise * 0.02 * negative * rand1(vec2(2.0), seed), 0));
	color = mix(color,newColor, GLITCH_mix);
}

