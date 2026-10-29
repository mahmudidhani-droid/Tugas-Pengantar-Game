extends Area2D

@export var trap_damage: int = 20
@export var control_switch: Area2D

var is_hazard_active: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var trap_label: Label = $TrapLabel

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    if control_switch:
        control_switch.state_changed.connect(_on_switch_changed)
    evaluate_not_gate()

func _on_switch_changed(_state: bool) -> void:
    evaluate_not_gate()

func evaluate_not_gate() -> void:
    var input_val: bool = control_switch.is_active if control_switch else false
    # Gerbang NOT (Inverter): Jika Saklar OFF (0) -> Jebakan AKTIF (1). Jika Saklar ON (1) -> Jebakan MATI (0).
    is_hazard_active = not input_val
    
    if sprite:
        sprite.modulate = Color(1.0, 0.25, 0.25, 1.0) if is_hazard_active else Color(0.2, 1.0, 0.35, 1.0)
    if trap_label:
        var out_str := "1 (BAHAYA!)" if is_hazard_active else "0 (AMAN)"
        trap_label.add_theme_color_override("font_color", Color(1.0, 0.5, 0.5) if is_hazard_active else Color(0.3, 1.0, 0.5))
        trap_label.text = "JEBAKAN [NOT]\nOut: %s" % out_str

func _on_body_entered(body: Node2D) -> void:
    if is_hazard_active and body.is_in_group("player"):
        if body.has_method("take_damage"):
            body.take_damage(trap_damage)
        if body.has_method("notify"):
            body.notify("JEBAKAN GERBANG NOT!", "Kamu terkena jebakan! Nyalakan Saklar NOT (Input = 1) agar Output menjadi 0 (Aman)!")