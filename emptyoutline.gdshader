//EMPTY OUTLINE
uniform bool  EMPTYOUTLINE_active  = true;
uniform vec4  EMPTYOUTLINE_lineColor : source_color = vec4(1);
uniform float EMPTYOUTLINE_lineThickness : hint_range(0, 30) = 3.0;
void emptyOutline(in vec2 uv, in sampler2D tex, in vec2 spriteSize, in vec2 pixelSize, inout vec4 color) {
	vec2 size = pixelSize * EMPTYOUTLINE_lineThickness;
	vec4 outline = texture(tex, uv + vec2(-size.x, 0));
	outline += texture(tex, uv + vec2(0, size.y));
	outline += texture(tex, uv + vec2(size.x, 0));
	outline += texture(tex, uv + vec2(0, -size.y));
	outline += texture(tex, uv + vec2(-size.x, size.y));
	outline += texture(tex, uv + vec2(size.x, size.y));
	outline += texture(tex, uv + vec2(-size.x, -size.y));

	outline += texture(tex, uv + vec2(size.x, -size.y));
	outline.rgb = EMPTYOUTLINE_lineColor.rbg;
	if (outline.a > 0.5) { outline = EMPTYOUTLINE_lineColor; }
	if (texture(tex, uv).a > 0.5) { outline.a = 0.0; }
	color = outline;
}
