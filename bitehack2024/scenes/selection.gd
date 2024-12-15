extends TileMapLayer

var start: Vector2i
var end: Vector2i

func drawSelection(start: Vector2i, end: Vector2i) -> void:
	var selectionTiles: Array[Vector2i] = []
	var x0: int = start.x
	var y0: int = start.y
	var x1: int = end.x
	var y1: int = end.y
	
	if x0 > x1:
		var swap = x0
		x0 = x1
		x1 = swap
	if y0 > y1:
		var swap = y0
		y0 = y1
		y1 = swap
	 # Drawing rect from x0, y0 to x1, y1
	
	for row in range(x0, x1):
		for col in range(y0, y1): # filling cell row,col
			selectionTiles.append(Vector2i(row, col))
	clear()
	set_cells_terrain_connect(selectionTiles, 0, 0, false)

# Called when the node enters the scene tree for the first time.
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
	#if(currentPosition != lastPosition && !isInputLocked): print(currentPosition)
	if Input.is_action_just_pressed("ui_focus_next") && !isInputLocked:
		isInputLocked = true
		isInputLockerNext = true
		startPosition = currentPosition # Move stack up pressed: startPosition
	if Input.is_action_just_released("ui_focus_next") && isInputLocked:
		if isInputLockerNext:
			isInputLocked = false # Move stack up released: currentPosition
			drawSelection(startPosition, lastPosition)
		else:
			isInputLocked = false # Operation canceled!"
	if Input.is_action_just_pressed("ui_focus_prev") && !isInputLocked:
		startPosition = currentPosition
		isInputLocked = true
		isInputLockerNext = false # Move stack down pressed: startPosition
	if Input.is_action_just_released("ui_focus_prev") && isInputLocked:
		if !isInputLockerNext:
			isInputLocked = false # Move stack down released: currentPosition
			drawSelection(startPosition, lastPosition)
		else:
			isInputLocked = false # Operation canceled!"
