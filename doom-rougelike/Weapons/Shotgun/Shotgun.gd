extends WeaponBase

@onready var raycast_container:= $Raycasts

func _shoot() -> void:
	for ray_cast_3d in raycast_container.get_children():
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().is_in_group("damagable"):
				ray_cast_3d.get_collider().damage(calculate_shot_damage())
	
	var anim_length: float = $AnimationPlayer.get_animation("shoot").length
	var speed: float = anim_length / get_fire_rate()
	$AnimationPlayer.play("shoot", -1, speed)
