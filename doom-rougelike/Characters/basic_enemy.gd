extends CharacterBody3D
class_name EnemyCharacter3D

const SPEED = 5.0

@export var enemy_name := ""
@export var hp := 100

@export var floating_text_scene: PackedScene = preload("res://Characters/DamageLabel.tscn")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
var player: Node3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node3D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_instance_valid(player):
		look_at(player.global_position)
		navigation_agent_3d.target_position = player.global_position

	if not navigation_agent_3d.is_navigation_finished():
		var next_path_pos := navigation_agent_3d.get_next_path_position()
		var direction := global_position.direction_to(next_path_pos)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



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
