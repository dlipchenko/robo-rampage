extends CharacterBody3D
class_name Enemy

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: Player
var provoked := false
@export var aggro_range := 22.0
@export var attack_range := 1.5
@export var max_hitpoints := 100
@export var damage := 20
var hitpoints: int = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			queue_free()
		provoked = true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	navigation_agent_3d.target_position = player.global_position
	

func _physics_process(delta: float):
	var next_position = navigation_agent_3d.get_next_path_position()
	var distance = global_position.distance_to(player.global_position)
	var direction = global_position.direction_to(next_position)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if !provoked && distance < aggro_range:
		provoked = true
	elif provoked:
		if direction:
			look_at_target(direction)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
	if distance <= attack_range:
		animation_player.play("Attack")

func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)

func attack() -> void:
	player.hitpoints -= damage
