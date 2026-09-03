extends StatModBase

func _ready() -> void:
	SignalBus.fired.connect(effect)

func effect():
	flat_damage -= 2
	description = "+" + str(flat_damage) + " damage, loses 2 per shot fired"
	if flat_damage <= 0:
		flat_damage = 0
