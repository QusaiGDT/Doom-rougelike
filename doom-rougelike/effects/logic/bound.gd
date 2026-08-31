extends StatModBase


var shots := 0

func _ready() -> void:
	SignalBus.fired.connect(effect)

func effect():
	shots += 1
	if shots == 6:
		flat_crit_chance = 100
		shots = 0
	flat_crit_chance = 0
