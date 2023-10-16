uniform bool ALMOSTINVISIBLE_active=true;
uniform float ALMOSTINVISIBLE_dist = 16.;
uniform float ALMOSTINVISIBLE_alpha : hint_range(0., 1.) = 1.;
uniform sampler2D ALMOSTINVISIBLE_SCREEN_TEXTURE:hint_screen_texture, filter_linear_mipmap;
void almostInvisible(in vec2 uv, in vec2 screen_uv, in sampler2D sampler,in vec2 texSize, vec2 pixelSize, inout vec4 color, in vec4 fragcoord){
	vec2 backgroundUV = fragcoord.xy * pixelSize.xy;	
	vec2 offsetR = vec2(ALMOSTINVISIBLE_dist * pixelSize.x * cos(TIME * 2. * PI),        ALMOSTINVISIBLE_dist * pixelSize.x * cos(TIME*0.7 * 2. * PI));
	vec2 offsetG = vec2(ALMOSTINVISIBLE_dist * pixelSize.x * cos(1. + (TIME * 2. * PI)), ALMOSTINVISIBLE_dist * pixelSize.x * cos(3. + (TIME*0.7 * 2. * PI)));
	vec2 offsetB = vec2(ALMOSTINVISIBLE_dist * pixelSize.x * cos(TIME * 1.5 * PI),       ALMOSTINVISIBLE_dist * pixelSize.x * cos(TIME*0.9 * 2. * PI));
	vec4 backColR = texture(ALMOSTINVISIBLE_SCREEN_TEXTURE, screen_uv + offsetR);
	vec4 backColG = texture(ALMOSTINVISIBLE_SCREEN_TEXTURE, screen_uv + offsetG);
	vec4 backColB = texture(ALMOSTINVISIBLE_SCREEN_TEXTURE, screen_uv + offsetB);	
	color = mix(color, color.a * vec4(backColR.r, backColG.g, backColB.b, 1.0), ALMOSTINVISIBLE_alpha);
}