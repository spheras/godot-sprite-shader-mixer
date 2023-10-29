//CHROMATICABERRATION
uniform bool CHROMATICABERRATION_active = true;
uniform float CHROMATICABERRATION_red_displacement : hint_range(-0.01, 0.01)=0.01;
uniform bool CHROMATICABERRATION_red_vertical=false;
uniform float CHROMATICABERRATION_green_displacement : hint_range(-0.01, 0.01)=0;
uniform bool CHROMATICABERRATION_green_vertical=false;
uniform float CHROMATICABERRATION_blue_displacement : hint_range(-0.01, 0.01)=-0.01;
uniform bool CHROMATICABERRATION_blue_vertical=false;
uniform float CHROMATICABERRATION_scale: hint_range(-100.0, 100.0, 0.1)=3.5;
void chromaticAberration(in vec2 uv, in sampler2D txt, vec2 size, vec2 pixelSize, inout vec4 color){
    // Displacement of red channel
	vec2 redDisplacementVector;
	if(CHROMATICABERRATION_red_vertical){
		redDisplacementVector=vec2(0.0, CHROMATICABERRATION_red_displacement*CHROMATICABERRATION_scale);
	}else{
		redDisplacementVector=vec2(CHROMATICABERRATION_red_displacement*CHROMATICABERRATION_scale, 0.0);
	}
    vec2 red_uv = uv + redDisplacementVector;
    vec4 red_color = texture(txt, red_uv);
    // Displacement of green channel
	vec2 greenDisplacementVector;
	if(CHROMATICABERRATION_green_vertical){
		greenDisplacementVector=vec2(0.0, CHROMATICABERRATION_green_displacement*CHROMATICABERRATION_scale);
	}else{
		greenDisplacementVector=vec2(CHROMATICABERRATION_green_displacement*CHROMATICABERRATION_scale, 0.0);
	}
    vec2 green_uv = uv + greenDisplacementVector;
    vec4 green_color = texture(txt, green_uv);
    // Displacement of blue channel
	vec2 blueDisplacementVector;
	if(CHROMATICABERRATION_blue_vertical){
		blueDisplacementVector=vec2(0.0, CHROMATICABERRATION_blue_displacement*CHROMATICABERRATION_scale);
	}else{
		blueDisplacementVector=vec2(CHROMATICABERRATION_blue_displacement*CHROMATICABERRATION_scale, 0.0);
	}
    vec2 blue_uv = uv + blueDisplacementVector;
    vec4 blue_color = texture(txt, blue_uv);

    // Combinar los canales desplazados
    color = vec4(red_color.r, green_color.g, blue_color.b, clamp(red_color.a+green_color.a+blue_color.a,0.,1.));
}