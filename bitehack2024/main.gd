extends Node

var position: Vector2
var lastPosition: Vector2
var firstPosition: Vector2
var isInputLocked: bool
var isInputLockerNext: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position: lastPosition = position;
	position = get_viewport().get_mouse_position()
	if(position != lastPosition && !isInputLocked): print(position)
	if Input.is_action_just_pressed("ui_focus_next") && !isInputLocked:
		isInputLocked = true
		isInputLockerNext = true
		firstPosition = position
		print("Move stack up pressed:", firstPosition)
	if Input.is_action_just_released("ui_focus_next") && isInputLockerNext:
		isInputLocked = false
		print("Move stack up released:", position)
	if Input.is_action_just_pressed("ui_focus_prev") && !isInputLocked:
		firstPosition = position
		isInputLocked = true
		isInputLockerNext = false
		print("Move stack down pressed:", firstPosition)
	if Input.is_action_just_released("ui_focus_prev") && !isInputLockerNext:
		isInputLocked = false
		print("Move stack down released:", position)
