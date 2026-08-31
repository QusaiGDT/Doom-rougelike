extends StatModBase

func _ready() -> void:
	SignalBus.enemy_killed.connect(effect)

func effect(_enemy):
	flat_damage -= 5
	description = "+" + str(flat_damage) + " damage, loses 5 per enemy killed"
