uniform bool CIRCULARWAVES_active = true;
// for circles
uniform float CIRCULARWAVES_amplitude: hint_range(0, 2, 0.01) = 2.0;
uniform float CIRCULARWAVES_frequency: hint_range(0, 15, 0.01) = 12.69;
uniform float CIRCULARWAVES_rippleRate : hint_range(0.5, 150.0, 0.1) = 9.2;
uniform float CIRCULARWAVES_speed : hint_range ( 0, 30, 0.01) = 1;
// for wave
uniform float CIRCULARWAVES_waveDeformation : hint_range(0.0, 10, 0.1)= 0.5;
uniform float CIRCULARWAVES_waveAmplitude : hint_range(0.0, 1.0, 0.1)= 0.1;
uniform float CIRCULARWAVES_waveFrequency : hint_range(0.0, 10, .1)= 4.0;
uniform float CIRCULARWAVES_blendingAmount : hint_range(0.0, 1.0, 0.001) = 0.6;
uniform vec4  CIRCULARWAVES_waveColor1:source_color=vec4(1);
uniform vec4  CIRCULARWAVES_waveColor2:source_color=vec4(1);
// modes
uniform bool CIRCULARWAVES_mode1 = true;
uniform bool CIRCULARWAVES_mode2 = false;
uniform bool CIRCULARWAVES_mode3 = false;
// noise
uniform sampler2D CIRCULARWAVES_noise;
vec2 CIRCULARWAVES_wave(vec2 uv, float time) {
    return vec2(
        uv.x + sin(uv.y * CIRCULARWAVES_waveFrequency * 5.0 + time) * CIRCULARWAVES_waveAmplitude,
        uv.y + sin(uv.x * CIRCULARWAVES_waveFrequency + time) * CIRCULARWAVES_waveAmplitude
    );
}
void circularWaves(in vec2 txtUV, in sampler2D txt, in vec2 spriteSize, in vec2 pixelSize, inout vec4 finalColor){
	vec2 wave_uv = CIRCULARWAVES_wave(txtUV, TIME*CIRCULARWAVES_speed);
	vec4 ns = texture(CIRCULARWAVES_noise, wave_uv);
	
	vec2 motion = vec2(0.0, 1.0);
	float pi = 3.14159265358979323846;
	vec2 uv = txtUV * 2.0 - 1.0;

	float dist = length(uv);
	ns *= 1.4142135;
	dist += -0.1 * ns.x * CIRCULARWAVES_waveDeformation;
	float ripple = sin(dist * -CIRCULARWAVES_frequency * pi + CIRCULARWAVES_rippleRate * TIME * CIRCULARWAVES_speed) * CIRCULARWAVES_amplitude / (dist + 1.0);


	vec4 color = CIRCULARWAVES_waveColor1 * ripple;
	vec4 color2 = CIRCULARWAVES_waveColor2 * vec4(1.0,1.0,1.0,ripple); 
	color = color2 / color;
	color=vec4(1.0, 1.0, 1.0, 1.0 * ripple) / color;
	
	float alphaScalar = (1.0 - min(dist, 1.0)) * ns.x * 2.5; 

	color.a *= 1.0 * alphaScalar * (ripple + ns.x * ns.y);
	color.a = max(color.a - (ns.y * 0.45), 0.0);

	if (CIRCULARWAVES_mode1){
		finalColor= color * CIRCULARWAVES_blendingAmount + finalColor;
	}
	if (CIRCULARWAVES_mode2){
		finalColor = mix(color * finalColor, finalColor, 0.1) ;
	}
	if (CIRCULARWAVES_mode3){
		finalColor = mix(color*finalColor/color, finalColor, 0.2);
	}
}