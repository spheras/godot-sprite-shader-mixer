uniform bool PIXELDISOLVE_active=true;
uniform float PIXELDISOLVE_time:hint_range(0.0, 1.57, 0.001) = 1.0;
uniform vec2 PIXELDISOLVE_custom_resolution = vec2(100,100);
float PIXELDISOLVE_rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,96.233))) * 43758.5453);
}
void pixelDisolve(in vec2 uv, in sampler2D sampler, vec2 size, vec2 pixelSize, inout vec4 color){
{
	vec2 within_texture_pixel=vec2(floor(uv * PIXELDISOLVE_custom_resolution));
	if(sin(PIXELDISOLVE_time) <= PIXELDISOLVE_rand(within_texture_pixel))
		color = vec4(0.0,0.0,0.0,0.0);
	}
}