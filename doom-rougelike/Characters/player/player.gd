extends CharacterBody3D

const SPEED = 10.0          
const ACCEL = 20.0         
const FRICTION = 14.0      
const SENSITIVITY = 0.003  
const JUMP_ACCEL = 6

@export var max_hp := 200
@export var hp := 200

@onready var camera = $RecoilNode/Camera3D
@onready var interact_cast: RayCast3D = $"RecoilNode/Camera3D/Interact cast"
@onready var weapon_holder: Node3D = $"RecoilNode/Camera3D/Weapon holder"
@onready var mods_ui: Control = $Ui/ModsUI

var current_weapon: WeaponBase = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if weapon_holder.get_child_count() > 0:
		current_weapon = weapon_holder.get_child(0) as WeaponBase

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact"):
		
		if interact_cast.is_colliding():
			if interact_cast.get_collider().is_in_group("Interactable"):
				interact_cast.get_collider().interact()
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -deg_to_rad(85), deg_to_rad(85))


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 12.0 * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_ACCEL

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCEL * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)

	move_and_slide()
	update_ui()


func update_ui() -> void:
	
	
	$Ui/HP.text = str(hp) + "/" + str(max_hp) + "\n"
	$Ui/HP.text +=  "round " + str(AutoLoad.room_number)
	$Ui/HP.text +=  "\nscore " + str(AutoLoad.point_budget)
	
	


func damage(amount):
	hp -= amount
	if hp <= 0: queue_free()
	if hp > max_hp : hp = max_hp
