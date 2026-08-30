extends StatModBase

var player : CharacterBody3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	recalculate_bonuses()

func recalculate_bonuses() -> void:
	if not player:
		damage_mult = 1.0
		return
	
	
	description = "x3 fire rate if HP is between 110 and 130"
	
	if 110 <= player.hp and 130 >= player.hp:
		fire_rate_mult = 0.33
		description += " currently active"
	else : 
		fire_rate_mult = 1.0
		description += " not active"
