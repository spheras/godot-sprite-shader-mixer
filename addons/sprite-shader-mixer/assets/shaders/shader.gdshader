shader_type canvas_item;

//CROSSFADE_CIRCLE
uniform bool  CROSSFADE_CIRCLE_active  = false;
uniform float CROSSFADE_CIRCLE_transparency : hint_range(0.0, 1.0) = 1.0;
uniform vec2  CROSSFADE_CIRCLE_position;
uniform vec4  CROSSFADE_CIRCLE_dissolveColor : source_color = vec4(0);
uniform float CROSSFADE_CIRCLE_circleSize;
//HOLOWAVE
uniform bool  HOLOWAVE_active  = false;
uniform float HOLOWAVE_offset: hint_range(0, 100) = 0;
uniform float HOLOWAVE_speed : hint_range(-10, 10) = 1;
uniform float HOLOWAVE_waveHeight : hint_range(0, 1) = 0.12;
uniform float HOLOWAVE_waveSpeed: hint_range(0, 20) = 3;
uniform float HOLOWAVE_waveFreq: hint_range(0, 100) = 30.0;
uniform float HOLOWAVE_waveWidth: hint_range(0, 10) = 1.0;
//HOLOGRAM
uniform bool      HOLOGRAM_active  = false;
uniform sampler2D HOLOGRAM_noiseTex;
uniform float     HOLOGRAM_value : hint_range(0, 1) = 0.75;
uniform float     HOLOGRAM_noiseX : hint_range(0, 20) = 10;
uniform float     HOLOGRAM_speed : hint_range(0, 4) = 1.0;

//MATRIX
uniform bool      MATRIX_active  = false;
uniform int       MATRIX_direction = 0;
uniform float     MATRIX_velocity : hint_range(0, 4) = 0.5;
uniform float     MATRIX_row : hint_range(1.0, 100.0) = 12.0;
uniform float     MATRIX_column : hint_range(1.0, 100.0) = 12.0;
uniform float     MATRIX_value : hint_range(1, 25) = 20;
uniform sampler2D MATRIX_chars_tex;
uniform float     MATRIX_number_row_char_texture = 3.0;
uniform float     MATRIX_number_column_char_texture = 3.0;
uniform vec4      MATRIX_tint_color : source_color = vec4(0.12, 0.62, 0.92, 1.0);
uniform float     MATRIX_line_thickness : hint_range(0, 20) = 5.0;

//CROSSFADE_CIRCLE
void crossfadeCircle(in vec2 uv, inout vec4 color){
	    vec2 center = CROSSFADE_CIRCLE_position / 2.0;
	    float distanceCurrentPixelToCenter = distance(uv, center);
	    float fadeWidth = CROSSFADE_CIRCLE_circleSize;
	    float transition = smoothstep(fadeWidth, 0.0, distanceCurrentPixelToCenter) * sin(CROSSFADE_CIRCLE_transparency);
	    color = mix(CROSSFADE_CIRCLE_dissolveColor, color, transition);	
}

//HOLO WAVE
float mark(vec2 uv, float height, float time)
{
	float value = mod(uv.y - time * 0.5, 2.0);
	return (value < height) ? 1.0 : 0.0;
}
void holowave(inout vec2 uv, sampler2D sampler, inout vec4 color)
{
	float time = HOLOWAVE_offset + TIME * HOLOWAVE_speed;
	vec2 wave_uv_offset = vec2(0, 0);
	wave_uv_offset.x = sin(time * HOLOWAVE_waveSpeed + uv.y * HOLOWAVE_waveFreq * 2.0) * uv.y * uv.y * HOLOWAVE_waveWidth * 0.1;
	float mark_value = mark(uv, HOLOWAVE_waveHeight, time);
	uv = (mark_value > 0.0) ? uv + wave_uv_offset : uv;
	color = texture(sampler, uv);
}

//HOLOGRAM
float hologram_noise(sampler2D source, vec2 p, float time)
{
	float sample = texture(source, vec2(.2, 0.2 * cos(time)) * time * 8. + p * 1.).x;
	return sample * sample;
}
float hologram_on(float x, float y, float z, float time)
{
	return step(z, sin(time + x * cos(time * y)));
}
float hologram_waveLineMark(vec2 uv, float time)
{
	float y = fract(uv.y * 5. + time * 0.5 + sin(time + sin(time * 0.6)));
	float start = .5;
	float end = .6;
	float inside = step(start, y) - step(end, y);
	return (y - start) / (end - start) * inside + 0.25;
}
float hologram_horizontalRowMark(vec2 uv, float time)
{
	return (9. + fract(uv.y * 20. + time)) * 0.1;
}
void hologram(vec2 uv, sampler2D source, inout vec4 color)
{
	vec4 txt = texture(source, uv);
	float _time = TIME * HOLOGRAM_speed;
	vec2 _uv = uv;
	
	float atm_shift_x = 1. / (1. + 30. * (_uv.y - fract(_time * 0.25)) * (_uv.y - fract(_time * 0.25)));
	float horizontal_shift = atm_shift_x * sin(_uv.y * HOLOGRAM_noiseX * 100.0 + _time) / (50. * HOLOGRAM_value) * hologram_on(4., 4., .3, TIME) * (1. + cos(_time * 70.));
	_uv.x += horizontal_shift;
	
	float vertical_shift = .1 * hologram_on(2., 3., .9, TIME) * (sin(_time) * sin(_time * 20.) + (0.5 + 0.1 * sin(_time * 20.) * cos(_time)));
	_uv.y = fract(_uv.y + vertical_shift);
	
	vec4 holo_txt = texture(source, _uv);
	holo_txt.rb = texture(source, _uv - vec2(.05, 0.) * hologram_on(2., 1.5, .9, TIME)).rb;
	
	float noise = hologram_noise(source, uv * vec2(0.5, 1.) + vec2(6., 3.), TIME) * HOLOGRAM_value * 3.;
	holo_txt += hologram_waveLineMark(_uv, _time) * noise * holo_txt.a;
	holo_txt *= hologram_horizontalRowMark(_uv, _time);
	
	float noise2 = texture(HOLOGRAM_noiseTex, _uv).r;
	holo_txt.a = (holo_txt.a + noise2 * 0.5) * txt.a * 0.8;
	
	color= mix(txt, holo_txt, HOLOGRAM_value);
}


//MATRIX
vec3 randomColor (int indexColumn) 
{
	float f = float(indexColumn);
	float red = rand1(vec2(f, 1.0), f) * 0.8;
	float blue = rand1(vec2(f, 1.0), f + 1.0) * 0.5;
	float green = rand1(vec2(f, 1.0), f + 2.0);
	return vec3(red, blue, green);
}
float rand2_with_range(vec2 co, float m, float M, float random_seed)
{
	float r1 = rand1(co, random_seed);
	return (M - m) * r1 + r1;
}
vec3 matrix_rain(vec2 uv, float _matrix_value, float number_row, float number_column, int di, float time)
{
	float column_size = 1.0 / number_column;
	float row_size = 1.0 / number_row;
	
	float x = uv.x - mod(uv.x, column_size);
	float offset = sin(x * 15.0);
	float speed = cos(x * 3.0) * 0.3 + 0.7;
	
	float y =  uv.y - mod(uv.y, row_size);
	y = (di > 0) ? fract(y + time * speed + offset) : fract(1.0 - y + time * speed + offset);
	float alpha = 1.0 / ((26.0 - _matrix_value) * y);
	
	vec3 color = MATRIX_tint_color.rgb;
	color *= alpha;
	return color;
}
vec2 matrix_randomIndexChar(vec2 char_size, vec2 blockID, float time)
{
	vec2 indexChar = vec2(0, 0);
	float t = time - mod(time, 0.1);
	float r1 = rand2_with_range(blockID / char_size + t, 1, char_size.x, 1);
	indexChar.x = blockID.x + char_size.x * r1;
	indexChar.y = blockID.y + char_size.y * r1;
	
	indexChar = mod(floor(indexChar), char_size);
	return indexChar;
}
float text(vec2 uv, float number_row, float number_column, float time)
{
	float column_size = 1.0 / number_column;
	float row_size = 1.0 / number_row;
	vec2 block_size = vec2(column_size, row_size);

	vec2 blockID = floor(uv / block_size);
	vec2 _uv = mod(uv.xy, block_size) / block_size;

	vec2 char_texture_size = vec2(MATRIX_number_row_char_texture, MATRIX_number_column_char_texture);
	vec2 index_char = matrix_randomIndexChar(char_texture_size, blockID, time);
	_uv.y = 1.0 - _uv.y;
	_uv = (index_char + _uv) / char_texture_size;

	return texture(MATRIX_chars_tex, _uv).r;
}
void matrix(in vec2 uv, in vec2 pixelSize, sampler2D sampler, inout vec4 color, float time){
	vec3 rain = matrix_rain(uv, MATRIX_value, floor(MATRIX_row), floor(MATRIX_column), MATRIX_direction, time*MATRIX_velocity);
	float text = text(uv, floor(MATRIX_row), floor(MATRIX_column), time*MATRIX_velocity);
	vec3 matrix = text * rain;
	vec4 txt = texture(sampler, uv);
	
	vec2 size = pixelSize * MATRIX_line_thickness;
	float _outline = texture(sampler, uv + vec2(0, -size.y)).a;
	_outline += texture(sampler, uv + vec2(0, -size.y * 2.0)).a;
	_outline += texture(sampler, uv + vec2(0, -size.y * 3.0)).a;
	_outline += texture(sampler, uv + vec2(0, -size.y * 4.0)).a;
	_outline += texture(sampler, uv + vec2(0, -size.y * 5.0)).a;
	_outline += texture(sampler, uv + vec2(size.x, 0)).a;
	_outline += texture(sampler, uv + vec2(-size.x, 0)).a;
	_outline= min(1.0, _outline) - txt.a;
	
	float v = matrix.r + matrix.g + matrix.b;
	if (v > 1.0)
	{
		float have_char = min(1.0, v);
		vec4 outline_matrix = vec4(matrix, 1.0 * text);
		txt = mix(txt, outline_matrix, _outline);
		txt.rgb = mix(txt.rgb, matrix, have_char);
	}
	
	vec4 output_color = txt;
	color = output_color;
}



void fragment() {
    vec4 color = texture(TEXTURE, UV);
	vec2 size = vec2(textureSize(TEXTURE, 0));
	vec2 uv = UV;

	//holowave must be first
	if(HOLOWAVE_active) holowave(uv, TEXTURE, color);
	if(HOLOGRAM_active) hologram(uv, TEXTURE, color);
	
	if(CROSSFADE_CIRCLE_active) crossfadeCircle(uv, color);
	if(BURN_active) burn(uv, TEXTURE, color);
	if(GOLD_active) gold(uv, TEXTURE, color);
	if(METAL_active) metal(uv, TEXTURE, color);
	if(FREEZE_active) freeze(uv, TEXTURE, color);
	if(SHINY_active) shiny(uv, TEXTURE, color);

	if(MATRIX_active) matrix(uv,size,TEXTURE,color,TIME);
	
	if(DISOLVEBURN_active) disolveBurn(uv, color);
	
	//shadow must be last
	if(SHADOW_active) shadow(uv, TEXTURE, TEXTURE_PIXEL_SIZE, color);
	
	COLOR=color;
}




void vertex() {

}