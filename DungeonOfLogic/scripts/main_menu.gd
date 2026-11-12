extends Control

@export_file("*.tscn") var start_level_path: String = "res://scenes/level_01.tscn"

@onready var btn_start: Button = $BtnStart

func _ready() -> void:
	btn_start.grab_focus()

func _on_btn_start_pressed() -> void:
	if ResourceLoader.exists(start_level_path):
		Player.reset_progress()
		get_tree().change_scene_to_file(start_level_path)
	else:
		print("Scene level tujuan tidak ditemukan di path: ", start_level_path)

func _on_btn_exit_pressed() -> void:
	get_tree().quit()
