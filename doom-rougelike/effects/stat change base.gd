class_name StatModBase
extends Node

@export var mod_name: String = "Basic Mod"
@export var description: String = "+0% Stat"
@export var point_value := 2

# Multipliers
@export var damage_mult: float = 1.0
@export var fire_rate_mult: float = 1.0

#Additive Bonuses
@export var bonus_crit_chance: float = 0.0
@export var bonus_crit_mult: float = 0.0
