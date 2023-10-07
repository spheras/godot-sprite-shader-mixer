uniform bool LINEART_active = true;
uniform float LINEART_threshold : hint_range(0.0, 10.0, 0.01) = 0.01;
uniform vec4 LINEART_color : source_color;
uniform float LINEART_mix : hint_range(0.0, 1.0, 0.1) = 0;
void lineart(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 pixelSize, inout vec4 color){
	if(color.a>0.){
		vec3 current_color = color.rgb;
		vec3 right_color = texture(txt, uv + vec2(pixelSize.x, 0)).rgb;
		vec3 bottom_color = texture(txt, uv - vec2(0, pixelSize.y)).rgb;
		float r_distance = length(current_color - right_color);
		float b_distance = length(current_color - bottom_color);
		 
		vec4 finalColor = (r_distance > LINEART_threshold || b_distance > LINEART_threshold) ? LINEART_color : vec4(0);
		if(finalColor.a>0.){
			color=mix(finalColor, color, LINEART_mix);
		}else{
			color=finalColor;
		}
	}
}