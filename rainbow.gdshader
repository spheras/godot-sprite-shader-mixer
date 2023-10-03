//RAINBOW
uniform bool  RAINBOW_active  = true;
uniform float RAINBOW_speed : hint_range(0, 5) = 1;
uniform float RAINBOW_redFactor : hint_range(0, 5) = 3;
uniform float RAINBOW_greenFactor : hint_range(0, 5) = 2;
uniform float RAINBOW_blueFactor : hint_range(0, 5) = 5;
void rainbow(in vec2 uv, in sampler2D tex, vec2 size, vec2 pixelSize, inout vec4 color) {
	color=vec4(color.r+sin(TIME*RAINBOW_redFactor*RAINBOW_speed), color.g+sin(TIME*RAINBOW_greenFactor*RAINBOW_speed), color.b+sin(TIME*RAINBOW_blueFactor*RAINBOW_speed), color.a);
}

