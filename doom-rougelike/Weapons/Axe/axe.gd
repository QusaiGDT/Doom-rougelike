extends WeaponBase

const BLEED = preload("uid://demoifar2uko8")

@onready var ray_cast_3d: RayCast3D = $RayCast3D

var _base_bleed_mod: DOTEffect

func _ready() -> void:
	_base_bleed_mod = BLEED.instantiate() as DOTEffect
	_base_bleed_mod.damage_per_tick = 20
	if _base_bleed_mod:
		add_child(_base_bleed_mod)

func _shoot() -> void:
	if ray_cast_3d.is_colliding():
		var target = ray_cast_3d.get_collider()
		if target and target.is_in_group("damagable"):
			target.damage(calculate_shot_damage())
			
			
			if is_instance_valid(_base_bleed_mod):
				_base_bleed_mod.apply_dot(target)
	

			for mod in active_mods:
				if is_instance_valid(mod) and mod is DOTEffect:
					mod.apply_dot(target)
	
	var anim_length: float = $AnimationPlayer.get_animation("Shoot").length
	var speed: float = anim_length / get_fire_rate()
	$AnimationPlayer.play("Shoot", -1, speed)
