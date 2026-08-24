extends WeaponBase

@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _shoot() -> void:
	if ray_cast_3d.is_colliding():
		if ray_cast_3d.get_collider().is_in_group("damagable"):
			ray_cast_3d.get_collider().damage(calculate_shot_damage())
	$AnimationPlayer.play("shoot")
