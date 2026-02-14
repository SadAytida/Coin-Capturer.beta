extends CharacterBody3D

# ----- MOVEMENT -----
@export var walk_speed: float = 5.0
@export var sprint_speed: float = 9.0
@export var jump_velocity: float = 4.5
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# ----- MOUSE LOOK -----
@export var mouse_sensitivity: float = 0.1
@export var min_look_angle: float = -90.0
@export var max_look_angle: float = 90.0

# ----- FOV -----
@export var normal_fov: float = 75.0
@export var sprint_fov: float = 90.0
@export var fov_speed: float = 8.0

#bob variables
const BOB_FREQ = 7.0
const BOB_AMP = 0.03
var t_bob = 0.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

var current_speed: float
var mouse_rotation_x := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = normal_fov

#camera
func _input(event):
	if event is InputEventScreenDrag:
		rotate_y(-event.relative.x * 0.01)



func _physics_process(delta):
	# ----- GRAVITY -----
	if not is_on_floor():
		velocity.y -= gravity * delta

	# ----- JUMP -----
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# ----- MOVEMENT INPUT -----
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	)

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# ----- SPRINT -----
	var is_sprinting := Input.is_action_pressed("sprint") and is_on_floor()
	current_speed = sprint_speed if is_sprinting else walk_speed

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	# ----- FOV CHANGE -----
	var target_fov = sprint_fov if is_sprinting else normal_fov
	camera.fov = lerp(camera.fov, target_fov, delta * fov_speed)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()
	
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
