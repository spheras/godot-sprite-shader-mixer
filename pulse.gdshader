uniform bool PULSE_active = true; //activation
uniform vec4 PULSE_shine_color : source_color = vec4(1.0); //Shine color
uniform float PULSE_alpha_limit : hint_range(0.0, 1.0, 0.1) = 0.0; //Alpha color limit to apply the shine, for example, if you won't to apply the shine to semi-transparent pixels
uniform float PULSE_cycle_speed : hint_range(0.0, 100.0, 0.1) = 1.0; //Pulse cycle speed
uniform bool PULSE_full_pulse_cycle = false; //[False = Do the effect and make a pause] [True = Do the effect continuosly]
void pulse(in vec2 uv, in sampler2D tex, in vec2 spriteSize, in vec2 pixelSize, inout vec4 color)
{
	//Check the pixel alpha value
	if (color.a >= PULSE_alpha_limit)
	{
		float cycle = sin(TIME * PULSE_cycle_speed);
		color.rgb = mix(color.rgb, PULSE_shine_color.rgb, (((cycle >= 0.0) || (PULSE_full_pulse_cycle)) ? abs(cycle) : 0.0) * PULSE_shine_color.a);
	}
}