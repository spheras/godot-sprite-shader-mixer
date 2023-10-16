//DISOLVE BURN
uniform bool      DISOLVEBURN_active  = true;
uniform sampler2D DISOLVEBURN_noise_tex;
uniform vec4      DISOLVEBURN_burn_color : source_color = vec4(1.0, 0.3, 0.05, 1.0);
uniform float     DISOLVEBURN_process_value : hint_range(0, 1) = 0.33;
void disolveBurn(in vec2 uv, in sampler2D tex, in vec2 spriteSize, in vec2 pixelSize, inout vec4 finalColor)
{
	float noise = texture(DISOLVEBURN_noise_tex, uv).r;
	vec4 color = vec4(smoothstep(DISOLVEBURN_process_value * 0.8, DISOLVEBURN_process_value + 0.15, noise));
	color = finalColor * color;
	color.r = mix(color.r, color.r * (1. - color.a) * DISOLVEBURN_burn_color.r * 150.0, DISOLVEBURN_process_value);
	color.g = mix(color.g, color.g * (1. - color.a) * DISOLVEBURN_burn_color.g * 150.0, DISOLVEBURN_process_value);
	color.b = mix(color.b, color.b * (1. - color.a) * DISOLVEBURN_burn_color.b * 150.0 , DISOLVEBURN_process_value);
	color.rgb = mix(clamp(color.rbg, 0.0, 1.0), color.rgb, 1.0);
	finalColor=color;
}
