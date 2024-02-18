extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("zoom_in"):
		size -= 0.1
	if Input.is_action_just_released("zoom_out"):
		size += 0.1
		
func _input(event):
	pass
