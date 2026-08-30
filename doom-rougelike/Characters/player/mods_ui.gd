extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if visible:
			close_menu()
		else:
			open_menu()

@onready var remove_slot: Control = $"Remove mod"

func setup_mod_buttons(weapon: WeaponBase) -> void:
	if is_instance_valid(remove_slot):
		remove_slot.current_weapon = weapon

	var buttons = $Mods.get_children()
	for i in range(buttons.size()):
		var btn = buttons[i]
		btn.slot_index = i
		btn.current_weapon = weapon
		
		if i < weapon.active_mods.size():
			btn.text = weapon.active_mods[i].mod_name
		else:
			btn.text = "Empty"


func open_menu() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
		
	var weapon_holder = player.get_node_or_null("RecoilNode/Camera3D/Weapon holder")
	if not weapon_holder or weapon_holder.get_child_count() == 0:
		return
		
	var player_weapon = weapon_holder.get_child(0) as WeaponBase
	if not player_weapon:
		return
		
	setup_mod_buttons(player_weapon)
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func close_menu() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false


func _on_mod_button_pressed(weapon: WeaponBase, mod: Node, button: Button) -> void:
	if is_instance_valid(weapon) and mod in weapon.active_mods:
		weapon.active_mods.erase(mod)
		mod.queue_free()
	
	button.hide()
