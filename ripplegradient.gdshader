uniform bool RIPPLEGRADIENT_active=true;
uniform float RIPPLEGRADIENT_speed = 1.0;
uniform float RIPPLEGRADIENT_frequency = 10.0;
uniform float RIPPLEGRADIENT_amplitude = 0.1;
uniform bool RIPPLEGRADIENT_pastelColors = false;
uniform float RIPPLEGRADIENT_mix : hint_range(0, 1, 0.1) = .9;
void rippleGradient(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 pixelSize, inout vec4 color){
    float time = TIME * RIPPLEGRADIENT_speed;

   
    float wave1 = sin(uv.x * RIPPLEGRADIENT_frequency + time) * RIPPLEGRADIENT_amplitude;
    float wave2 = cos(uv.y * RIPPLEGRADIENT_frequency + time) * RIPPLEGRADIENT_amplitude;
    uv += wave1 + wave2;

	vec3 color1;
	vec3 color2;
    if(RIPPLEGRADIENT_pastelColors){
		color1 = vec3(0.8 + 0.2 * sin(time), 0.8 + 0.2 * cos(time), 0.8 - 0.2 * sin(time));
    	color2 = vec3(0.8 - 0.2 * cos(time), 0.8 + 0.2 * sin(time), 0.8 + 0.2 * cos(time));
	}else{
	    color1 = vec3(0.5 + 0.5 * sin(time), 0.5 + 0.5 * cos(time), 0.5 - 0.5 * sin(time));
	    color2 = vec3(0.5 - 0.5 * cos(time), 0.5 + 0.5 * sin(time), 0.5 + 0.5 * cos(time));
	}
    vec3 gradient_color = mix(color1, color2, uv.y);

	if(color.a>0.){
    	color = mix(color, vec4(gradient_color, 1.0), RIPPLEGRADIENT_mix);
	}
}
