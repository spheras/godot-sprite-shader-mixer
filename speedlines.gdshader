uniform bool SPEEDLINES_active = true;
uniform sampler2D SPEEDLINES_noise: repeat_enable;
uniform vec4  SPEEDLINES_line_color: source_color = vec4(1,1,0,1);
uniform float SPEEDLINES_line_count: hint_range(0.0, 2.0, 0.05) = 1.90;
uniform float SPEEDLINES_line_density: hint_range(0.0, 1.0) = 0.9;
uniform float SPEEDLINES_line_faloff: hint_range(0.0, 1.0) = 0.25;
uniform float SPEEDLINES_mask_size: hint_range(0.0, 1.0) = 0.5;
uniform float SPEEDLINES_mask_edge: hint_range(0.0, 1.0) = 0.15;
uniform float SPEEDLINES_animation_speed: hint_range(1.0, 20.0) = 10;
uniform bool  SPEEDLINES_flash = true;
float SPEEDLINES_inv_lerp(float from, float to, float value){
  return (value - from) / (to - from);
}
vec2 SPEEDLINES_polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat)
{
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(PI * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}
vec2 SPEEDLINES_rotate_uv(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}
void speedlines(in vec2 uv, in sampler2D txt, in vec2 spriteSize, in vec2 pixelSize, inout vec4 finalColor)
{
	vec2 polar_uv = SPEEDLINES_polar_coordinates(SPEEDLINES_rotate_uv(uv, vec2(0.5), floor(fract(TIME) * SPEEDLINES_animation_speed) ) , vec2(0.5), 0.01, SPEEDLINES_line_count);
	vec3 lines = texture(SPEEDLINES_noise, polar_uv).rgb;
	
	float mask_value = length(uv - vec2(0.5));
	float mask = SPEEDLINES_inv_lerp(SPEEDLINES_mask_size, SPEEDLINES_mask_edge, mask_value);
	float result = 1.0 - (mask * SPEEDLINES_line_density);
	
	result = smoothstep(result, result + SPEEDLINES_line_faloff, lines.r);
	
	if(finalColor.a<=0.){
		finalColor = vec4(SPEEDLINES_line_color.rgb,1);
		finalColor.a = min(SPEEDLINES_line_color.a, result);
	}else{
		if(SPEEDLINES_flash){
			vec4 newColor = finalColor - vec4(0.2,.2,.2,1)*sin(TIME*44.);
			newColor.a=finalColor.a;
			finalColor=newColor;
		}
	}
}
