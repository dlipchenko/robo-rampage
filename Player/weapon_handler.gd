extends Node3D

@export var weapon_1: Node3D
@export var weapon_2: Node3D

func _ready() -> void:
	equip(weapon_1)

func equip(active_weapon: Node3D) -> void:
	for child in get_children():
		if child == active_weapon:
			child.visible = true
			child.set_process(true)
			child.ammo_handler.update_ammo_label(child.ammo_type)
		else: 
			child.visible = false
			child.set_process(false)
			
func get_weapon_ammo() -> AmmoHandler.ammo_type:
	return get_child(get_current_index()).ammo_type
	
func cycle_weapon(selection := 1) -> void:
	var index = get_current_index()
	index = wrapi(index + selection, 0, get_child_count())
	
	equip(get_child(index))
	

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("weapon_1"):
		equip(weapon_1)
	elif Input.is_action_just_pressed("weapon_2"):
		equip(weapon_2)
	elif Input.is_action_pressed("weapon_next"):
		cycle_weapon(1)
	elif Input.is_action_pressed("weapon_previous"):
		cycle_weapon(-1)

func get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible:
			return index
	return 0
