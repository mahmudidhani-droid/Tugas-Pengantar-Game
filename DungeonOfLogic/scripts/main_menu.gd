extends Control

@onready var start_btn: Button = $CenterPanel/VBoxContainer/StartButton
@onready var quit_btn: Button = $CenterPanel/VBoxContainer/QuitButton

func _ready() -> void:
	start_btn.pressed.connect(_on_start_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	start_btn.grab_focus()

func _on_start_pressed() -> void:
	var player_script = load("res://scripts/player.gd")
	if player_script:
		player_script.saved_hp = 100
		player_script.saved_atk = 25
		player_script.saved_inventory.clear()
	var error := get_tree().change_scene_to_file("res://scenes/level_01.tscn")
	if error != OK:
		push_error("Gagal memuat level pertama: %s" % error)

func _on_quit_pressed() -> void:
	get_tree().quit()
