//HOLOGRAPHIC
uniform bool      HOLOGRAPHIC_active  = true;
uniform sampler2D HOLOGRAPHIC_noiseTex;
uniform float     HOLOGRAPHIC_value : hint_range(0, 1) = 0.75;
uniform float     HOLOGRAPHIC_noiseX : hint_range(0, 20) = 10;
uniform float     HOLOGRAPHIC_speed : hint_range(0, 4) = 1.0;
uniform float     HOLOGRAPHIC_mix : hint_range(0,1) = 0;
float holographic_noise(sampler2D source, vec2 p, float time)
{
	float sample = texture(source, vec2(.2, 0.2 * cos(time)) * time * 8. + p * 1.).x;
	return sample * sample;
}
float holographic_on(float x, float y, float z, float time)
{
	return step(z, sin(time + x * cos(time * y)));
}
float holographic_waveLineMark(vec2 uv, float time)
{
	float y = fract(uv.y * 5. + time * 0.5 + sin(time + sin(time * 0.6)));
	float start = .5;
	float end = .6;
	float inside = step(start, y) - step(end, y);
	return (y - start) / (end - start) * inside + 0.25;
}
float holographic_horizontalRowMark(vec2 uv, float time)
{
	return (9. + fract(uv.y * 20. + time)) * 0.1;
}
void holographic(in vec2 uv, in sampler2D source, vec2 size, vec2 pixelSize, inout vec4 color)
{
	vec4 txt = texture(source, uv);
	float _time = TIME * HOLOGRAPHIC_speed;
	vec2 _uv = uv;
	
	float atm_shift_x = 1. / (1. + 30. * (_uv.y - fract(_time * 0.25)) * (_uv.y - fract(_time * 0.25)));
	float horizontal_shift = atm_shift_x * sin(_uv.y * HOLOGRAPHIC_noiseX * 100.0 + _time) / (50. * HOLOGRAPHIC_value) * holographic_on(4., 4., .3, TIME) * (1. + cos(_time * 70.));
	_uv.x += horizontal_shift;
	
	float vertical_shift = .1 * holographic_on(2., 3., .9, TIME) * (sin(_time) * sin(_time * 20.) + (0.5 + 0.1 * sin(_time * 20.) * cos(_time)));
	_uv.y = fract(_uv.y + vertical_shift);
	
	vec4 holo_txt = texture(source, _uv);
	holo_txt.rb = texture(source, _uv - vec2(.05, 0.) * holographic_on(2., 1.5, .9, TIME)).rb;
	
	float noise = holographic_noise(source, uv * vec2(0.5, 1.) + vec2(6., 3.), TIME) * HOLOGRAPHIC_value * 3.;
	holo_txt += holographic_waveLineMark(_uv, _time) * noise * holo_txt.a;
	holo_txt *= holographic_horizontalRowMark(_uv, _time);
	
	float noise2 = texture(HOLOGRAPHIC_noiseTex, _uv).r;
	holo_txt.a = (holo_txt.a + noise2 * 0.5) * txt.a * 0.8;

	vec4 newColor= mix(txt, holo_txt, HOLOGRAPHIC_value);
	color=mix(newColor, color, HOLOGRAPHIC_mix);
}
