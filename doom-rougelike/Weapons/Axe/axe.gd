extends WeaponBase

@export var bleed_damage = 20

const BLEED = preload("uid://demoifar2uko8")

var _base_bleed_mod: DOTEffect

func _ready() -> void:
	_base_bleed_mod = BLEED.instantiate() as DOTEffect
	if is_instance_valid(_base_bleed_mod):
		_base_bleed_mod.damage_per_tick = bleed_damage
		add_child(_base_bleed_mod)

func _shoot() -> void:
	$AnimationPlayer.stop()
	for body in $Area3D.get_overlapping_bodies():
		
		if body and body.is_in_group("damagable") and not body.is_in_group("player"):
			body.damage(calculate_shot_damage())
			
			if is_instance_valid(_base_bleed_mod):
				_base_bleed_mod.apply_dot(body)
				for mod in active_mods:
					if is_instance_valid(mod) and mod is DOTEffect:
						mod.apply_dot(body)
	
	var anim_length: float = $AnimationPlayer.get_animation("Shoot").length
	var speed: float = anim_length / get_fire_rate()
	$AnimationPlayer.play("Shoot", -1, speed)
