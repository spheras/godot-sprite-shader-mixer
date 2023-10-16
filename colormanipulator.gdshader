//COLORMANIPULATOR
uniform bool COLORMANIPULATOR_active = true;
uniform float COLORMANIPULATOR_brightness : hint_range(-1, 1) = -1.0;
uniform float COLORMANIPULATOR_contrast : hint_range(0, 3) = 3.0;
uniform float COLORMANIPULATOR_saturation : hint_range(0, 3) = 3.0;
uniform float COLORMANIPULATOR_redVal : hint_range(0, 1) = 1.0;
uniform float COLORMANIPULATOR_greenVal : hint_range(0, 1) = 0.5;
uniform float COLORMANIPULATOR_blueVal : hint_range(0, 1) = 1.0;
uniform vec4 COLORMANIPULATOR_tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float COLORMANIPULATOR_tint_effect_factor : hint_range(0, 1) = 0.0;
//---------------------------------------------
//CONTRAST
//---------------------------------------------
mat4 COLORMANIPULATOR_contrastMatrix( float _contrast ){
	float t = ( 1.0 - _contrast ) / 2.0;
    return mat4( 
		vec4(_contrast, 0, 0, 0),
		vec4(0, _contrast, 0, 0),
		vec4(0, 0, _contrast, 0),
		vec4(t, t, t, 1));
}
//---------------------------------------------
//BRIGHTNESS
//---------------------------------------------
mat4 COLORMANIPULATOR_brightnessMatrix( float _brightness ){
    return mat4( vec4(1, 0, 0, 0),
                 vec4(0, 1, 0, 0),
                 vec4(0, 0, 1, 0),
                 vec4(_brightness, _brightness, _brightness, 1));
}
//---------------------------------------------
//SATURATION
//---------------------------------------------
mat4 COLORMANIPULATOR_saturationMatrix( float _saturation ){
    vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
    float oneMinusSat = 1.0 - _saturation;
	
    vec3 red = vec3( luminance.x * oneMinusSat );
    red+= vec3(_saturation, 0, 0)*COLORMANIPULATOR_redVal;
    vec3 green = vec3( luminance.y * oneMinusSat );
    green += vec3( 0,_saturation, 0 )*COLORMANIPULATOR_greenVal;
    vec3 blue = vec3( luminance.z * oneMinusSat );
    blue += vec3( 0, 0,_saturation )*COLORMANIPULATOR_blueVal;
	
    return mat4(vec4(red, 0),vec4(green,0),vec4(blue,0),vec4(0, 0, 0, 1));
}
void colorManipulator(in vec2 uv, in sampler2D sampler, vec2 size, vec2 pixelSize, inout vec4 color){
	vec4 c2 = color * COLORMANIPULATOR_tint_color;
	color = COLORMANIPULATOR_brightnessMatrix( COLORMANIPULATOR_brightness ) * COLORMANIPULATOR_contrastMatrix( COLORMANIPULATOR_contrast ) * COLORMANIPULATOR_saturationMatrix( COLORMANIPULATOR_saturation ) * mix(color, c2, COLORMANIPULATOR_tint_effect_factor);
}