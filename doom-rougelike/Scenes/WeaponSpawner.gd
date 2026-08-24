extends Node3D

const GUN = preload("uid://b2bivfao7due4")
const UZI = preload("res://Weapons/Uzi/Uzi.tscn")

var guns := [UZI,GUN]

const BASIC_DAMAGE = preload("res://effects/basic damage.tscn")
const BASIC_FIRE_RATE = preload("res://effects/basic FireRate.tscn")

var mods := {BASIC_DAMAGE : 2,BASIC_FIRE_RATE : 2}


func get_mod_roster(budget: int, mod_costs: Dictionary) -> Array[PackedScene]:
	var roster: Array[PackedScene] = []
	var remaining_points := budget
	
	while remaining_points > 0:
		var affordable: Array[PackedScene] = []
		
		for scene in mod_costs.keys():
			if mod_costs[scene] <= remaining_points:
				affordable.append(scene)
				
		
		if affordable.is_empty():
			break
			
		
		var chosen_scene: PackedScene = affordable.pick_random()
		remaining_points -= mod_costs[chosen_scene]
		roster.append(chosen_scene)
		
	return roster

func create_weapon() -> void:
	# Instantiate the base gun
	var base: WeaponBase = guns.pick_random().instantiate() as WeaponBase
	
	@warning_ignore("integer_division")
	var budget: int = AutoLoad.point_budget / 10
	var mod_roster: Array[PackedScene] = get_mod_roster(budget, mods)
	
	for mod_scene in mod_roster:
		var mod_instance = mod_scene.instantiate()
		
		base.add_child(mod_instance)
		
		base.active_mods.append(mod_instance)
	
	for child in $"../Player/Camera3D/Weapon holder/".get_children():
		child.queue_free()
	$"../Player/Camera3D/Weapon holder/".add_child(base)
