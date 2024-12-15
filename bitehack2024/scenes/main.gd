extends Node

@onready var tl1: TileMapLayer = $TileMapLayer
@onready var tl2: TileMapLayer = $TileMapLayer2
@onready var tl3: TileMapLayer = $TileMapLayer3



var tilesBuffer: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window = get_window()
	window.move_to_center()
	window.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_cancel")): get_tree().quit()
	
	
	
