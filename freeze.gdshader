//FREEZE
uniform bool  FREEZE_active  = true;
uniform float FREEZE_offset: hint_range(0, 100) = 0;
uniform float FREEZE_speed : hint_range(0, 10) = 1;
uniform float FREEZE_mix : hint_range(0,1)=0;
float freeze_calc_luminance(vec3 color)
{
    return dot(color, vec3( 0.299, 0.587, 0.114));
}
float freeze_mark_light(vec2 uv, float value)
{
	vec2 co = uv * 5.0;
	float n = sin(value + co.x) + sin(value - co.x) + sin(value + co.y) + sin(value + 2.5 * co.y);
	return fract((5.0 + n) / 5.0);
}
void freeze(in vec2 uv, in sampler2D txt, in vec2 spriteSize, in vec2 pixelSize, inout vec4 finalColor)
{
	float value = FREEZE_offset + TIME * FREEZE_speed;
	float luminance = freeze_calc_luminance(finalColor.rbg);
	vec3 metal = vec3(1.5 * luminance * luminance);
	
	float n = freeze_mark_light(uv, value);
	n += dot(finalColor.rbg, vec3(0.2, 0.4, 0.2));
	n = fract(n);
	
	float a = clamp(abs(n * 6.0 - 2.0), 0.0, 1.0);
	vec4 color = vec4(metal.rgb + (1.0 - a), 1.0);
	color.rgb = color.rgb * 0.5 + dot(color.rgb, vec3 (0.2, 0.5, 0.1)) - vec3(1.25, 0.5, 0.0);
	color.a = finalColor.a;
	finalColor=mix(color, finalColor, FREEZE_mix);
}
