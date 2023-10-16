//TELEPORT
uniform bool TELEPORT_active = true;
uniform float TELEPORT_progress : hint_range(0.0, 1.0)=0.24;
uniform float TELEPORT_noise_desnity:hint_range(0.0, 500.0, 0.1) = 160;
uniform float TELEPORT_beam_size : hint_range(0.01, 0.15);
uniform vec4 TELEPORT_color : source_color = vec4(0.0, 1.02, 1.2, 1.0);
vec2 TELEPORT_random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}
float TELEPORT_noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( TELEPORT_random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( TELEPORT_random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( TELEPORT_random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( TELEPORT_random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) * 0.5 + 0.5;
}
void teleport(in vec2 uv, in sampler2D txt, vec2 size, vec2 pixelSize, inout vec4 color)
{
	float noise = TELEPORT_noise(uv * TELEPORT_noise_desnity) * uv.y;
	
	float d1 = step(TELEPORT_progress, noise);
	float d2 = step(TELEPORT_progress - TELEPORT_beam_size, noise);
	
	vec3 beam = vec3(d2 - d1) * color.rgb;
	
	color.rgb += beam;
	color.a *= d2;
}