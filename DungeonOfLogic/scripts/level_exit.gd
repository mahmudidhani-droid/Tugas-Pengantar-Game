extends Area2D

@export_file("*.tscn") var next_level_path: String = "res://scenes/level_boss.tscn"
@export var is_locked_by_logic: bool = false

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if is_locked_by_logic:
		return
	if body.is_in_group("player") or body.name == "Player":
		call_deferred("_change_scene")

func _change_scene() -> void:
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
