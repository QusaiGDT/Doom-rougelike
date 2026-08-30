@abstract
extends Node3D
class_name WeaponBase

@export var description := ""

@export var is_auto := false
@export var base_damage := 10.0
@export var base_fire_rate := 0.5 
@export var base_crit_chance := 0.05
@export var base_crit_mult := 2.0
@export var base_recoil := Vector3.ZERO

@export var active_mods: Array[Node] = []

var _fire_timer: float = 0.0

signal fired

func _process(delta: float) -> void:
	if _fire_timer > 0.0:
		_fire_timer -= delta

	var wants_to_shoot := false
	if is_auto:
		wants_to_shoot = Input.is_action_pressed("shoot")
	else:
		wants_to_shoot = Input.is_action_just_pressed("shoot")

	if wants_to_shoot and _fire_timer <= 0.0:
		_fire_timer = maxf(_fire_timer + get_fire_rate(), get_fire_rate())
		_shoot()

@abstract func _shoot() -> void

func get_recoil() -> Vector3:
	var total_recoil: Vector3 = base_recoil
	for mod in active_mods:
		if mod is StatModBase:
			total_recoil *= mod.recoil_mult
	return total_recoil

func calculate_shot_damage() -> float:
	var total_dmg: float = base_damage
	var total_chance: float = base_crit_chance
	var total_crit_m: float = base_crit_mult

	# Process mods in strict index order so placement dictates calculation order
	for mod in active_mods:
		if mod is StatModBase:
			total_dmg = (total_dmg + mod.flat_damage) * mod.damage_mult
			total_chance = (total_chance + mod.flat_crit_chance) * mod.crit_chance_mult
			total_crit_m = (total_crit_m + mod.flat_crit_mult) * mod.crit_mult_mult

	# Apply 10% floor safety
	total_dmg = maxf(total_dmg, base_damage * 0.1)

	var guaranteed_crits: int = int(total_chance)
	var bonus_chance: float = fmod(total_chance, 1.0)
	
	var total_crits: int = guaranteed_crits
	if randf() < bonus_chance:
		total_crits += 1
		
	for i in range(total_crits):
		total_dmg *= total_crit_m
		
	return total_dmg

func get_fire_rate() -> float:
	var total_rate: float = base_fire_rate
	for mod in active_mods:
		if mod is StatModBase:
			total_rate = (total_rate + mod.flat_fire_rate) * mod.fire_rate_mult
	return maxf(total_rate, 0.01)
