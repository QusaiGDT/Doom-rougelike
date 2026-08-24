extends Node3D

const BASIC_ENEMY = preload("res://Characters/Zombie/Basic enemy.tscn")
const PINKY = preload("res://Characters/pinky/Pinky.tscn")


var enemies := {BASIC_ENEMY : 1, PINKY : 3,}

func _ready() -> void:
	
	$"Weapon Spawner".create_weapon()
	
	for enemy in get_enemy_roster(AutoLoad.point_budget,enemies):
		var spawn_point = $"spawn locations".get_children().pick_random()
		var enemy_inst = enemy.instantiate()
		$Enemies.add_child(enemy_inst)
		enemy_inst.global_position = spawn_point.global_position
		await get_tree().create_timer(0.25).timeout

func get_enemy_roster(budget: int, enemy_costs: Dictionary) -> Array[PackedScene]:
	var roster: Array[PackedScene] = []
	var remaining_points := budget
	
	while remaining_points > 0:
		var affordable: Array[PackedScene] = []
		
		for scene in enemy_costs.keys():
			if enemy_costs[scene] <= remaining_points:
				affordable.append(scene)
				
		if affordable.is_empty():
			break
			
		var chosen_scene: PackedScene = affordable.pick_random()
		remaining_points -= enemy_costs[chosen_scene]
		roster.append(chosen_scene)
		
	return roster

func _process(_delta: float) -> void:
	if $Enemies.get_child_count() == 0:
		AutoLoad.room_number += 1
		AutoLoad.point_budget = round(10.0 * pow(1.55, AutoLoad.room_number - 1))
		print("hi")
		_ready()
