extends Node

var tick_damage: float
var tick_rate: float
var time_left: float

var _timer: float = 0.0

func setup(dmg: float, rate: float, dur: float) -> void:
	tick_damage = dmg
	tick_rate = rate
	time_left = dur
	_timer = tick_rate

func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0.0:
		queue_free()
		return
		
	_timer -= delta
	if _timer <= 0.0:
		_timer = tick_rate
		_tick_enemy()

func _tick_enemy() -> void:
	var enemy = get_parent()
	if is_instance_valid(enemy) and enemy.has_method("damage"):
		enemy.damage(tick_damage)
