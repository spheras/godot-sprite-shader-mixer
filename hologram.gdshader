uniform bool  HOLOGRAM_active = true;
uniform float HOLOGRAM_mix : hint_range(0, 1, .1) = 0;
uniform int   HOLOGRAM_lines = 100;
uniform vec4  HOLOGRAM_color1 : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4  HOLOGRAM_color2 : source_color = vec4(1.0, 0.0, 0.0, 1.0);  
uniform float HOLOGRAM_speed : hint_range(0.0, 2.0, 0.01) = 0.4;
uniform float HOLOGRAM_alpha : hint_range(0.0, 1.0, 0.01) = 0.5; 
uniform float HOLOGRAM_noise_amount : hint_range(0.0, 1.0, 0.01) = 0.05;
uniform float HOLOGRAM_effect_factor : hint_range(0.0, 1.0, 0.01) = 0.4;
void HOLOGRAM_noise(in vec2 uv, inout vec4 color) {
	float a = fract(sin(dot(uv, vec2(12.9898, 78.233) * TIME)) * 438.5453) * 1.9;
	color.rgb = mix(color.rgb, vec3(a), HOLOGRAM_noise_amount);
}
vec4 HOLOGRAM_color_shift(in vec2 uv, in sampler2D image, vec2 shift_vector) {
	return texture(image, uv - shift_vector);
}
void hologram(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 pixelSize, inout vec4 finalColor){
	float lineN = floor((uv.y - TIME*HOLOGRAM_speed) * float(HOLOGRAM_lines));
	float line_grade = abs(sin(lineN*PI/4.0));
	float smooth_line_grade = abs(sin((uv.y - TIME*HOLOGRAM_speed) * float(HOLOGRAM_lines)));
	
	vec4 line_color = mix(HOLOGRAM_color1, HOLOGRAM_color2, line_grade);
	
	// change the "240.0" literal to control line color shifting
	finalColor = mix(HOLOGRAM_color_shift(uv, txt, vec2(1.0, 0.0)*smooth_line_grade/240.0*HOLOGRAM_effect_factor), finalColor, HOLOGRAM_mix);
	
	HOLOGRAM_noise(uv, finalColor);
	
	finalColor.rgb = mix(finalColor.rgb, line_color.rgb, HOLOGRAM_effect_factor);
	finalColor.a = HOLOGRAM_alpha * finalColor.a * line_color.a;
}
