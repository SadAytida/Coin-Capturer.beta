extends Area3D

@export var spin_speed: float = 180.0      # degrees per second
@export var bob_height: float = 0.25
@export var bob_speed: float = 4.0

var start_y: float

func _ready():
	start_y = global_position.y

func _process(delta):
	# Spin the coin
	rotation.y += deg_to_rad(spin_speed) * delta

	# Bob up and down
	var offset := sin(Time.get_ticks_msec() / 1000.0 * bob_speed) * bob_height
	global_position.y = start_y + offset

func _on_body_entered(body):
	# Collect coin
	if body is CharacterBody3D:
		# TODO: add score / coin counter here
		queue_free()
