//AURA
uniform bool AURA_active=true;
uniform float AURA_speedX:hint_range(-1.0, 1.0, 0.001)=0;
uniform float AURA_speedY:hint_range(-1.0, 1.0, 0.001)=0.08;
uniform float AURA_amount:hint_range(0.0, 10.0, 0.1)=2.7;
uniform vec4 AURA_auraColor:source_color=vec4(1.0,1.0,0,1);
uniform float AURA_distanceSaturation:hint_range(0.0, 1.0, 0.01)=1;
uniform float AURA_redDist:hint_range(0.0, 10.0, 0.1)=7.7;
uniform float AURA_greenDist:hint_range(0.0, 10.0, 0.1)=7.9;
uniform float AURA_blueDist:hint_range(0.0, 10.0, 0.1)=0;
uniform sampler2D AURA_noiseTexture:repeat_enable;
void aura(inout vec2 uv, in sampler2D tex, in vec2 spriteSize, in vec2 pixelSize, inout vec4 color) {
	vec2 noiseUV=vec2(uv.x+TIME*AURA_speedX, uv.y+TIME*AURA_speedY);
	vec4 noiseColor=texture(AURA_noiseTexture, noiseUV);

	float calc=-noiseColor.r*AURA_amount*0.01;
	vec2 displacement1=vec2(-calc,0);
	vec2 displacement2=vec2(calc,0);
	vec2 displacement3=vec2(0,calc);
	vec2 displacement4=vec2(0,-calc);
	vec2 displacement5=vec2(-calc,-calc);
	vec2 displacement6=vec2(calc,calc);
	vec2 displacement7=vec2(calc,-calc);
	vec2 displacement8=vec2(-calc,calc);

	vec4 newColor1 = texture(tex, uv + displacement1);
	vec4 newColor2 = texture(tex, uv + displacement2);
	vec4 newColor3 = texture(tex, uv + displacement3);
	vec4 newColor4 = texture(tex, uv + displacement4);
	vec4 newColor5 = texture(tex, uv + displacement5);
	vec4 newColor6 = texture(tex, uv + displacement6);
	vec4 newColor7 = texture(tex, uv + displacement7);
	vec4 newColor8 = texture(tex, uv + displacement8);

	float distCenter=distance(uv.x,0.5)+distance(uv.y,0.5);
	distCenter=smoothstep(0.0,AURA_distanceSaturation,distCenter);

	float alpha=newColor1.a+newColor2.a+newColor3.a+newColor4.a+newColor5.a+newColor6.a+newColor7.a+newColor8.a;
	vec3 auraColorDistorted=vec3(AURA_redDist*distCenter+AURA_auraColor.r*distCenter, AURA_greenDist*distCenter+AURA_auraColor.g*distCenter, AURA_blueDist*distCenter+AURA_auraColor.b*distCenter);
	if(color.a<1. && color.a>0.){
		color=mix(color,vec4(auraColorDistorted,alpha),0.5);	
	}else if(color.a==0. && alpha>0.){
		color=vec4(auraColorDistorted,1.);
	}
}