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

func _shoot() -> void:
	pass

func get_recoil() -> Vector3:
	var total_recoil: Vector3 = base_recoil
	for mod in active_mods:
		if mod is StatModBase:
			total_recoil *= mod.recoil_mult
	return total_recoil

func calculate_shot_damage() -> float:
	var total_dmg: float = base_damage
	var total_crit_dmg: float = base_damage * base_crit_mult
	var total_chance: float = base_crit_chance

	for mod in active_mods:
		if mod is StatModBase:
			total_chance = (total_chance + mod.flat_crit_chance) * mod.crit_chance_mult
			
			var pre_mult_dmg = total_dmg + mod.flat_damage
			# New flat damage only gets the base crit multiplier so it escapes previous mega-buffs
			var pre_mult_crit = total_crit_dmg + (mod.flat_damage * base_crit_mult) + (pre_mult_dmg * mod.flat_crit_mult)
			
			total_dmg = pre_mult_dmg * mod.damage_mult
			total_crit_dmg = pre_mult_crit * mod.damage_mult * mod.crit_mult_mult

	total_dmg = maxf(total_dmg, base_damage * 0.1)
	
	# Figure out the true multiplier to use for the dice rolls
	var final_crit_mult: float = 1.0
	if total_dmg > 0:
		final_crit_mult = maxf(total_crit_dmg / total_dmg, 1.0)

	var total_crits: int = int(total_chance)
	if randf() < fmod(total_chance, 1.0):
		total_crits += 1
		
	for i in range(total_crits):
		total_dmg *= final_crit_mult
		
	return total_dmg

func get_fire_rate() -> float:
	var total_rate: float = base_fire_rate
	for mod in active_mods:
		if mod is StatModBase:
			total_rate = (total_rate + mod.flat_fire_rate) * mod.fire_rate_mult
	return maxf(total_rate, 0.01)
