uniform bool WINDWAVE_active=true;
uniform float WINDWAVE_speed:hint_range(0.0, 40, 0.01)=3.3;
uniform float WINDWAVE_modifier1:hint_range(0.0,0.3,0.01)=0.05;
uniform float WINDWAVE_modifier2:hint_range(0.0,80,0.01)=6.7;
uniform float WINDWAVE_maxY:hint_range(0.0,1.0,0.001)=0.43;
uniform float WINDWAVE_minY:hint_range(0.0,1.0,0.001)=0.6;
uniform bool WINDWAVE_debugLines=true;
void windWave(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 texturePixelSize, inout vec4 color) {
	float dot1=WINDWAVE_modifier1*(1.-uv.y);
	float dot2=WINDWAVE_modifier2*(1.-uv.y);
	vec2 displaceUV=uv;
	if(uv.y<WINDWAVE_maxY){
		displaceUV=vec2(uv.x - dot1 *  sin(uv.y*dot2+ TIME*WINDWAVE_speed),uv.y);		
	}else  if(uv.y>=WINDWAVE_maxY && uv.y<WINDWAVE_minY){
		float percent=smoothstep(WINDWAVE_minY,WINDWAVE_maxY,uv.y);
		dot1=dot1*percent;
		dot2=dot2*percent;
		displaceUV=vec2(uv.x - dot1 * sin(uv.y*dot2 + TIME*WINDWAVE_speed),uv.y);
	}

	vec4 col=texture(txt, displaceUV);
	color = col;
	if(WINDWAVE_debugLines){
		if((abs(uv.y - WINDWAVE_maxY) < 0.003)){
			color=vec4(0,1,0,1);
		}
		if((abs(uv.y - WINDWAVE_minY) < 0.003)){
			color=vec4(1,0,0,1);
		}
	}
}