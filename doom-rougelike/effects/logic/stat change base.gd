class_name StatModBase
extends Node

@export var mod_name: String = "Basic Mod"
@export var description: String = "+0% Stat"

# Damage Modifiers
@export_group("Damage")
@export var flat_damage: float = 0.0
@export var damage_mult: float = 1.0

@export_group("Fire rate")
@export var flat_fire_rate: float = 0.0
@export var fire_rate_mult: float = 1.0

@export_group("Crit")
@export var flat_crit_chance: float = 0.0
@export var crit_chance_mult: float = 1.0

@export var flat_crit_mult: float = 0.0
@export var crit_mult_mult: float = 1.0

@export_group("Recoil")
@export var recoil_mult: float = 1.0
