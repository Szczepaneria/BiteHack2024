extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed('ui_focus_next'): set_cells_terrain_connect([local_to_map(get_local_mouse_position())], 0, 0, true)
