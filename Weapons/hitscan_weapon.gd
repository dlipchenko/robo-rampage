extends Node3D


enum AmmunitionTypes {
	NineMilNato,
	TwelveGauge,
}

@export var damage := 15
@export var rpm := 600
@export var magazine_size := 30
@export var ammunition: AmmunitionTypes = AmmunitionTypes.NineMilNato
@export var recoil_v := 20
@export var recoil_h := 10
@export var weapon_mesh: Node3D
@export var muzzle_flash: GPUParticles3D

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D

var magazine_loaded: int  = magazine_size

func _ready() -> void:
	muzzle_flash.lifetime = clampf(60.0 / rpm, 0.001, 0.2)
	var initial_particle_velocity = clampf(
		rpm / 25.0,
		8,
		1000
	)
	muzzle_flash.process_material.set("initial_velocity",Vector2(initial_particle_velocity, initial_particle_velocity * 1.10) )
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if cooldown_timer.is_stopped():
			shoot()
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)

func shoot() -> void:
	muzzle_flash.restart()
	cooldown_timer.start(60.0 / rpm)
	var collider = ray_cast_3d.get_collider()
	printt("weapon fired", collider)
	if collider is Enemy:
		collider.hitpoints -= damage
	weapon_mesh.position.z += (recoil_h + recoil_v) / 200.0
