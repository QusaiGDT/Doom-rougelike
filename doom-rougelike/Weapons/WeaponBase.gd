@abstract
extends Node3D
class_name WeaponBase

@export var description := ""

@export var is_auto := false
@export var base_damage := 10.0
@export var base_fire_rate := 0.5 
@export var base_crit_chance := 0.05
@export var base_crit_mult := 2.0

@export var active_mods: Array[Node] = []

var _fire_timer: float = 0.0


func _process(delta: float) -> void:
	
	if _fire_timer > 0.0:
		_fire_timer -= delta

	var wants_to_shoot := false
	if is_auto:
		wants_to_shoot = Input.is_action_pressed("shoot")
	else:
		wants_to_shoot = Input.is_action_just_pressed("shoot")

	if wants_to_shoot and _fire_timer <= 0.0:
		_fire_timer = get_fire_rate()
		_shoot()

@abstract func _shoot() -> void

func get_damage() -> float:
	var total_dmg = base_damage
	for mod in active_mods:
		if mod is StatModBase:
			total_dmg *= mod.damage_mult
	return maxf(total_dmg, base_damage * 0.1)

func get_fire_rate() -> float:
	var total_rate = base_fire_rate
	for mod in active_mods:
		if mod is StatModBase:
			total_rate *= mod.fire_rate_mult
	return total_rate

func get_crit_chance() -> float:
	var total_crit = base_crit_chance
	for mod in active_mods:
		if mod is StatModBase:
			total_crit += mod.bonus_crit_chance
	return total_crit

func get_crit_mult() -> float:
	var total_crit = base_crit_mult
	for mod in active_mods:
		if mod is StatModBase:
			total_crit += mod.bonus_crit_mult
	return total_crit

func calculate_shot_damage() -> float:
	var dmg = get_damage()
	var chance = get_crit_chance()
	var base_crit_m = get_crit_mult()
	
	var guaranteed_crits: int = int(chance) 
	
	var bonus_chance: float = fmod(chance, 1.0)
	
	var total_crits: int = guaranteed_crits
	if randf() < bonus_chance:
		total_crits += 1
		
	for i in range(total_crits):
		dmg *= base_crit_m
		
	return dmg
