extends Node3D


var currentRotation : Vector3
var targetRotation : Vector3


@export var recoil : Vector3
@export var aimRecoil : Vector3


@export var snappiness : float
@export var returnSpeed : float


func _process(delta):
	
	targetRotation = lerp(targetRotation, Vector3.ZERO, returnSpeed * delta)
	currentRotation = lerp(currentRotation, targetRotation, snappiness * delta)
	
	rotation = currentRotation
	
	if recoil.z == 0 and aimRecoil.z == 0:
		global_rotation.z = 0

func recoilFire(isAiming : bool = false):
	if isAiming:
		targetRotation += Vector3(aimRecoil.x, randf_range(-aimRecoil.y, aimRecoil.y), randf_range(-aimRecoil.z, aimRecoil.z))
	else:
		targetRotation += Vector3(recoil.x, randf_range(-recoil.y, recoil.y), randf_range(-recoil.z, recoil.z))

func setRecoil(newRecoil : Vector3):
	recoil = newRecoil

func setAimRecoil(newRecoil : Vector3):
	aimRecoil = newRecoil


func _on_weapon_holder_child_entered_tree(node: Node) -> void:
	if node is WeaponBase:
		node.fired.connect(recoilFire)
		setRecoil(node.get_recoil())
