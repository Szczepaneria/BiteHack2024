extends TileMapLayer

var start: Vector2i
var end: Vector2i
var debug: bool = false;

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
@onready var tile_map_layer_2: TileMapLayer = $"../TileMapLayer2"
@onready var tile_map_layer_3: TileMapLayer = $"../TileMapLayer3"

func getSelectedTiles(x0: int, y0: int, x1: int, y1: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for row in range(x0, x1):
		for col in range(y0, y1): # filling cell row,col
			result.append(Vector2i(row, col))
	return result

var offset: int = 0;

func _drawSelection(start: Vector2i, end: Vector2i) -> void:
	var selectionTiles: Array[Vector2i] = []
	var x0: int = start.x
	var y0: int = start.y
	var x1: int = end.x
	var y1: int = end.y
	var size_x: int;
	var size_y: int;
	
	if x0 > x1:
		var swap = x0
		x0 = x1
		x1 = swap
		
	if y0 > y1:
		size_y = y0 - y1;
		var swap = y0
		y0 = y1
		y1 = swap
	
	var x_len = x1 - x0;
	var y_len = y1 - y0;
	
	# check if too small for drawing
	if (x_len >= 2 + offset) and (y_len >= 2 + offset):
		 # Drawing rect from x0, y0 to x1, y1
		selectionTiles = getSelectedTiles(x0, y0, x1, y1)
		clear()
		set_cells_terrain_connect(selectionTiles, 0, 0, false)
		if debug: print("Area selected properly: both sizes are correct.\n")
	else:
		if debug: print("Area not selected: one of the sizes is smaller than 2 on the grid.\n")

func _ready() -> void:
	pass

var currentPosition: Vector2i
var lastPosition: Vector2i
var startPosition: Vector2i
var endPosition: Vector2i
var isInputLocked: bool
var isInputLockerNext: bool

func _process(_delta: float) -> void:
	currentPosition = local_to_map(get_local_mouse_position())
	lastPosition = currentPosition;
	if Input.is_action_just_pressed("ui_focus_next") && !isInputLocked:
		isInputLocked = true
		isInputLockerNext = true
		startPosition = currentPosition # Move stack up pressed: startPosition
	if Input.is_action_just_released("ui_focus_next") && isInputLocked:
		if isInputLockerNext:
			isInputLocked = false # Move stack up released: currentPosition
			_drawSelection(startPosition, lastPosition)
		else:
			isInputLocked = false # Operation canceled!"
	if Input.is_action_just_pressed("ui_focus_prev") && !isInputLocked:
		startPosition = currentPosition
		isInputLocked = true
		isInputLockerNext = false # Move stack down pressed: startPosition
	if Input.is_action_just_released("ui_focus_prev") && isInputLocked:
		if !isInputLockerNext:
			isInputLocked = false # Move stack down released: currentPosition
			_drawSelection(startPosition, lastPosition)
		else:
			isInputLocked = false # Operation canceled!"
