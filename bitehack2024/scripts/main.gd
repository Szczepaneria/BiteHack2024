extends Node

func _ready() -> void:
	var window = get_window()
	window.move_to_center()
	window.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_cancel")): get_tree().quit()
