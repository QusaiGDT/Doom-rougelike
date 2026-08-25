extends Node

const IMP = preload("uid://cokrj0yjmgi7g")
const PINKY = preload("res://Characters/pinky/Pinky.tscn")
const LARGE_PINKY = preload("uid://brf2ymcp64p76")
var enemies := {IMP : 1, PINKY : 3,LARGE_PINKY : 8}


const GUN = preload("uid://b2bivfao7due4")
const UZI = preload("res://Weapons/Uzi/Uzi.tscn")
const SHOTGUN = preload("uid://dvg1ejake8eeb")
var guns := {UZI : 2,GUN : 1,
SHOTGUN : 3,}

const BASIC_DAMAGE = preload("res://effects/basic damage.tscn")
const BASIC_FIRE_RATE = preload("res://effects/basic FireRate.tscn")
const CANNON = preload("res://effects/Cannon.tscn")
const GAMBLING_ADDECTION = preload("uid://blwawg0dx8toq")
const POISION = preload("uid://dkyxhoaofjfsv")
const BLEED = preload("uid://demoifar2uko8")
var mods := {BASIC_DAMAGE : 3,BASIC_FIRE_RATE : 1,
CANNON : 5, GAMBLING_ADDECTION: 3,POISION:3,BLEED:2,}


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
