shader_type canvas_item;

//TEST
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
uniform bool  GOLD_active  = false;
uniform float GOLD_offset: hint_range(0, 100) = 0;
uniform float GOLD_speed : hint_range(0, 10) = 1;

// Approximates luminance from an RGB value
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
uniform bool  METAL_active  = false;
uniform float METAL_offset: hint_range(0, 100) = 0;
uniform float METAL_speed : hint_range(0, 10) = 1;
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
uniform bool  FREEZE_active  = false;
uniform float FREEZE_offset: hint_range(0, 100) = 0;
uniform float FREEZE_speed : hint_range(0, 10) = 1;

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
uniform bool  BURN_active  = false;
uniform float BURN_offset: hint_range(0, 100) = 0;
uniform float BURN_speed : hint_range(0, 10) = 1;
uniform float BURN_burnValue : hint_range(0 , 1) = 1;

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
uniform bool  SHINY_active  = false;
uniform float SHINY_processValue: hint_range(0, 1) = 0.0;
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
void shiny(vec2 uv, sampler2D txt, inout vec4 finalColor)
{
	vec4 main_tex=texture(txt, uv);
	float mark_light = shiny_mark_light(uv, SHINY_size, SHINY_smoothLight, SHINY_intensity, SHINY_angle, SHINY_processValue);
	finalColor = vec4(finalColor.rgb + mark_light, finalColor.a);
}


void fragment() {
    vec4 color = texture(TEXTURE, UV);
	vec2 size = vec2(textureSize(TEXTURE, 0));
	vec2 uv = UV;

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
	//shadow must be last
	if(SHADOW_active) shadow(uv, TEXTURE, TEXTURE_PIXEL_SIZE, color);
	
	COLOR=color;
}

void vertex() {

}