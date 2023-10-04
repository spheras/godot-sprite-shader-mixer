//BURN
uniform bool  BURN_active  = true;
uniform float BURN_offset: hint_range(0, 100) = 0;
uniform float BURN_speed : hint_range(0, 10) = 1;
uniform float BURN_burnValue : hint_range(0 , 1) = 1;
void burn(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 pixelSize, inout vec4 finalColor)
{
	float value = BURN_offset + TIME * BURN_speed;
	float gray = (finalColor.r + finalColor.g + finalColor.b) / 3.0;
	gray += BURN_offset + value;
	vec4 color = finalColor;
	color.r = 1.0  + 0.4 * sin(6.28318 * gray);
	color.g = 0.9 * sin(3.14159 * gray);
	color.b = 0.1;
	color.rgb = mix(finalColor.rgb, color.rgb, BURN_burnValue);
	finalColor=color;
}
