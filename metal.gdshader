//METAL
uniform bool  METAL_active  = false;
uniform float METAL_offset: hint_range(0, 100) = 0;
uniform float METAL_speed : hint_range(0, 10) = 1;
void metal(in vec2 uv, in sampler2D txt, in vec2 spriteSize, in vec2 pixelSize, inout vec4 finalColor)
{
	float value = METAL_offset + TIME * METAL_speed;
	float luminance = calc_luminance(finalColor.rgb);
	vec3 metal = vec3(luminance * pow(0.666 * luminance, 4.0));
	
	float n = mark_light(uv, value);
	n += dot(finalColor.rbg, vec3(0.2, 0.4, 0.2));
	n = fract(n);
	
	float a = clamp(abs(n * 6.0 - 2.0), 0.0, 1.0);
	vec4 color = vec4(metal.rgb + (1. - a), 1.0);
	color.rgb = 0.05 + color.rgb * 0.5 + dot(color.rgb, vec3 (0.2126, 0.2152, 0.1722)) * 0.5;
	color.a = finalColor.a;
	finalColor=color;
}
