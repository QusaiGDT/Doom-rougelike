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
	var missing_hp: float = max(0.0, player.max_hp - player.hp)
	
	@warning_ignore("integer_division")
	var stacks: int = int(missing_hp / 40.0)

	damage_mult = 1.0 + float(stacks)
	
	description = "1x damage per 40HP lost, currently " + str(damage_mult) + "x" 
