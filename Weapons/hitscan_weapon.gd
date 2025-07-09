extends Node3D

enum FireMode {
	Automatic,
	SemiAutomatic,
}

@export var damage_multiplier := 1.1
@export var rpm := 600
@export var magazine_size := 30
@export var ammunition_type_name := "9x19FMJ"
var ammunition_type: AmmunitionType
@export var recoil_v := 20
@export var recoil_h := 10
@export var weapon_mesh: Node3D
@export var muzzle_flash: GPUParticles3D
@export var sparks: PackedScene
@export var fire_mode: FireMode = FireMode.SemiAutomatic
@export var ammo_handler: AmmoHandler
@export var ammo_type: AmmoHandler.ammo_type

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D

var magazine_loaded: int  = magazine_size

func _ready() -> void:
	ammunition_type =  Collections.AmmunitionTypes[ammunition_type_name]
	muzzle_flash.lifetime = clampf(60.0 / rpm, 0.001, 0.2)
	var initial_particle_velocity = clampf(
		rpm / 25.0,
		8,
		1000
	)
	muzzle_flash.process_material.set("initial_velocity",Vector2(initial_particle_velocity, initial_particle_velocity * 1.10))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fire_mode == FireMode.Automatic:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	elif fire_mode == FireMode.SemiAutomatic:
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)

func shoot() -> void:
	if ammo_handler.has_ammo(ammo_type):
		ammo_handler.use_ammo(ammo_type)
		muzzle_flash.restart()
		cooldown_timer.start(60.0 / rpm)
		var collider = ray_cast_3d.get_collider()
		var total_damage = ammunition_type.damage * damage_multiplier
		if ray_cast_3d.is_colliding():
			if collider is Enemy:
				collider.hitpoints -= total_damage
			weapon_mesh.position.z += (recoil_h + recoil_v) / 200.0 * ammunition_type.kick_multiplier
			
			#generate sparks
			var spark = sparks.instantiate() as GPUParticles3D
			spark.lifetime = total_damage / 100.0
			spark.amount = total_damage
			add_child(spark)
			spark.global_position = ray_cast_3d.get_collision_point()
