extends Node3D

@export var max_mods_per_weapon: int = 5
@onready var label_3d: Label3D = $Label3D

var current_mod: Node
var used_this_round: bool = false

func _ready() -> void:
	var chosen_path: String = get_random_mod(AutoLoad.mods)
	
	if not chosen_path.is_empty():
		current_mod = (load(chosen_path) as PackedScene).instantiate()
		
		var label = get_node_or_null("Label3D") as Label3D
		if label:
			label.text = current_mod.mod_name



func interact() -> void:
	if used_this_round or not is_instance_valid(current_mod):
		return

	var holder = get_tree().get_first_node_in_group("player").get_node("RecoilNode/Camera3D/Weapon holder")
	if holder.get_child_count() == 0:
		return
		
	var weapon = holder.get_child(0) as WeaponBase
	
	if weapon.active_mods.size() < max_mods_per_weapon:
		weapon.add_child(current_mod)
		weapon.active_mods.append(current_mod)
		current_mod = null
		used_this_round = true
		label_3d.text = "Empty"



func get_random_mod(mod_dict: Dictionary) -> String:
	var total_weight: int = 0
	for weight in mod_dict.values():
		total_weight += weight

	if total_weight <= 0:
		return ""

	var roll := randi_range(1, total_weight)
	var current_sum: int = 0

	for path in mod_dict:
		current_sum += mod_dict[path]
		if roll <= current_sum:
			return path

	return ""
