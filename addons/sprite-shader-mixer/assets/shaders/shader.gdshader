shader_type canvas_item;

//RAINBOW
uniform bool  RAINBOW_active  = false;
uniform float RAINBOW_speed : hint_range(0, 5) = 1;
uniform float RAINBOW_redFactor : hint_range(0, 5) = 3;
uniform float RAINBOW_greenFactor : hint_range(0, 5) = 2;
uniform float RAINBOW_blueFactor : hint_range(0, 5) = 5;
//GLITCH
uniform bool  GLITCH_active  = false;
uniform float GLITCH_offset: hint_range(0, 100) = 0;
uniform float GLITCH_speed : hint_range(0, 10) = 1;
uniform float GLITCH_size : hint_range(0.0, 10.0) = 0.75;
uniform float GLITCH_amount : hint_range(0.0, 24.0) = 10.0;
//GREYSCALE
uniform bool  GREYSCALE_active  = false;
uniform vec3  GREYSCALE_TintColor : source_color = vec3(1.0);
uniform float GREYSCALE_Luminosity : hint_range(-1.0, 1.0) = 0.0;
uniform float GREYSCALE_Blend : hint_range(0.0, 1.0) = 1.0;
//CROSSFADE_CIRCLE
uniform bool  CROSSFADE_CIRCLE_active  = false;
uniform float CROSSFADE_CIRCLE_transparency : hint_range(0.0, 1.0) = 1.0;
uniform vec2  CROSSFADE_CIRCLE_position;
uniform vec4  CROSSFADE_CIRCLE_dissolveColor : source_color = vec4(0);
uniform float CROSSFADE_CIRCLE_circleSize;
//BLUR
uniform bool  BLUR_active  = false;
uniform float BLUR_radius : hint_range(1, 10.0) = 2.0;
//OUTLINE
uniform bool  OUTLINE_active  = false;
uniform float OUTLINE_thickness : hint_range(0, 30) = 3.0;
uniform vec4  OUTLINE_color : source_color;
//EMPTY OUTLINE
uniform bool  EMPTYOUTLINE_active  = false;
uniform vec4  EMPTYOUTLINE_lineColor : source_color = vec4(1);
uniform float EMPTYOUTLINE_lineThickness : hint_range(0, 30) = 3.0;
//SHADOW
uniform bool  SHADOW_active  = false;
uniform vec2  SHADOW_deform = vec2(2.0, 2.0);
uniform vec2  SHADOW_offset = vec2(0.0, 0.0);
uniform vec4  SHADOW_modulate : source_color;
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
//SHINY
uniform bool  SHINY_active  = false;
uniform float SHINY_processValue: hint_range(0, 1) = 0.0;
uniform float SHINY_size : hint_range(-1, 1) = -0.1;
uniform float SHINY_smoothLight : hint_range(0, 1) = 0.25;
uniform float SHINY_intensity : hint_range(0, 5) = 0.75;
uniform float SHINY_angle: hint_range(0, 180) = 100;
//BURN
uniform bool  BURN_active  = false;
uniform float BURN_offset: hint_range(0, 100) = 0;
uniform float BURN_speed : hint_range(0, 10) = 1;
uniform float BURN_burnValue : hint_range(0 , 1) = 1;
//METAL
uniform bool  METAL_active  = false;
uniform float METAL_offset: hint_range(0, 100) = 0;
uniform float METAL_speed : hint_range(0, 10) = 1;
//FREEZE
uniform bool  FREEZE_active  = false;
uniform float FREEZE_offset: hint_range(0, 100) = 0;
uniform float FREEZE_speed : hint_range(0, 10) = 1;
//GOLD
uniform bool  GOLD_active  = false;
uniform float GOLD_offset: hint_range(0, 100) = 0;
uniform float GOLD_speed : hint_range(0, 10) = 1;
//DISOLVE BURN
uniform bool      DISOLVEBURN_active  = false;
uniform sampler2D DISOLVEBURN_noise_tex;
uniform vec4      DISOLVEBURN_burn_color : source_color = vec4(1.0, 0.3, 0.05, 1.0);
uniform float     DISOLVEBURN_process_value : hint_range(0, 1) = 0;
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


//RAINBOW
void rainbow(vec2 uv, inout vec4 color) {
	color=vec4(color.r+sin(TIME*RAINBOW_redFactor*RAINBOW_speed), color.g+sin(TIME*RAINBOW_greenFactor*RAINBOW_speed), color.b+sin(TIME*RAINBOW_blueFactor*RAINBOW_speed), color.a);
}

//CROSSFADE_CIRCLE
void crossfadeCircle(in vec2 uv, inout vec4 color){
	    vec2 center = CROSSFADE_CIRCLE_position / 2.0;
	    float distanceCurrentPixelToCenter = distance(uv, center);
	    float fadeWidth = CROSSFADE_CIRCLE_circleSize;
	    float transition = smoothstep(fadeWidth, 0.0, distanceCurrentPixelToCenter) * sin(CROSSFADE_CIRCLE_transparency);
	    color = mix(CROSSFADE_CIRCLE_dissolveColor, color, transition);	
}

//GRAYSCALE
void grayscale(inout vec4 color){
	    // Calcula la luminosidad en blanco y negro
	    float luminance = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
	    // Aplica el ajuste de luminosidad
	    luminance = clamp(luminance + GREYSCALE_Luminosity, 0.0, 1.0);
	    // Interpola entre el color original y el color en escala de grises
	    color.rgb = mix(color.rgb, vec3(luminance), GREYSCALE_Blend) * GREYSCALE_TintColor;
}

//OUTLINE
void outline(in vec2 spriteSize, in vec2 uv, in sampler2D tex, inout vec4 color){
    vec2 size = vec2(OUTLINE_thickness) / spriteSize;
	   
    float alpha = color.a;
    alpha += texture(tex, uv + vec2(0.0, -size.y)).a;
    alpha += texture(tex, uv + vec2(size.x, -size.y)).a;
    alpha += texture(tex, uv + vec2(size.x, 0.0)).a;
    alpha += texture(tex, uv + vec2(size.x, size.y)).a;
    alpha += texture(tex, uv + vec2(0.0, size.y)).a;
    alpha += texture(tex, uv + vec2(-size.x, size.y)).a;
    alpha += texture(tex, uv + vec2(-size.x, 0.0)).a;
    alpha += texture(tex, uv + vec2(-size.x, -size.y)).a;
   
    vec3 final_color = mix(OUTLINE_color.rgb, color.rgb, color.a);
    color = vec4(final_color, clamp(alpha, 0.0, 1.0));
}

//EMTPY OUTLINE
void emptyOutline(vec2 uv, sampler2D txt, vec2 texturePixelSize, inout vec4 color) {
	vec2 size = texturePixelSize * EMPTYOUTLINE_lineThickness;
	vec4 outline = texture(txt, uv + vec2(-size.x, 0));
	outline += texture(txt, uv + vec2(0, size.y));
	outline += texture(txt, uv + vec2(size.x, 0));
	outline += texture(txt, uv + vec2(0, -size.y));
	outline += texture(txt, uv + vec2(-size.x, size.y));
	outline += texture(txt, uv + vec2(size.x, size.y));
	outline += texture(txt, uv + vec2(-size.x, -size.y));

	outline += texture(txt, uv + vec2(size.x, -size.y));
	outline.rgb = EMPTYOUTLINE_lineColor.rbg;
	if (outline.a > 0.5) { outline = EMPTYOUTLINE_lineColor; }
	if (texture(txt, uv).a > 0.5) { outline.a = 0.0; }
	color = outline;
}

//BLUR 
void blur(in vec2 uv, in sampler2D tex, in vec2 size, inout vec4 color) {
	vec4 final_color = vec4(0.0);
    float total_weight = 0.0;

    for (float x = -BLUR_radius; x <= BLUR_radius; x += 1.0) {
        for (float y = -BLUR_radius; y <= BLUR_radius; y += 1.0) {
            vec2 offset = vec2(x, y);
            vec4 sample = texture(tex, uv + offset / size);

            float distance = length(offset);
            float weight = smoothstep(BLUR_radius, BLUR_radius - 1.0, distance);

            final_color += sample * weight;
            total_weight += weight;
        }
    }
    color= final_color / total_weight;
}


//GLITCH 
float rand1(vec2 co, float random_seed)
{
    return fract(sin(dot(co.xy * random_seed, vec2(12.,85.5))) * 120.01);
}
float rand2(vec2 co, float random_seed)
{
    float r1 = fract(sin(dot(co.xy * random_seed ,vec2(12.9898, 78.233))) * 43758.5453);
    return fract(sin(dot(vec2(r1 + co.xy * 1.562) ,vec2(12.9898, 78.233))) * 43758.5453);
}
void glitch(in vec2 uv, in sampler2D tex, inout vec4 color) {
	float seed = floor(TIME * GLITCH_speed) / 20.0;
	vec2 blockS = floor(uv * vec2 (GLITCH_offset, 50.) * GLITCH_size) * 2.0;
	vec2  blockL = floor(uv * vec2 (GLITCH_offset, 50.) * GLITCH_size) * 1.3;

	float line_noise = pow(rand2(blockS, seed), 5.0) * GLITCH_amount * pow(rand2(blockL, seed), 3.0);
	
	float negative=-1.;
	float random = rand1(vec2(0.1), seed);
	if(  random < 0.5 ){
		negative=1.;
	}	
	color = texture(tex, uv + vec2 (line_noise * 0.02 * negative * rand1(vec2(2.0), seed), 0));
}


//SHADOW
void shadow(vec2 uv, sampler2D txt, vec2 texturePixelSize, inout vec4 color) {
	float sizex = float(textureSize(txt,int(texturePixelSize.x)).x); //comment for GLES2
	float sizey = float(textureSize(txt,int(texturePixelSize.y)).y); //comment for GLES2
	//float sizex = texture_size.x; //uncomment for GLES2
	//float sizey = texture_size.y; //uncomment for GLES2
	uv.y+=SHADOW_offset.y*texturePixelSize.y;
	uv.x+=SHADOW_offset.x*texturePixelSize.x;
	float decalx=((uv.y-texturePixelSize.x*sizex)*SHADOW_deform.x);
	float decaly=((uv.y-texturePixelSize.y*sizey)*SHADOW_deform.y);
	uv.x += decalx;
	uv.y += decaly;
	vec4 shadow = vec4(SHADOW_modulate.rgb, texture(txt, uv).a * SHADOW_modulate.a * 0.5);
	color = mix(shadow, color, color.a);
}

//GOLD
float calc_luminance(vec3 color)
{
    return dot(color, vec3( 0.299, 0.587, 0.114));
}
float mark_light(vec2 uv, float value)
{
	vec2 co = uv * 5.0;
	float n = sin(value + co.x) + sin(value - co.x) + sin(value + co.y) + sin(value + 2.5 * co.y);
	return fract((5.0 + n) / 5.0);
}
void gold(vec2 uv, sampler2D txt, inout vec4 finalColor)
{
	float value = GOLD_offset + TIME * GOLD_speed;
	vec4 txt_color = texture(txt, uv);
	float luminance = calc_luminance(txt_color.rbg);
	vec3 metal = vec3(luminance);
	metal.r = luminance * pow(1.5 * luminance, 3.0);
	metal.g = luminance * pow(1.5 * luminance, 3.0);
	metal.b = luminance * pow(0.75 * luminance, 3.0);
	
	float n = mark_light(uv, value);
	n += dot(txt_color.rbg, vec3(0.2, 0.4, 0.2));
	n = fract(n);
	
	float a = clamp(abs(n * 6.0 - 2.0), 0.0, 1.0);
	vec4 color = vec4(metal.rgb + (1.0 - a), 1.0);
	color.rgb = color.rgb * 0.5 + dot(color.rgb, vec3 (0.113, 0.455, 0.172)) - vec3(0.0, 0.1, 0.6) + 0.025;
	color.a = txt_color.a;
	finalColor = color; 
}

// METAL
void metal(vec2 uv, sampler2D txt, inout vec4 finalColor)
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

//FREEZE
void freeze(vec2 uv, sampler2D txt, inout vec4 finalColor)
{
	float value = FREEZE_offset + TIME * FREEZE_speed;
	float luminance = calc_luminance(finalColor.rbg);
	vec3 metal = vec3(1.5 * luminance * luminance);
	
	float n = mark_light(uv, value);
	n += dot(finalColor.rbg, vec3(0.2, 0.4, 0.2));
	n = fract(n);
	
	float a = clamp(abs(n * 6.0 - 2.0), 0.0, 1.0);
	vec4 color = vec4(metal.rgb + (1.0 - a), 1.0);
	color.rgb = color.rgb * 0.5 + dot(color.rgb, vec3 (0.2, 0.5, 0.1)) - vec3(1.25, 0.5, 0.0);
	color.a = finalColor.a;
	finalColor=color;
}

//BURN
void burn(vec2 uv, sampler2D txt, inout vec4 finalColor)
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

//SHINY
float shiny_mark_light(vec2 uv, float size, float _smooth_light, float _intensity, float _shiny_angle, float _process_value)
{
	uv = uv - vec2(_process_value, 0.5);
	float r = 3.1415;
	float angle = atan(uv.x, uv.y) - _shiny_angle * 0.0174533;
	float d = cos(floor(0.5 + angle / r) * r - angle) * length(uv);
	float dist = 1.0 - smoothstep(size, size + _smooth_light, d);
	return dist * _intensity;
}
void shiny(vec2 uv, sampler2D txt, inout vec4 finalColor)
{
	float mark_light = shiny_mark_light(uv, SHINY_size, SHINY_smoothLight, SHINY_intensity, SHINY_angle, SHINY_processValue);
	finalColor = vec4(finalColor.rgb + mark_light, finalColor.a);
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
void disolveBurn(vec2 uv, inout vec4 finalColor)
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
	
	if(GLITCH_active) glitch(uv, TEXTURE, color);
	if(RAINBOW_active) rainbow(uv, color);	
	if(BLUR_active) blur(uv, TEXTURE, size, color);
	if(CROSSFADE_CIRCLE_active) crossfadeCircle(uv, color);
	if(GREYSCALE_active) grayscale(color);
	if(OUTLINE_active) outline(size, uv, TEXTURE, color);
	if(EMPTYOUTLINE_active) emptyOutline(uv, TEXTURE, TEXTURE_PIXEL_SIZE, color);
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