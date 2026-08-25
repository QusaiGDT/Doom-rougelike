extends Node

const BASIC_ENEMY = preload("res://Characters/Zombie/Basic enemy.tscn")
const PINKY = preload("res://Characters/pinky/Pinky.tscn")
var enemies := {BASIC_ENEMY : 1, PINKY : 3,}


const GUN = preload("uid://b2bivfao7due4")
const UZI = preload("res://Weapons/Uzi/Uzi.tscn")
var guns := {UZI : 2,GUN : 1}

const BASIC_DAMAGE = preload("res://effects/basic damage.tscn")
const BASIC_FIRE_RATE = preload("res://effects/basic FireRate.tscn")
var mods := {BASIC_DAMAGE : 2,BASIC_FIRE_RATE : 1}


var point_budget := 10
var room_number := 1

func get_roster(budget: int, costs: Dictionary) -> Array[PackedScene]:
	var roster: Array[PackedScene] = []
	var remaining_points := budget
	
	while remaining_points > 0:
		var affordable = get_affordable_items(remaining_points, costs)
		if affordable.is_empty():
			break
			
		var chosen_scene = affordable.pick_random()
		remaining_points -= costs[chosen_scene]
		roster.append(chosen_scene)
		
	return roster

func get_affordable_items(budget: int, item_costs: Dictionary) -> Array[PackedScene]:
	var affordable: Array[PackedScene] = []
	for item in item_costs.keys():
		if item_costs[item] <= budget:
			affordable.append(item)
	return affordable
