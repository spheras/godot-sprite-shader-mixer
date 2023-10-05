//SHADOW
uniform bool  SHADOW_active  = true;
uniform vec2  SHADOW_deform = vec2(0.0, 0.0);
uniform vec2  SHADOW_offset = vec2(20.0, 20.0);
uniform vec4  SHADOW_modulate : source_color;
uniform float SHADOW_mix : hint_range(0,1) = 0;
void shadow(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 texturePixelSize, inout vec4 color) {
	float sizex = float(textureSize(txt,int(texturePixelSize.x)).x); //comment for GLES2
	float sizey = float(textureSize(txt,int(texturePixelSize.y)).y); //comment for GLES2
	//float sizex = texture_size.x; //uncomment for GLES2
	//float sizey = texture_size.y; //uncomment for GLES2
	uv.y+=SHADOW_offset.y*texturePixelSize.y;
	uv.x+=SHADOW_offset.x*texturePixelSize.x;
	float decalx=((uv.y-texturePixelSize.x*sizex)*SHADOW_deform.x);
	float decaly=((uv.y-texturePixelSize.y*sizey)*SHADOW_deform.y);
	uv.x += decalx;
	uv.y += decaly;
	vec4 shadow = vec4(SHADOW_modulate.rgb, texture(txt, uv).a * SHADOW_modulate.a * 0.5);
	color =mix(mix(shadow, color, color.a), color, SHADOW_mix);
}
