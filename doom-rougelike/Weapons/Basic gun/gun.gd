extends WeaponBase

@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _shoot() -> void:
	if ray_cast_3d.is_colliding():
		if ray_cast_3d.get_collider().is_in_group("damagable"):
			ray_cast_3d.get_collider().damage(calculate_shot_damage())
	
			for mod in active_mods:
				if is_instance_valid(mod) and mod is DOTEffect:
					mod.apply_dot(ray_cast_3d.get_collider())
	
	var anim_length: float = $AnimationPlayer.get_animation("shoot").length
	var speed: float = anim_length / get_fire_rate()
	$AnimationPlayer.play("shoot", -1, speed)
