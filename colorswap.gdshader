uniform bool  COLORSWAP_active = true;
uniform float COLORSWAP_mix:hint_range(0,1,0.1) = 0;
uniform int   COLORSWAP_max_colors:hint_range(1, 8, 1) = 8;
uniform bool  COLORSWAP_show_stripes = true;
uniform float COLORSWAP_tolerance: hint_range(0.0, 1, 0.1);
uniform vec4  COLORSWAP_input_color1 : source_color;
uniform vec4  COLORSWAP_output_color1 : source_color;
uniform vec4  COLORSWAP_input_color2 : source_color;
uniform vec4  COLORSWAP_output_color2 : source_color;
uniform vec4  COLORSWAP_input_color3 : source_color;
uniform vec4  COLORSWAP_output_color3 : source_color;
uniform vec4  COLORSWAP_input_color4 : source_color;
uniform vec4  COLORSWAP_output_color4 : source_color;
uniform vec4  COLORSWAP_input_color5 : source_color;
uniform vec4  COLORSWAP_output_color5 : source_color;
uniform vec4  COLORSWAP_input_color6 : source_color;
uniform vec4  COLORSWAP_output_color6 : source_color;
uniform vec4  COLORSWAP_input_color7 : source_color;
uniform vec4  COLORSWAP_output_color7 : source_color;
uniform vec4  COLORSWAP_input_color8 : source_color;
uniform vec4  COLORSWAP_output_color8 : source_color;
vec4 COLORSWAP_grayscale(vec4 color){
	float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
	return vec4(gray, gray, gray, color.a);
}
vec4 COLORSWAP_stripe(vec2 uv, vec4 color){
	float w = cos(0.7854) * uv.x + sin(0.7854) * uv.y - 0.05 * TIME;
	if (floor(mod(w * 48.0, 2.0)) < 0.0001) {
		return color;
	}
	else {
		return COLORSWAP_grayscale(color);
	}
}
bool COLORSWAP_isColorSimilar(vec4 color1, vec4 color2){
		return (
			color1.r > (color2.r - COLORSWAP_tolerance) && 
		    color1.r < (color2.r + COLORSWAP_tolerance) && 
			color1.g > (color2.g - COLORSWAP_tolerance) && 
		    color1.g < (color2.g + COLORSWAP_tolerance) &&
			color1.b > (color2.b - COLORSWAP_tolerance) && 
		    color1.b < (color2.b + COLORSWAP_tolerance)
			);
}
void colorswap(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 pixelSize, inout vec4 finalColor){
	vec4[] input_colors = {
		COLORSWAP_input_color1,
		COLORSWAP_input_color2,
		COLORSWAP_input_color3,
		COLORSWAP_input_color4,
		COLORSWAP_input_color5,
		COLORSWAP_input_color6,
		COLORSWAP_input_color7,
		COLORSWAP_input_color8
	};
	
	vec4[] output_colors = {
		COLORSWAP_output_color1,
		COLORSWAP_output_color2,
		COLORSWAP_output_color3,
		COLORSWAP_output_color4,
		COLORSWAP_output_color5,
		COLORSWAP_output_color6,
		COLORSWAP_output_color7,
		COLORSWAP_output_color8
	};
		
	bool is_color = false;
	
	for(int cr = 0; cr < COLORSWAP_max_colors; cr++){
		if (finalColor.a>0. && COLORSWAP_isColorSimilar(finalColor, input_colors[cr])){
			finalColor = mix(output_colors[cr], finalColor, COLORSWAP_mix);
			is_color = true;
			break;
		}
	}

	if (!is_color){
		if (COLORSWAP_show_stripes && !(finalColor.a < 0.001)){
			finalColor = mix(COLORSWAP_stripe(uv, finalColor), finalColor, COLORSWAP_mix);
		}
	}
}
