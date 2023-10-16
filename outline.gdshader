//OUTLINE
uniform bool  OUTLINE_active  = true;
uniform float OUTLINE_thickness : hint_range(0, 30) = 20.0;
uniform vec4  OUTLINE_color : source_color = vec4(1,0,0,1);
void outline(in vec2 uv, in sampler2D tex, in vec2 spriteSize, in vec2 pixelSize, inout vec4 color) {
    vec2 size = vec2(OUTLINE_thickness) / spriteSize;
	   
    float alpha = color.a;
    alpha += texture(tex, uv + vec2(0.0, -size.y)).a;
    alpha += texture(tex, uv + vec2(size.x, -size.y)).a;
    alpha += texture(tex, uv + vec2(size.x, 0.0)).a;
    alpha += texture(tex, uv + vec2(size.x, size.y)).a;
    alpha += texture(tex, uv + vec2(0.0, size.y)).a;
    alpha += texture(tex, uv + vec2(-size.x, size.y)).a;
    alpha += texture(tex, uv + vec2(-size.x, 0.0)).a;
    alpha += texture(tex, uv + vec2(-size.x, -size.y)).a;
   
    vec3 final_color = mix(OUTLINE_color.rgb, color.rgb, color.a);
    color = vec4(final_color, clamp(alpha, 0.0, 1.0));
}