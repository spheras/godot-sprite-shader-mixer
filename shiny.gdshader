//SHINY
uniform bool  SHINY_active  = true;
uniform float SHINY_processValue: hint_range(0, 1) = 0.5;
uniform float SHINY_size : hint_range(-1, 1) = -0.1;
uniform float SHINY_smoothLight : hint_range(0, 1) = 0.25;
uniform float SHINY_intensity : hint_range(0, 5) = 0.75;
uniform float SHINY_angle: hint_range(0, 180) = 100;
float shiny_mark_light(vec2 uv, float size, float _smooth_light, float _intensity, float _shiny_angle, float _process_value)
{
	uv = uv - vec2(_process_value, 0.5);
	float r = 3.1415;
	float angle = atan(uv.x, uv.y) - _shiny_angle * 0.0174533;
	float d = cos(floor(0.5 + angle / r) * r - angle) * length(uv);
	float dist = 1.0 - smoothstep(size, size + _smooth_light, d);
	return dist * _intensity;
}
void shiny(in vec2 uv, in sampler2D txt, in vec2 spriteSize, in vec2 pixelSize, inout vec4 finalColor)
{
	float mark_light = shiny_mark_light(uv, SHINY_size, SHINY_smoothLight, SHINY_intensity, SHINY_angle, SHINY_processValue);
	finalColor = vec4(finalColor.rgb + mark_light, finalColor.a);
}
