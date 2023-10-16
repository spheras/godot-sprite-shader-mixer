//LIGHTNING
uniform bool LIGHTNING_active=true;
uniform vec4 LIGHTNING_lightningColor: source_color=vec4(1,1,1,1);
uniform float LIGHTNING_size: hint_range (0.,1.)=0.3;
uniform float LIGHTNING_width: hint_range (0.,1.)=1;
uniform float LIGHTNING_speed:hint_range(0.0, 15.0, 0.1)=4;
uniform float LIGHTNING_cycle:hint_range(0.0, 15.0, 0.1)=3.5;
uniform float LIGHTNING_ratio:hint_range(0.0, 15.0, 0.1)=4.6;
uniform float LIGHTNING_time_shift:hint_range(0.0, 15.0, 0.1)=15;
float LIGHTNING_rand(float x){
	return fract(sin(x)*100000.0);
}
void lightning(in vec2 uv, in sampler2D sampler,in vec2 texSize, vec2 pixelSize, inout vec4 color){
	float bolt = abs(mod(uv.x * LIGHTNING_cycle + (LIGHTNING_rand(TIME) + LIGHTNING_time_shift) * LIGHTNING_speed * -1., 0.5)-0.25)-0.125;
	bolt *= 4. * LIGHTNING_width;
	// why 4 ? Because we use mod 0.5, the value be devide by half
	// and we -0.25 (which is half again) for abs function. So it 25%!
	// scale down at start and end
	bolt *=  (0.5 - abs(uv.x-0.5)) * 2.; 
	// turn to a line
	// center align line
	float wave = abs(uv.y - 0.5 + bolt);
	// invert and ajust size
	wave = 1. - step(LIGHTNING_size*.5, wave);
	float blink = step(LIGHTNING_rand(TIME)*LIGHTNING_ratio, .5);
	wave *= blink;
	vec4 display = LIGHTNING_lightningColor * vec4(wave);
	color =vec4(color.rgb + display.rgb, color.a);
}