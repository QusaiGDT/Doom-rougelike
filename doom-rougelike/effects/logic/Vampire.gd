extends StatModBase

@export var hp_effect := 2

var player : CharacterBody3D

func _ready() -> void:
	SignalBus.enemy_killed.connect(effect)
	player = get_tree().get_first_node_in_group("player")

func effect(_enemy):
	player.damage(-hp_effect)
