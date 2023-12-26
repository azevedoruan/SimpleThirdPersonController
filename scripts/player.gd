extends CharacterBody3D

class_name Player

@export var max_speed: float
@export var rotation_speed: float
@export var acceleration: float
@export var jump_impulse: float
@export var gravity_force: float
@export var camera_transform: Node3D

@onready var pivot = $Pivot

func _physics_process(delta):
	# get vector input
	var input_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# get direction from camera transform
	var direction = (input_vector.x * camera_transform.transform.basis.x) + (input_vector.y * camera_transform.transform.basis.z)
	
	# apply movement
	velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
	velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
	
	# direciona o player para a direção do movimento
	if input_vector.length() > 0:
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-velocity.x, -velocity.z), rotation_speed * delta)
	
	# apply gravity
	# o método is_on_floor() irá considerar o que é um chão quando este tiver um ângulo de inclinação de até 45 graus.
	# Planos com inclinção maior que isso não será cosniderado um chão. Será aplicado a gravidade.
	if not is_on_floor():
		velocity.y += gravity_force * delta
		velocity.y = clamp(velocity.y, gravity_force, jump_impulse)
	
	# apply jump
	# se o botão foi dado apenas um toque, o impulso será apenas a metade
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2
	
	move_and_slide()
