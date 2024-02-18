@tool
extends MeshInstance3D

var surface = mesh.surface_get_material(0)

var num_cells = 20
var position_array = Array()

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(num_cells):
		position_array.append(Vector2(rng.randf_range(-2.0 * PI, 2.0 * PI), rng.randf_range(-PI, PI)))

	surface.set_shader_parameter("cell_positions", position_array)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get a random direction to move the cells
	var rand_dir = Array()
		
	for i in range(num_cells):
		rand_dir = Vector2(rng.randf(), rng.randf())
		position_array[i] += rand_dir * delta / 10.0
		
		if position_array[i].x > 2.0 * PI:
			position_array[i].x = -2.0 * PI
		
		if position_array[i].y > PI:
			position_array[i].y = -PI 
		
	surface.set_shader_parameter("cell_positions", position_array)
