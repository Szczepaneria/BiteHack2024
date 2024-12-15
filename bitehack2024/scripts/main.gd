extends Node
@onready var curtain: ColorRect = $Curtain
@export var fade_out_time: float = .25

#func curtain_fade_out() -> void:
	#var tween: Tween = create_tween()
	#tween.tween_property(curtain, 'modulate:a', .0, fade_out_time)
	#await tween.finished

func _ready() -> void:
	#curtain_fade_out()
	var window = get_window()
	window.move_to_center()
	window.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_cancel")): get_tree().quit()
