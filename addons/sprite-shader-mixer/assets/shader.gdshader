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
	float value = GLITCH_offset + TIME * GLITCH_speed;
	float seed = floor(value * GLITCH_speed * 10.0) / 10.0;
	vec2 blockS = floor(uv * vec2 (24., 19.) * GLITCH_size) * 4.0;
	vec2  blockL = floor(uv * vec2 (38., 14.) * GLITCH_size) * 4.0;

	float line_noise = pow(rand2(blockS, seed), 3.0) * GLITCH_amount * pow(rand2(blockL, seed), 3.0);
	color = texture(tex, uv + vec2 (line_noise * 0.02 * rand1(vec2(2.0), seed), 0));
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
	
	COLOR=color;
}

void vertex() {

}