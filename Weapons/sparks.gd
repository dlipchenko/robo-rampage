extends GPUParticles3D
func _ready() -> void:
	one_shot = true
	emitting = true
func on_particles_finished() -> void:
	queue_free()
