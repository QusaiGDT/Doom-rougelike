extends EnemyCharacter3D

@onready var ray_cast_3d: RayCast3D = $RayCast3D

@export var fire_rate := 0.25
@export var attack_damage := 10

var can_shoot: bool = true

func _process(_delta: float) -> void:
	if ray_cast_3d.is_colliding():
		if ray_cast_3d.get_collider() == player and can_shoot:
			shoot()

func shoot() -> void:
	can_shoot = false
	if ray_cast_3d.get_collider() == player:
		ray_cast_3d.get_collider().damage(attack_damage)
	
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
