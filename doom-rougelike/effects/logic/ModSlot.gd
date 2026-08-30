extends Button

var slot_index: int
var current_weapon: WeaponBase

@onready var weapon_label: Label = $"../../../Mod label"

func _ready() -> void:
	mouse_entered.connect(_show_description.bind(true))
	mouse_exited.connect(_show_description.bind(false))

func _show_description(state: bool) -> void:
	if state and slot_index < current_weapon.active_mods.size():
		var mod = current_weapon.active_mods[slot_index]
		weapon_label.text = mod.description
	else:
		weapon_label.text = ""

func _get_drag_data(_at_position: Vector2) -> Variant:
	if slot_index >= current_weapon.active_mods.size():
		return null
		
	var preview = Label.new()
	preview.text = text
	set_drag_preview(preview)
	
	return {"source_index": slot_index}


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("source_index")

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var source_idx: int = data["source_index"]
	var mods: Array = current_weapon.active_mods
	
	if source_idx == slot_index:
		return
		
	var moved_mod = mods.pop_at(source_idx)
	
	if slot_index >= mods.size():
		mods.append(moved_mod)
	else:
		mods.insert(slot_index, moved_mod)
		
	$"../..".setup_mod_buttons(current_weapon)
