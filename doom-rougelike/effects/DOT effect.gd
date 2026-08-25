extends StatModBase
class_name DOTEffect

@export var damage_per_tick := 3.0
@export var tick_interval := 0.5
@export var duration := 3.0
@export var stackable: bool = false

func apply_dot(target: Node) -> void:
	if not is_instance_valid(target):
		return
		
	var tracker_name: String = str(name)
	if stackable:
		tracker_name += "_" + str(Time.get_ticks_msec())

	var existing_dot = target.get_node_or_null(tracker_name)
	if existing_dot:
		existing_dot.time_left = duration
		return

	var dot_node = Node.new()
	dot_node.set_script(preload("res://effects/dot_ticker.gd"))
	dot_node.name = tracker_name
	
	target.add_child(dot_node)
	dot_node.setup(damage_per_tick, tick_interval, duration)
