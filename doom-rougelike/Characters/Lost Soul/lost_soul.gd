extends CharacterBody3D

@export var enemy_name := "lost soul"
@export var hp := 20
@export var speed := 8
@export var hit_damage := 20

@export var floating_text_scene: PackedScene = preload("res://Characters/DamageLabel.tscn")

var player : CharacterBody3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player:
		position = position.move_toward(player.global_position,delta * speed)
		look_at(player.global_position)
		if $RayCast3D.is_colliding():
			if $RayCast3D.get_collider() == player:
				player.damage(hit_damage)
				queue_free()

func damage(amount) -> void:
	hp -= amount

	if floating_text_scene:
		var text_instance = floating_text_scene.instantiate()
		get_tree().root.add_child(text_instance)
		text_instance.global_position = global_position + Vector3(0, 1.5, 0)
		text_instance.setup(amount)

	if hp <= 0:
		SignalBus.enemy_killed.emit(enemy_name)
		queue_free()
