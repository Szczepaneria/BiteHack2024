extends Control

@export var load_scene: PackedScene
@export var in_time: float = .5
@export var fade_in_time: float = 1.5
@export var pause_time: float = 1.5
@export var fade_out_time: float = 1.5
@export var out_time: float = .5
@onready var splash_screen_container: CenterContainer = $"."

var splash_screens: Array

func get_splash_screens() -> void:
	splash_screens = splash_screen_container.get_children()
	for screen in splash_screens: screen.modulate.a = 0.0

func fade() -> void:
	for screen in splash_screens:
		var tween = self.create_tween()
		tween.tween_interval(in_time)
		tween.tween_property(screen, "modulate:a", 1.0, fade_in_time)
		tween.tween_interval(pause_time)
		tween.tween_property(screen, "modulate:a", 0.0, fade_out_time)
		tween.tween_interval(out_time)
		await tween.finished
	get_tree().change_scene_to_packed(load_scene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed(): get_tree().change_scene_to_packed(load_scene)

func _ready():
	get_splash_screens()
	fade()
