shader_type spatial;
const int num_cells = 20;
const float radius = 0.5;
uniform vec2 cell_positions[num_cells];
varying vec3 world_pos;

vec3 lon_lat_to_world(vec2 spherical_coordinates) {
	//convert lon lat to world coordinates
	float x = radius * sin(PI + spherical_coordinates.y) * cos(spherical_coordinates.x);
	float y = radius * sin(PI +  spherical_coordinates.y) * sin(spherical_coordinates.x);
	float z = radius * cos(PI + spherical_coordinates.y);
	
	return vec3(x, y, z);
}

float compute_great_circle(vec3 point1, vec3 point2) {
	float theta = acos(dot(point1, point2) / (distance(point1, vec3(0.0)) * (distance(point2, vec3(0.0)))));
	float l = theta * radius;
	
	return l;
}

float voronoi(vec3 vertex) {
	float min_pt_dist = 10.0;
	float center_threshold = 0.01; //the center of each cell
	float minimum_point_color;

	for (int i = 0; i < num_cells; i++) {
		vec3 center_world = lon_lat_to_world(cell_positions[i]);
		float dist = compute_great_circle(center_world, vertex);
		
		if (dist < min_pt_dist) {
			min_pt_dist = dist;
			minimum_point_color = float(i) / float(num_cells);
		}
	}
	
	if (min_pt_dist < center_threshold) {
		minimum_point_color = 2.0; //give a value more than 1.0 so we can identify the centers
	}
	
	return minimum_point_color;
}

void vertex() {
	//get the world coordinates of the vertex
	world_pos = VERTEX;
}

void fragment() {
	float voronoi = voronoi(world_pos);
	
	if (voronoi >= 1.0) {
		ALBEDO = vec3(1.0, 0.0, 0.0);
	}
	else {
		ALBEDO = vec3(voronoi);
	}
}




//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
