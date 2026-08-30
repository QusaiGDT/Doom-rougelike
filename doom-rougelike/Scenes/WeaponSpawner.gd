extends Node3D

@export var max_mods_per_weapon: int = 5
@onready var label_3d: Label3D = $Label3D

var current_mod: Node
var used_this_round: bool = false

func _ready() -> void:
	@warning_ignore("integer_division")
	var budget: int = AutoLoad.point_budget / 8
	var affordable: Array[String] = AutoLoad.get_affordable_items(budget, AutoLoad.mods)
	
	if not affordable.is_empty():
		var path = affordable.pick_random()
		current_mod = (load(path) as PackedScene).instantiate()
		label_3d.text = current_mod.mod_name

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
