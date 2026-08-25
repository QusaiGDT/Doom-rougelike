extends CharacterBody3D

const SPEED = 10.0          
const ACCEL = 20.0         
const FRICTION = 14.0      
const SENSITIVITY = 0.003  

@export var max_hp := 200
@export var hp := 200

@onready var camera = $Camera3D

@onready var weapon_label: Label = $"Ui/Weapon label"
@onready var weapon_holder: Node3D = $"Camera3D/Weapon holder"

var current_weapon: WeaponBase = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if weapon_holder.get_child_count() > 0:
		current_weapon = weapon_holder.get_child(0) as WeaponBase

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact"):
		if $"Camera3D/Interact cast".is_colliding():
			if $"Camera3D/Interact cast".get_collider().is_in_group("Interactable"):
				$"Camera3D/Interact cast".get_collider().interact()
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -deg_to_rad(85), deg_to_rad(85))


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 18.0 * delta

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
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
	
	if weapon_holder.get_child_count() > 0:
		current_weapon = weapon_holder.get_child(0) as WeaponBase
	
	if not weapon_label:
		return

	if not is_instance_valid(current_weapon):
		weapon_label.text = "NO WEAPON"
		return

	var text: String = current_weapon.name.to_upper() + "\n "
	
	if "description" in current_weapon and current_weapon.description != "":
		text += current_weapon.description + "\n\n"

	if current_weapon.active_mods.is_empty():
		text += "No Modifiers"
	else:
		for mod in current_weapon.active_mods:
			if not is_instance_valid(mod):
				continue
				
			var mod_name = mod.get("mod_name")
			if mod_name == null or str(mod_name) == "":
				mod_name = mod.name
			var mod_desc = mod.get("description")
			if mod_desc == null:
				mod_desc = ""
			
			text += "• " + str(mod_name)
			if str(mod_desc) != "":
				text += ": \n " + str(mod_desc)
			text += "\n"

	weapon_label.text = text

func damage(amount):
	hp -= amount
	if hp <= 0: queue_free()
	if hp > max_hp : hp = max_hp
