uniform bool PLASMAWAVES_active = true;
uniform bool PLASMAWAVES_maskLines = true;
uniform float PLASMAWAVES_gridSmoothWidth : hint_range(0.001, 1.0, 0.001)= 0.015;
uniform float PLASMAWAVES_scale:hint_range(0.0, 50.0, 0.1) = 5.0;
const vec4 PLASMAWAVES_lineColor = vec4(0.25, 0.5, 1.0, 1.0);
const float PLASMAWAVES_minLineWidth = 0.02;
const float PLASMAWAVES_maxLineWidth = 0.5;
uniform float PLASMAWAVES_lineSpeed:hint_range(0.0, 5.0, 0.1) = 1.0 ;
uniform float PLASMAWAVES_lineAmplitude:hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float PLASMAWAVES_lineFrequency:hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float PLASMAWAVES_warpSpeed:hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float PLASMAWAVES_warpFrequency:hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float PLASMAWAVES_warpAmplitude:hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float PLASMAWAVES_offsetFrequency:hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float PLASMAWAVES_offsetSpeed:hint_range(0.0, 5.0, 0.1) = 1.33;
uniform float PLASMAWAVES_minOffsetSpread:hint_range(0.0, 1.0, 0.1) = 0.6;
uniform float PLASMAWAVES_maxOffsetSpread:hint_range(0.0, 5.0, 0.1) = 2.0;
uniform int PLASMAWAVES_linesPerGroup:hint_range(0, 100, 1) = 16;
const vec4[] PLASMAWAVES_bgColors = {
    vec4(PLASMAWAVES_lineColor * 0.5),
    vec4(PLASMAWAVES_lineColor - vec4(0.2, 0.2, 0.7, 1))
};
#define PLASMAWAVES_drawCircle(P, r, U)     smoothstep(r + PLASMAWAVES_gridSmoothWidth, r, length(U - (P)))
#define PLASMAWAVES_drawSmoothLine(P, w, t) smoothstep((w) / 2.0, 0.0, abs(P - (t)))
#define PLASMAWAVES_drawCrispLine(P, w, t)  smoothstep(PLASMAWAVES_gridSmoothWidth, 0.0, abs(P - (w) / 2.0 - (t)))
#define PLASMAWAVES_drawPeriodicLine(f, w, t)  drawCrispLine(f / 2.0, w, abs(mod(t, f) - f / 2.0))
// Probably can optimize w/ noise, but currently using Fourier transform
float PLASMAWAVES_random(float t)
{
    return (cos(t) + cos(t * 1.3 + 1.3) + cos(t * 1.4 + 1.4)) / 3.0;
}
float PLASMAWAVES_getPlasmaY(float x, float horizontalFade, float offset)
{
    return PLASMAWAVES_random(x * PLASMAWAVES_lineFrequency + TIME * PLASMAWAVES_lineSpeed) * horizontalFade * PLASMAWAVES_lineAmplitude + offset;
}
void plasmaWaves(in vec2 uv2, in sampler2D sampler, vec2 size, vec2 pixelSize, inout vec4 color, in vec4 fragcoord, in vec2 screenPixelSize)
{
    vec2 uv = fragcoord.xy.xy / (1.0/screenPixelSize).xy;
    vec2 space = (fragcoord.xy - (1.0/screenPixelSize).xy / 2.0) / (1.0/screenPixelSize).x * 2.0 * PLASMAWAVES_scale;

    float horizontalFade = 1.0 - (cos(uv.x * 6.28) * 0.5 + 0.5);
    float verticalFade = 1.0 - (cos(uv.y * 6.28) * 0.5 + 0.5);

    // Fun with nonlinear transformations! (wind / turbulence)
    space.y += PLASMAWAVES_random(space.x * PLASMAWAVES_warpFrequency + TIME * PLASMAWAVES_warpSpeed) * PLASMAWAVES_warpAmplitude * (0.5 + horizontalFade);
    space.x += PLASMAWAVES_random(space.y * PLASMAWAVES_warpFrequency + TIME * PLASMAWAVES_warpSpeed + 2.0) * PLASMAWAVES_warpAmplitude * horizontalFade;

    vec4 lines = vec4(0);

    for (int l = 0; l < PLASMAWAVES_linesPerGroup; l++)
    {
        float normalizedLineIndex = float(l) / float(PLASMAWAVES_linesPerGroup);
        float offsetTime = TIME * PLASMAWAVES_offsetSpeed;
        float offsetPosition = float(l) + space.x * PLASMAWAVES_offsetFrequency;
        float rand = PLASMAWAVES_random(offsetPosition + offsetTime) * 0.5 + 0.5;
        float halfWidth = mix(PLASMAWAVES_minLineWidth, PLASMAWAVES_maxLineWidth, rand * horizontalFade) / 2.0;
        float offset = PLASMAWAVES_random(offsetPosition + offsetTime * (1.0 + normalizedLineIndex)) * mix(PLASMAWAVES_minOffsetSpread, PLASMAWAVES_maxOffsetSpread, horizontalFade);
        float linePosition = PLASMAWAVES_getPlasmaY(space.x, horizontalFade, offset);
        float line = PLASMAWAVES_drawSmoothLine(linePosition, halfWidth, space.y) / 2.0 + PLASMAWAVES_drawCrispLine(linePosition, halfWidth * 0.15, space.y);

        float circleX = mod(float(l) + TIME * PLASMAWAVES_lineSpeed, 25.0) - 12.0;
        vec2 circlePosition = vec2(circleX, PLASMAWAVES_getPlasmaY(circleX, horizontalFade, offset));
        float circle = PLASMAWAVES_drawCircle(circlePosition, 0.01, space) * 4.0;

        line = line + circle;
        lines += line * PLASMAWAVES_lineColor * rand;
    }

		vec4 newColor= mix(PLASMAWAVES_bgColors[0], PLASMAWAVES_bgColors[1], uv.x);
	    newColor *= verticalFade;
	    newColor += lines;
		if(PLASMAWAVES_maskLines){
			if(color.a!=0.){
				color = newColor*2. + color;
			}
		}else{
			color = newColor*2. + color;
		}
}