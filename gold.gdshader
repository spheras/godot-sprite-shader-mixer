//GOLD
uniform bool  GOLD_active  = true;
uniform float GOLD_offset: hint_range(0, 100) = 0;
uniform float GOLD_speed : hint_range(0, 10) = 1;
uniform float GOLD_mix : hint_range(0,1)=0;
float gold_calc_luminance(vec3 color)
{
    return dot(color, vec3( 0.299, 0.587, 0.114));
}
float gold_mark_light(vec2 uv, float value)
{
	vec2 co = uv * 5.0;
	float n = sin(value + co.x) + sin(value - co.x) + sin(value + co.y) + sin(value + 2.5 * co.y);
	return fract((5.0 + n) / 5.0);
}
void gold(in vec2 uv, in sampler2D txt, in vec2 spriteSize, in vec2 pixelSize, inout vec4 finalColor)
{
	float value = GOLD_offset + TIME * GOLD_speed;
	vec4 txt_color = texture(txt, uv);
	float luminance = gold_calc_luminance(txt_color.rbg);
	vec3 metal = vec3(luminance);
	metal.r = luminance * pow(1.5 * luminance, 3.0);
	metal.g = luminance * pow(1.5 * luminance, 3.0);
	metal.b = luminance * pow(0.75 * luminance, 3.0);
	
	float n = gold_mark_light(uv, value);
	n += dot(txt_color.rbg, vec3(0.2, 0.4, 0.2));
	n = fract(n);
	
	float a = clamp(abs(n * 6.0 - 2.0), 0.0, 1.0);
	vec4 color = vec4(metal.rgb + (1.0 - a), 1.0);
	color.rgb = color.rgb * 0.5 + dot(color.rgb, vec3 (0.113, 0.455, 0.172)) - vec3(0.0, 0.1, 0.6) + 0.025;
	color.a = txt_color.a;
	finalColor = mix(color, finalColor, GOLD_mix); 
}

