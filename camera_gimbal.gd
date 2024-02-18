extends Node3D

var mouse_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mouse_click"):
		mouse_pressed = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_released("mouse_click"):
		mouse_pressed = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if mouse_pressed:
		if event is InputEventMouseMotion:
			rotate_object_local(Vector3.UP, event.relative.x * 0.01)
			rotate_object_local(Vector3.RIGHT, event.relative.y * 0.01)
