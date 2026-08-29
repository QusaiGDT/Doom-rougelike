extends Node

var enemies := {
	"res://Characters/Imp/Imp.tscn": 3,
	"res://Characters/pinky/Pinky.tscn": 8,
	"res://Characters/Large pinky/Large Pinky.tscn": 14
}

var guns := {
	"res://Weapons/Uzi/Uzi.tscn": 2,
	"res://Weapons/Basic gun/Gun.tscn": 1,
	"res://Weapons/Shotgun/Shotgun.tscn": 2,
	"res://Weapons/Axe/Axe.tscn": 3
}

var mods := {
	"res://effects/basic damage.tscn": 3,
	"res://effects/basic FireRate.tscn": 1,
	"res://effects/Cannon.tscn": 5,
	"res://effects/Poision.tscn": 3,
	"res://effects/Gambling addection.tscn": 3,
	"res://effects/Bleed.tscn": 2
}

var point_budget := 10
var room_number := 1: 
	set(value):
		room_number = value
		point_budget = round(10.0 * pow(1.55, room_number - 1))
		room_cleared.emit()

signal room_cleared

func get_roster(budget: int, costs: Dictionary) -> Array[PackedScene]:
	var roster: Array[PackedScene] = []
	var remaining_points := budget
	
	while remaining_points > 0:
		var affordable = get_affordable_items(remaining_points, costs)
		if affordable.is_empty():
			break
			
		var chosen_path: String = affordable.pick_random()
		remaining_points -= costs[chosen_path]
		roster.append(load(chosen_path) as PackedScene)
		
	return roster

func get_affordable_items(budget: int, item_costs: Dictionary) -> Array[String]:
	var affordable: Array[String] = []
	for item_path in item_costs.keys():
		if item_costs[item_path] <= budget:
			affordable.append(item_path as String)
	return affordable
