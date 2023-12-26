extends Marker3D

class_name CameraPlayer

@export var player_transform: Node3D
@export var controller_sensitivity: float
@export var mouse_sensitivity: float

@onready var pivot = $Pivot

func _process(delta):
	# sempre seguir o player
	position = player_transform.position
	
	# aplica rotação pelo controle
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_axis("look_right", "look_left")
	axis_vector.y = Input.get_axis("look_down", "look_up")
	if InputEventJoypadMotion:
		rotate_y(deg_to_rad(axis_vector.x) * controller_sensitivity)
		pivot.rotate_x(deg_to_rad(axis_vector.y) * controller_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-75), deg_to_rad(75))

func _unhandled_input(event):
	# captura o mouse quando estiver na tela do game
	if event.is_action_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# mostra o mouse quando socilicitado
	if event.is_action_pressed("pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# aplica rotação pelo mouse
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-75), deg_to_rad(75))
