shader_type spatial;
render_mode unshaded, cull_front;

varying vec3 world_pos;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

struct Box {
	float x, y, z, w, h, d;
};

bool point_inside_box(vec3 point, Box box) {
	if(box.x > point.x)
		return false;
	if(box.y > point.y)
		return false;
	if(box.z > point.z)
		return false;
	if(box.x + box.w < point.x)
		return false;
	if(box.y + box.h < point.y)
		return false;
	if(box.z + box.d < point.z)
		return false;
	return true;
}
void fragment() {
	Box boxes[2] = {
		Box(-0.4, 0.0, 0.0, 0.5, 0.5, 0.5),
		Box(-0.3, -0.2, -0.4, 0.5, 0.1, 0.1)
	};
	bool boxCovered[2] = {false, false};
	
	vec3 eye_offset_world = (INV_VIEW_MATRIX * vec4(EYE_OFFSET, 0.0)).xyz;
	vec3 eye_world = CAMERA_POSITION_WORLD + eye_offset_world;
	vec3 ray_dir_world = normalize(world_pos - eye_world);

    mat4 inv_model = inverse(MODEL_MATRIX);
    vec3 ray_origin = (inv_model * vec4(eye_world, 1.0)).xyz;
    vec3 ray_dir = normalize((inv_model * vec4(ray_dir_world, 0.0)).xyz);
	
	vec3 point = ray_origin;
	
	ALBEDO = vec3(0.0, 0.0, 0.0);
	ALPHA = 0.4;
	
	for(int i = 0; i < 500; i++) {
		point += ray_dir * 0.01;
		for(int j = 0; j < 2; j++) {
			if(point_inside_box(point, boxes[j]) && !boxCovered[j]) {
				ALBEDO += vec3(0.9, 0.9, 0.9);
				ALPHA += 0.2;
				boxCovered[j] = true;
			}
		}
	}
}