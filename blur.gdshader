//BLUR
uniform bool  BLUR_active  = true;
uniform float BLUR_radius : hint_range(1, 15.0) = 15.0;
uniform float BLUR_mix : hint_range(0,1.0)=0;
void blur(in vec2 uv, in sampler2D tex, in vec2 size, in vec2 pixelSize, inout vec4 color) {
	vec4 final_color = vec4(0.0);
    float total_weight = 0.0;

    for (float x = -BLUR_radius; x <= BLUR_radius; x += 1.0) {
        for (float y = -BLUR_radius; y <= BLUR_radius; y += 1.0) {
            vec2 offset = vec2(x, y);
            vec4 sample = texture(tex, uv + offset / size);

            float distance = length(offset);
            float weight = smoothstep(BLUR_radius, BLUR_radius - 1.0, distance);

            final_color += mix(sample * weight, color,BLUR_mix);
            total_weight += weight;
        }
    }
    color= final_color / total_weight;
}