extends WeaponBase

@onready var raycast_container:= $Raycasts

func _shoot() -> void:
	$AnimationPlayer.stop()
	for ray_cast_3d in raycast_container.get_children():
		if ray_cast_3d.is_colliding():
			var collider = ray_cast_3d.get_collider()
			if collider and collider.is_in_group("damagable"):
				collider.damage(calculate_shot_damage())
	
				for mod in active_mods:
					if is_instance_valid(mod) and mod is DOTEffect:
						mod.apply_dot(collider)

	var anim = $AnimationPlayer.get_animation("shoot")
	
	var speed_scale: float = anim.length / get_fire_rate()
	
	$AnimationPlayer.play("shoot", -1, speed_scale)
