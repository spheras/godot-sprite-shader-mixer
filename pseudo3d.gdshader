
// Camera FOV.,- - <MM
uniform bool PSEUDO3D_active = true;
uniform float PSEUDO3D_fov : hint_range(1, 179) = 90;
uniform float PSEUDO3D_y_rot : hint_range(-180, 180) = 50.0;
uniform float PSEUDO3D_x_rot : hint_range(-180, 180) = 0.0;
// At 0, the image retains its size when unrotated.
// At 1, the image is resized so that it can do a full
// rotation without clipping inside its rect.
uniform float PSEUDO3D_inset : hint_range(0, 1) = 0.0;
// Consider changing this to a uniform and changing it from code
varying flat vec2 PSEUDO3D_o;
varying vec3 PSEUDO3D_p;
// Creates rotation matrix
void pseudo3d_vertex(in vec2 uv, inout vec3 p, inout vec2 o, inout vec2 vertex, vec2 pixelSize){
	float sin_b = sin(PSEUDO3D_y_rot / 180.0 * PI);
	float cos_b = cos(PSEUDO3D_y_rot / 180.0 * PI);
	float sin_c = sin(PSEUDO3D_x_rot / 180.0 * PI);
	float cos_c = cos(PSEUDO3D_x_rot / 180.0 * PI);
	
	mat3 inv_rot_mat;
	inv_rot_mat[0][0] = cos_b;
	inv_rot_mat[0][1] = 0.0;
	inv_rot_mat[0][2] = -sin_b;
	
	inv_rot_mat[1][0] = sin_b * sin_c;
	inv_rot_mat[1][1] = cos_c;
	inv_rot_mat[1][2] = cos_b * sin_c;
	
	inv_rot_mat[2][0] = sin_b * cos_c;
	inv_rot_mat[2][1] = -sin_c;
	inv_rot_mat[2][2] = cos_b * cos_c;
	
	
	float t = tan(PSEUDO3D_fov / 360.0 * PI);
	p = inv_rot_mat * vec3((uv - 0.5), 0.5 / t);
	float v = (0.5 / t) + 0.5;
	p.xy *= v * inv_rot_mat[2].z;
	o = v * inv_rot_mat[2].xy;

	vertex += (uv - 0.5) / pixelSize * t * (1.0 - PSEUDO3D_inset);
}
void pseudo3d(inout vec2 uv, in sampler2D txt, vec2 size, vec2 pixelSize, inout vec4 color) {
		vec2 newUV = (PSEUDO3D_p.xy / PSEUDO3D_p.z).xy - PSEUDO3D_o;
        uv=newUV;
	    color = texture(txt, newUV + 0.5);
		color.a *= step(max(abs(newUV.x), abs(newUV.y)), 0.5);
}
