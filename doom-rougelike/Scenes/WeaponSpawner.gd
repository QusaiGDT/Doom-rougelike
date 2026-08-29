extends Node3D

var weapon_held: Node

func interact() -> void:
	var holder = get_tree().get_first_node_in_group("player").get_node("Camera3D/Weapon holder/")
	var player_weapon = null
	
	if holder.get_child_count() > 0:
		player_weapon = holder.get_child(0)
		holder.remove_child(player_weapon)
	
	if is_instance_valid(weapon_held):
		if weapon_held.get_parent():
			weapon_held.get_parent().remove_child(weapon_held)
		holder.add_child(weapon_held)
		
		weapon_held.position = Vector3.ZERO
		weapon_held.rotation = Vector3.ZERO
		weapon_held.show()
	
	weapon_held = player_weapon
	if is_instance_valid(weapon_held):
		add_child(weapon_held)
		weapon_held.hide() 

func create_weapon() -> void:
	if is_instance_valid(weapon_held):
		weapon_held.queue_free()
		
	@warning_ignore("integer_division")
	var budget: int = AutoLoad.point_budget / 8
	
	var affordable_guns: Array[String] = AutoLoad.get_affordable_items(budget, AutoLoad.guns)
	if affordable_guns.is_empty():
		return
		
	var chosen_weapon_path: String = affordable_guns.pick_random()
	var weapon_cost: int = AutoLoad.guns[chosen_weapon_path]
	
	var chosen_weapon_scene: PackedScene = load(chosen_weapon_path) as PackedScene
	var base: WeaponBase = chosen_weapon_scene.instantiate() as WeaponBase
	
	var remaining_budget: int = budget - weapon_cost
	var mod_roster: Array[PackedScene] = AutoLoad.get_roster(remaining_budget, AutoLoad.mods)
	
	for mod_scene in mod_roster:
		var mod_instance = mod_scene.instantiate()
		base.add_child(mod_instance)
		base.active_mods.append(mod_instance)
	
	weapon_held = base
	add_child(weapon_held)
	weapon_held.hide() 
	show()
	await get_tree().create_timer(10).timeout
