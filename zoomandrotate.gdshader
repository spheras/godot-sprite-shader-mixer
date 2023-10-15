uniform bool ZOOMANDROTATION_active=true;
uniform vec2 ZOOMANDROTATION_center=vec2(0.5);
uniform float ZOOMANDROTATION_zoom:hint_range(0.0, 10.0, 0.1)=1;
uniform float ZOOMANDROTATION_rotate:hint_range(0.0, 6.3, 0.1)=1;
vec2 ZOOMANDROTATION_rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}
void zoomAndRotation(inout vec2 uv, in sampler2D tex, in vec2 spriteSize, in vec2 pixelSize, inout vec4 color) {
    uv = (uv - ZOOMANDROTATION_center) * ZOOMANDROTATION_zoom + ZOOMANDROTATION_center;
	uv = ZOOMANDROTATION_rotateUV(uv, ZOOMANDROTATION_center , ZOOMANDROTATION_rotate);
	color = texture(tex, uv);
}