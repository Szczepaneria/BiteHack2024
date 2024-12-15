extends TileMapLayer

var start: Vector2i
var end: Vector2i

@onready var root = $".."
var timelines: Array[TileMapLayer]

func get_timelines() -> Array[TileMapLayer]:
	var result: Array[TileMapLayer] = []
	# Pobranie dzieci z węzła "root" z filtrowaniem na podstawie meta "is_timeline"
	var tile_map_layer_nodes: Array[Node] = root.get_children().filter(func(child): return child.has_meta("is_timeline"))
	
	# Mapowanie i rzutowanie na TileMapLayer
	for node in tile_map_layer_nodes:
		if node is TileMapLayer:
			result.append(node as TileMapLayer)
	
	return result


func get_tiles_terrains(tiles_coords: Array[Vector2i], timeline: TileMapLayer) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for tile_coords in tiles_coords:
		var tile_data: TileData = timelines[0].get_cell_tile_data(tile_coords)
		var terrain_set: int = tile_data.terrain_set
		var terrain: int = tile_data.terrain
		result.append(Vector2i(terrain_set, terrain))
	return result

func shift(tiles_coords: Array[Vector2i], shift_to_next: bool = true):
	print("Shifting ", "next" if shift_to_next else "prev", " on ", tiles_coords)
	var begin: int; var end: int
	var shelve: Array[Vector2i] = get_tiles_terrains(tiles_coords, timelines[0 if shift_to_next else -1])
	if shift_to_next: begin = 1; end = timelines.size()-1
	else: begin = timelines.size()-1; end = 1
	var index: int = 0
	#for index: int in range(begin, end, 1 if shift_to_next else -1):
	while index < end if shift_to_next else index > end:
		index += 1
		var current_timeline: Array[Vector2i] = get_tiles_terrains(tiles_coords, timelines[index])
		for tile_coords in tiles_coords:
			var terrain_set = timelines[index].get_cell_tile_data(tile_coords).terrain_set
			var terrain = timelines[index].get_cell_tile_data(tile_coords).terrain
			timelines[index-1 if shift_to_next else index+1].set_cells_terrain_connect([tile_coords], terrain_set, terrain, false)
	for tile_coords in tiles_coords:
		var terrain_set = timelines[index].get_cell_tile_data(tile_coords).terrain_set
		var terrain = timelines[index].get_cell_tile_data(tile_coords).terrain
		timelines[0 if shift_to_next else -1].set_cells_terrain_connect([tile_coords], terrain_set, terrain, false)
		

func get_selected_tiles_coords(x0: int, y0: int, x1: int, y1: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	print("ranges: x: ", x0, "-", x1, " = ", abs(x0-x1), "; y: ", y0, "-", y1, " = ", abs(y0-y1), " ::: ", abs(y0-y1)*abs(x0-x1))
	for row in range(x0, x1):
		for col in range(y0, y1): # filling cell row,col
			result.append(Vector2i(row, col))
	print("final")
	print(result)
	return result

func normalize(start: Vector2i, end: Vector2i) -> Vector4i:
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
	return Vector4i(x0, y0, x1, y1)

func drawSelection(start: Vector2i, end: Vector2i) -> void:
	var selectionTiles: Array[Vector2i] = []
	var normalized: Vector4i = normalize(start, end)
	var x0: int = normalized.x
	var y0: int = normalized.y
	var x1: int = normalized.z
	var y1: int = normalized.w
	 # Drawing rect from x0, y0 to x1, y1
	
	selectionTiles = get_selected_tiles_coords(x0, y0, x1, y1)
	clear()
	set_cells_terrain_connect(selectionTiles, 0, 0, false)

func _ready() -> void:
	timelines = get_timelines()

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
			drawSelection(startPosition, lastPosition)
			var flat: Vector4i = normalize(startPosition, endPosition)
			var a: int = flat.x
			var b: int = flat.y
			var c: int = flat.z
			var d: int = flat.w
			shift(get_selected_tiles_coords(startPosition.x, startPosition.y, lastPosition.x, lastPosition.y))
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
			shift(get_selected_tiles_coords(startPosition.x, startPosition.y, lastPosition.x, endPosition.y), false)
		else:
			isInputLocked = false # Operation canceled!"
