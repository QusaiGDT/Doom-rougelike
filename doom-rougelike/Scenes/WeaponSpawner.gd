extends Node3D

func create_weapon() -> void:
	@warning_ignore("integer_division")
	var budget: int = AutoLoad.point_budget / 10
	
	var affordable_guns: Array[PackedScene] = AutoLoad.get_affordable_items(budget, AutoLoad.guns)
	if affordable_guns.is_empty():
		return
		
	var chosen_weapon_scene: PackedScene = affordable_guns.pick_random()
	var weapon_cost: int = AutoLoad.guns[chosen_weapon_scene]
	var base: WeaponBase = chosen_weapon_scene.instantiate() as WeaponBase
	
	var remaining_budget: int = budget - weapon_cost
	var mod_roster: Array[PackedScene] = AutoLoad.get_roster(remaining_budget, AutoLoad.mods)
	
	for mod_scene in mod_roster:
		var mod_instance = mod_scene.instantiate()
		base.add_child(mod_instance)
		base.active_mods.append(mod_instance)
	
	var holder = $"../Player/Camera3D/Weapon holder/"
	for child in holder.get_children():
		child.queue_free()
	holder.add_child(base)
