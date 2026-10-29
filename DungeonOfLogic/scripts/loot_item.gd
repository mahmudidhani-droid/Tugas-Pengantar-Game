extends Area2D

@export var item_name: String = "Pedang Algoritma + Chip NAND"
@export var bonus_attack: int = 25
@export var heal_hp: int = 30

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player") and body.has_method("add_equipment"):
        body.add_equipment(item_name, bonus_attack, heal_hp)
        queue_free()