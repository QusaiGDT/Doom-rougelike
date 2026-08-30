extends Node3D


var end_of_round := false

func _ready() -> void:
	get_tree().get_first_node_in_group("player").position = $"Player Spawn Position".position
	get_tree().get_first_node_in_group("player").rotation = $"Player Spawn Position".rotation
	
	end_of_round = false
	for enemy in AutoLoad.get_roster(AutoLoad.point_budget,AutoLoad.enemies):
		var spawn_point = $"spawn locations".get_children().pick_random()
		var enemy_inst = enemy.instantiate()
		$Enemies.add_child(enemy_inst)
		enemy_inst.global_position = spawn_point.global_position
		await get_tree().create_timer(0.25).timeout


func _process(_delta: float) -> void:
	if $Enemies.get_child_count() == 0 and not end_of_round:
		end_of_round = true
		AutoLoad.room_number += 1
