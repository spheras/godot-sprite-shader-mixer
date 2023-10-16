uniform bool COLORSWAPHUE_active = true;
uniform vec4 COLORSWAPHUE_from : source_color=vec4(0,0,1,1);
uniform vec4 COLORSWAPHUE_to : source_color=vec4(1,0,0,1);
uniform float COLORSWAPHUE_tolerance: hint_range(0.0, 1.0)=1.0;
vec3 COLORSWAPHUE_rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 COLORSWAPHUE_hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
void colorSwapHue(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 pixelSize, inout vec4 color)
{
	// we usually want more granularity the closer we are to the original color
	float _tol = COLORSWAPHUE_tolerance * COLORSWAPHUE_tolerance;
	
	vec3 source_hsv = COLORSWAPHUE_rgb2hsv(color.rgb);
	vec3 initial_hsv = COLORSWAPHUE_rgb2hsv(COLORSWAPHUE_from.rgb);
	vec3 hsv_shift = COLORSWAPHUE_rgb2hsv(COLORSWAPHUE_to.rgb) - initial_hsv;
	
	float hue = initial_hsv.r;
	
	// the .r here represents HUE, .g is SATURATION, .b is LUMINANCE
	if (hue - source_hsv.r >= -_tol && hue - source_hsv.r <= +_tol)
	{
		vec3 final_hsv = source_hsv + hsv_shift;
		color.rgb = COLORSWAPHUE_hsv2rgb(final_hsv);
	}	
}