extends StaticBody2D

enum GateType { AND, OR, XOR, NAND }

@export var gate_type: GateType = GateType.AND
@export var switch_a: Area2D
@export var switch_b: Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if switch_a:
		switch_a.state_changed.connect(_on_switch_changed)
	if switch_b:
		switch_b.state_changed.connect(_on_switch_changed)
	evaluate_logic()

func _on_switch_changed(_state: bool) -> void:
	evaluate_logic()

func evaluate_logic() -> void:
	if not switch_a or not switch_b:
		return
		
	var a: bool = switch_a.is_active
	var b: bool = switch_b.is_active
	var is_open: bool = false
	
	match gate_type:
		GateType.AND:
			is_open = a and b
		GateType.OR:
			is_open = a or b
		GateType.XOR:
			is_open = a != b
		GateType.NAND:
			is_open = not (a and b)
			
	collision_shape.set_deferred("disabled", is_open)
	sprite.visible = not is_open
