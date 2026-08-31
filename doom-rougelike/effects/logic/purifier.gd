extends StatModBase

func _ready() -> void:
	SignalBus.enemy_killed.connect(effect)

func effect(enemy):
	if enemy == "Imp":
		flat_damage += 2
	description = "+2 damage per Imp killed, currently +" + str(flat_damage)
