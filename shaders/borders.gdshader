shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : source_color, hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_nearest;
uniform float depth_threshold : hint_range(0, 1) = 0.05;
uniform float darkness_multiplier = 0.2;

float get_depth(vec2 screen_uv, mat4 inv_projection_matrix) {
	float depth = texture(depth_texture, screen_uv).r;
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	
	return -view.z;
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	float depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
	vec2 texel_size = 1.0 / VIEWPORT_SIZE.xy;
	
	vec2 uvs[4];
	uvs[0] = vec2(SCREEN_UV.x, SCREEN_UV.y + texel_size.y);
	uvs[1] = vec2(SCREEN_UV.x, SCREEN_UV.y - texel_size.y);
	uvs[2] = vec2(SCREEN_UV.x + texel_size.x, SCREEN_UV.y);
	uvs[3] = vec2(SCREEN_UV.x - texel_size.x, SCREEN_UV.y);

	float depth_diff = 0.0;
	float nearest_depth = depth;
	vec2 nearest_uv = SCREEN_UV;
	
	for (int i = 0; i < 4; i++) {
		float d = get_depth(uvs[i], INV_PROJECTION_MATRIX);
		depth_diff += depth - d;
	
		if (d < nearest_depth);
			nearest_depth = d;
			nearest_uv = uvs[i];
	}
	
	float depth_edge = step(depth_threshold, depth_diff);
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;
	vec3 nearest = texture(screen_texture, nearest_uv).rgb;
	
	vec3 edge_mix = mix(original, original * nearest, depth_edge);
	
	ALBEDO = vec3(edge_mix);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
