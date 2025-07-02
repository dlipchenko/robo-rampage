extends CharacterBody3D
class_name Player

const SPEED = 5.0
@export var jump_height: float = 1.0
@export var fall_multiplier: float = 1.1
@export var max_hitpoints := 100
var hitpoints := max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			get_tree().quit()

var mouse_motion := Vector2.ZERO
var sensitivity := 0.001
@onready var camera_pivot: Node3D = $CameraPivot
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	handle_camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		
		velocity += get_gravity() * delta
		if velocity.y < 0:
			velocity.y = velocity.y * fall_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y =  sqrt(jump_height * 2 * abs(get_gravity().y))

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * sensitivity
	elif event is InputEventMouseButton:
		print("InputEventMouseButton")
	elif event.is_action("jump"):
		print("jump")
	elif event.is_action("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x,
		-90.0,
		90.0
	)
	mouse_motion = Vector2.ZERO
