extends CharacterBody3D

const SPEED = 10.0          
const ACCEL = 20.0         
const FRICTION = 14.0      
const SENSITIVITY = 0.003  

@onready var camera = $Camera3D

@onready var weapon_label: Label = $"Ui/Weapon label"
@onready var weapon_holder: Node3D = $"Weapon holder"

var current_weapon: WeaponBase = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if weapon_holder.get_child_count() > 0:
		current_weapon = weapon_holder.get_child(0) as WeaponBase
	update_ui()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)

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


func update_ui() -> void:
	if not weapon_label:
		return

	if not is_instance_valid(current_weapon):
		weapon_label.text = "NO WEAPON"
		return

	var text: String = current_weapon.name.to_upper() + "\n "
	
	if current_weapon.description != "":
		text += current_weapon.description + "\n\n"


	if current_weapon.active_mods.is_empty():
		text += "No Modifiers"
	else:
		for mod in current_weapon.active_mods:
			var mod_name = mod.get("mod_name") if "mod_name" in mod else (mod.get("name") if "name" in mod else "Mod")
			var mod_desc = mod.get("description") if "description" in mod else ""
			
			text += "• " + str(mod_name)
			if mod_desc != "":
				text += ": \n " + str(mod_desc)
			text += "\n"

	weapon_label.text = text
