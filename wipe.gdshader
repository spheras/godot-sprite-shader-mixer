uniform bool WIPE_active = true;	
uniform float WIPE_percentage: hint_range(0, 1) = 0.5;
uniform float WIPE_hidden_alpha: hint_range(0, 1) = 0;
uniform bool WIPE_flip = false;
uniform bool WIPE_horizontal = false;
uniform int WIPE_frames = 1;
void wipe(in vec2 uv, in sampler2D txt, in vec2 size, in vec2 pixelSize, inout vec4 finalColor){
	float frame_uv_size = 1.0 / float(WIPE_frames);
	float uv_position = WIPE_horizontal ? uv.x : uv.y;

	// Reduce the uv_position in all frames to the same relative position in the
	// first frame. For example: with 2 frames, a uv_position of 0.75 is 0.25
	// away from the second frame's start of 0.5, so it will be reduced to 0.25.
	uv_position -= frame_uv_size * floor(uv_position / frame_uv_size);

	float frame_percentage = WIPE_percentage / float(WIPE_frames);
	float step_value = WIPE_flip ?
			step(1.0 - frame_percentage, uv_position)
			: step(uv_position, frame_percentage);

	finalColor.a = finalColor.a * (WIPE_hidden_alpha + step_value);
}