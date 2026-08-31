extends StatModBase

func _ready() -> void:
	SignalBus.enemy_killed.connect(effect)

func effect(enemy):
	if enemy == "Pinky":
		damage_mult += 0.1
	description = "x0.1 damage per Pinky killed, currently x" + str(damage_mult)
