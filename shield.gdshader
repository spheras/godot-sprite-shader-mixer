//SHIELD
uniform bool SHIELD_active = true;
uniform float SHIELD_ring_radius : hint_range(0.1, 0.5, 0.01) = 0.2;
uniform float SHIELD_thickness_scalar : hint_range(0.0, 1, 0.05) = 0.2;
uniform float SHIELD_oscillation_scalar : hint_range(0.0, 0.25, 0.005) = 0.045;
uniform float SHIELD_speed : hint_range(0.0, 50.0, 0.1) = 3.0;
uniform vec4 SHIELD_main_color : source_color = vec4(0.0,0.5,0.0,1.0);
uniform vec4 SHIELD_lerp_color : source_color = vec4(0.0,1.0,0.0,1.0);
float SHIELD_range_lerp(float value, float min1, float min2, float max1, float max2){
	return min2 + (max2 - min2) * ((value - min1) / (max1 - min1));
}
void shield(in vec2 uv, in sampler2D sampler, vec2 size, vec2 pixelSize, inout vec4 color){
	// Calculate the distance between the current pixel and the center of the unit
	float dist = distance(uv, vec2(0.5, 0.5));

	// Add a slight oscillation to the size of the ring
	float o = cos(TIME * SHIELD_speed) - sin(TIME*SHIELD_speed)*dist*SHIELD_speed;
	float ring_size = SHIELD_ring_radius + o * SHIELD_oscillation_scalar;
	
	// Solve for ring alpha channel
	float alpha = step(dist, ring_size) * smoothstep(ring_size * (1.0 - SHIELD_thickness_scalar), ring_size, dist);
	
	// Solve w mix amount for optional color lerping
	float w = SHIELD_range_lerp(o, -1.0, 1.0, 1.0, 0.0);
	
	// Output the final color
	if(alpha>0.){
		vec4 newColor = vec4(mix(SHIELD_main_color.rgb, SHIELD_lerp_color.rgb, w), alpha );
		if(color.a > 0.){
			color = color * mix(newColor, color, 2.*color.a);		
		}else{
			color = newColor;
		}
	}
}