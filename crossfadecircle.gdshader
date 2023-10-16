//CROSSFADE_CIRCLE
uniform bool  CROSSFADE_CIRCLE_active  = true;
uniform float CROSSFADE_CIRCLE_transparency : hint_range(0.0, 1.0) = 1.0;
uniform vec2  CROSSFADE_CIRCLE_position=vec2(1,1);
uniform vec4  CROSSFADE_CIRCLE_dissolveColor : source_color = vec4(0,0,0,1);
uniform float CROSSFADE_CIRCLE_circleSize = 0.2;
void crossfadeCircle(in vec2 uv, in sampler2D tex, in vec2 size, in vec2 pixelSize, inout vec4 color){
	    vec2 center = CROSSFADE_CIRCLE_position / 2.0;
	    float distanceCurrentPixelToCenter = distance(uv, center);
	    float fadeWidth = CROSSFADE_CIRCLE_circleSize;
	    float transition = smoothstep(fadeWidth, 0.0, distanceCurrentPixelToCenter) * sin(CROSSFADE_CIRCLE_transparency);
	    color = mix(CROSSFADE_CIRCLE_dissolveColor, color, transition);	
}