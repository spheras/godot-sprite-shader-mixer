//HOLOWAVE
uniform bool  HOLOWAVE_active  = true;
uniform float HOLOWAVE_offset: hint_range(0, 100) = 0;
uniform float HOLOWAVE_speed : hint_range(-10, 10) = 1;
uniform float HOLOWAVE_waveHeight : hint_range(0, 1) = 0.12;
uniform float HOLOWAVE_waveSpeed: hint_range(0, 20) = 3;
uniform float HOLOWAVE_waveFreq: hint_range(0, 100) = 30.0;
uniform float HOLOWAVE_waveWidth: hint_range(0, 10) = 1.0;
uniform float HOLOWAVE_mix: hint_range(0,1) = 0;
float mark(vec2 uv, float height, float time)
{
	float value = mod(uv.y - time * 0.5, 2.0);
	return (value < height) ? 1.0 : 0.0;
}
void holowave(in vec2 uv, in sampler2D sampler, vec2 size, vec2 pixelSize, inout vec4 color)
{
	float time = HOLOWAVE_offset + TIME * HOLOWAVE_speed;
	vec2 wave_uv_offset = vec2(0, 0);
	wave_uv_offset.x = sin(time * HOLOWAVE_waveSpeed + uv.y * HOLOWAVE_waveFreq * 2.0) * uv.y * uv.y * HOLOWAVE_waveWidth * 0.1;
	float mark_value = mark(uv, HOLOWAVE_waveHeight, time);
	uv = (mark_value > 0.0) ? uv + wave_uv_offset : uv;
	color = mix(texture(sampler, uv), color, HOLOWAVE_mix);
}