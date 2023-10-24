uniform bool FLOATING_active=true;
uniform float FLOATING_amount:hint_range(0.0, 0.5, 0.001)=0.3;
uniform int FLOATING_type:hint_range(1,10,1)=1;
uniform float FLOATING_speed:hint_range(0.0,15.0,0.1)=1;
void floating(in vec2 uv, in sampler2D txt, in vec2 spriteSize, in vec2 pixelSize, inout vec4 finalColor){
	float time=TIME*FLOATING_speed;

	switch(FLOATING_type){
		case 1:
			uv=vec2(uv.x+cos(time)*FLOATING_amount,uv.y+sin(time)*FLOATING_amount*cos(time));
			break;
		case 2:
			uv=vec2(uv.x+sin(time)*FLOATING_amount,uv.y+cos(time)*FLOATING_amount);
			break;
		case 3:
			uv=vec2(uv.x+cos(time)*FLOATING_amount,uv.y+sin(time)*FLOATING_amount);
			break;
		case 4:
			uv=vec2(uv.x+cos(time)*FLOATING_amount+sin(time)*FLOATING_amount,uv.y+sin(time)*FLOATING_amount);
			break;
		case 5:
			uv=vec2(uv.x+cos(time)*FLOATING_amount+sin(time)*FLOATING_amount,uv.y+cos(time)*FLOATING_amount);
			break;
		case 6:
			uv=vec2(uv.x+sin(time)*FLOATING_amount-sin(abs(tan(time)))*FLOATING_amount,uv.y-cos(time)*FLOATING_amount);
			break;
		case 7:
			uv=vec2(uv.x+cos(time)*sin(time)*FLOATING_amount,uv.y-sin(time)*FLOATING_amount);
			break;
		case 8:
			uv=vec2(uv.x+tan(tan(time))*FLOATING_amount/3.,uv.y-sin(tan(time))*FLOATING_amount/3.);
			break;
		case 9:
			uv=vec2(uv.x+cos(time)*FLOATING_amount/sin(TIME),uv.y+cos(time)*FLOATING_amount);
			break;
		case 10:
			uv=vec2(uv.x+cos(time)*FLOATING_amount/sin(TIME),uv.y-tan(time)*FLOATING_amount);
			break;
	};

	finalColor=texture(txt,uv);
}