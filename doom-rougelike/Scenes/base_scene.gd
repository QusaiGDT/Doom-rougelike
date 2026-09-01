extends Node3D

var map_pool = [
	"res://Scenes/Map pool/M1.tscn",
]

func _ready() -> void:
	change_maps()

func change_maps():
	var next_map = load(map_pool.pick_random()).instantiate()
	for child in $Map.get_children(): child.queue_free()
	$Map.add_child(next_map)
