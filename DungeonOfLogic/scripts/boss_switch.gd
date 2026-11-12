extends Area2D

@export var is_active: bool = false
@onready var visual: ColorRect = $SwitchVisual
@onready var label: Label = $Label

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	update_visual()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		toggle()

func toggle() -> void:
	is_active = !is_active
	update_visual()

func update_visual() -> void:
	if visual:
		visual.color = Color(0.2, 0.9, 0.2) if is_active else Color(0.9, 0.2, 0.2)
	if label:
		label.text = "INPUT: 1" if is_active else "INPUT: 0"
