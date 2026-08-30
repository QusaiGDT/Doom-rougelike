extends EnemyCharacter3D

const PROJECTILE = preload("uid://bir5bq313ygi1")

@export var fire_rate: float = 1.5  
@export var projectile_damage: float = 10.0
@export var projectile_speed: float = 10.0

@onready var ray_cast_3d: RayCast3D = $RayCast3D

var can_shoot: bool = true

func _process(_delta: float) -> void:
	if ray_cast_3d.is_colliding():
		if ray_cast_3d.get_collider() == player and can_shoot:
			shoot()

func shoot() -> void:
	can_shoot = false
	
	var proj = PROJECTILE.instantiate() as Node3D
	get_tree().current_scene.add_child(proj)
	
	proj.global_position = ray_cast_3d.global_position
	
	proj.look_at(player.global_position + Vector3(0,1.5,0), Vector3.UP)
	
	proj.damage_amount = projectile_damage
	proj.speed = projectile_speed
	
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
