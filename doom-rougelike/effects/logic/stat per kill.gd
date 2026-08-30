class_name KillStackMod
extends StatModBase

@export var target_enemy_group: String = "enemies" 
@export var kills_per_stack: int = 5

@export_group("Flat Bonus Per Stack")
@export var stack_flat_damage: float = 0.0
@export var stack_flat_fire_rate: float = 0.0 # Seconds per shot reduction (use negative values for faster shooting)
@export var stack_flat_crit_chance: float = 0.0
@export var stack_flat_crit_mult: float = 0.0

@export_group("Multiplier Bonus Per Stack")
@export var stack_damage_mult: float = 0.0 # e.g. 0.05 for +5% per stack
@export var stack_fire_rate_mult: float = 0.0 # e.g. -0.02 to reduce delay per stack
@export var stack_crit_chance_mult: float = 0.0
@export var stack_crit_mult_mult: float = 0.0
@export var stack_recoil_mult: float = 0.0 # e.g. -0.05 to lower recoil per stack

@export_category("Description")
@export_multiline var base_description: String = "+Stats per enemy killed"

var current_kills: int = 0

func _ready() -> void:
	recalculate_bonuses()
	if SignalBus.has_signal("enemy_killed"):
		SignalBus.enemy_killed.connect(_on_enemy_killed)

func _on_enemy_killed(enemy_type: String) -> void:
	if enemy_type == target_enemy_group:
		current_kills += 1
		recalculate_bonuses()

func recalculate_bonuses() -> void:
	@warning_ignore("integer_division")
	var stacks: int = current_kills / kills_per_stack

	# Flat calculations
	flat_damage = stacks * stack_flat_damage
	flat_fire_rate = stacks * stack_flat_fire_rate
	flat_crit_chance = stacks * stack_flat_crit_chance
	flat_crit_mult = stacks * stack_flat_crit_mult

	# Multiplier calculations (Base 1.0 + stack modifiers)
	damage_mult = 1.0 + (stacks * stack_damage_mult)
	fire_rate_mult = 1.0 + (stacks * stack_fire_rate_mult)
	crit_chance_mult = 1.0 + (stacks * stack_crit_chance_mult)
	crit_mult_mult = 1.0 + (stacks * stack_crit_mult_mult)
	recoil_mult = 1.0 + (stacks * stack_recoil_mult)

	# Appends current stacks to your hand-written Inspector description
	description = "%s (Current Stacks: %d)" % [base_description, stacks]
