extends CharacterBody3D

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 9.0
@export var gravity: float = 20.0
@export var jump_velocity: float = 6.5

@export var walk_fov: float = 75.0
@export var sprint_fov: float = 85.0
@export var fov_lerp_speed: float = 8.0

func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = jump_velocity

	# Movement input
	var input_dir = Vector2.ZERO
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.y += 1

	input_dir = input_dir.normalized()

	# Sprint
	var is_sprinting := Input.is_key_pressed(KEY_SHIFT) and input_dir != Vector2.ZERO
	var current_speed = walk_speed
	if is_sprinting:
		current_speed = sprint_speed

	# Movement
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	move_and_slide()

	# Camera follow
	$Camera_Controller.position = lerp(
		$Camera_Controller.position,
		position,
		0.13
	)


	


func _on_fallzone_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://level_1.tscn")
