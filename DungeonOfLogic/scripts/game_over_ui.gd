extends CanvasLayer

@onready var title_label: Label = $Panel/TitleLabel
@onready var sub_label: Label = $Panel/SubLabel
@onready var retry_btn: Button = $Panel/RetryButton
@onready var quit_btn: Button = $Panel/QuitButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	retry_btn.pressed.connect(_on_retry_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)

func setup(is_victory: bool) -> void:
	if is_victory:
		title_label.text = "VICTORY!"
		title_label.modulate = Color(0.2, 1.0, 0.3)
		sub_label.text = "Selamat! Anda berhasil memecahkan Dungeon of Logic!"
	else:
		title_label.text = "GAME OVER"
		title_label.modulate = Color(1.0, 0.2, 0.2)
		sub_label.text = "HP Anda habis. Coba lagi!"
	get_tree().paused = true

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_01.tscn")
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()
