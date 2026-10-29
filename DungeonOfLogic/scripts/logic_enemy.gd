extends CharacterBody2D

enum ShieldGate { AND, OR, XOR, NAND }

@export var max_hp: int = 50
@export var move_speed: float = 42.0
@export var contact_damage: int = 15
@export var shield_gate: ShieldGate = ShieldGate.XOR
@export var switch_a: Area2D
@export var switch_b: Area2D

var current_hp: int = 50
var shield_active: bool = true
var is_defeated: bool = false
var attack_cooldown: float = 0.0
var loot_scene: PackedScene = preload("res://scenes/loot_item.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var shield_visual: Sprite2D = $ShieldVisual
@onready var status_label: Label = $StatusLabel

func _ready() -> void:
    current_hp = max_hp
    if switch_a:
        switch_a.state_changed.connect(_on_switch_changed)
    if switch_b:
        switch_b.state_changed.connect(_on_switch_changed)
    evaluate_shield()

func _physics_process(delta: float) -> void:
    if attack_cooldown > 0.0:
        attack_cooldown -= delta
        
    var player := get_tree().get_first_node_in_group("player") as Node2D
    if not player:
        return
        
    var dist := global_position.distance_to(player.global_position)
    # Kejar pemain jika pemain sudah masuk ke area ruangan atas (jarak < 150px)
    if dist < 150.0 and dist > 20.0:
        var dir := (player.global_position - global_position).normalized()
        velocity = dir * move_speed
        move_and_slide()
        if dir.x != 0:
            sprite.flip_h = dir.x < 0
    else:
        velocity = Vector2.ZERO
        
    # Serang pemain jika bersentuhan dekat
    if dist <= 24.0 and attack_cooldown <= 0.0:
        if player.has_method("take_damage"):
            player.take_damage(contact_damage)
            attack_cooldown = 1.2

func _on_switch_changed(_state: bool) -> void:
    evaluate_shield()

func evaluate_shield() -> void:
    if not switch_a or not switch_b:
        return
        
    var a: bool = switch_a.is_active
    var b: bool = switch_b.is_active
    var puzzle_solved: bool = false
    
    match shield_gate:
        ShieldGate.AND:
            puzzle_solved = a and b
        ShieldGate.OR:
            puzzle_solved = a or b
        ShieldGate.XOR:
            puzzle_solved = a != b
        ShieldGate.NAND:
            puzzle_solved = not (a and b)
            
    shield_active = not puzzle_solved
    update_ui()

func take_damage(amount: int) -> void:
    if is_defeated or amount <= 0:
        return

    if shield_active:
        status_label.text = "KEBAL! Pecahkan Logika XOR!"
        shield_visual.modulate = Color(1.0, 0.2, 0.2, 0.9)
        await get_tree().create_timer(0.4).timeout
        update_ui()
        return
    
    current_hp = max(0, current_hp - amount)
    if current_hp <= 0:
        is_defeated = true
        set_physics_process(false)
        collision_layer = 0
        collision_mask = 0
    sprite.modulate = Color(1.0, 0.3, 0.3)
    await get_tree().create_timer(0.15).timeout
    sprite.modulate = Color(1.0, 1.0, 1.0)

    if is_defeated:
        spawn_loot()
        queue_free()
    else:
        update_ui()

func spawn_loot() -> void:
    if loot_scene and get_parent():
        var loot := loot_scene.instantiate() as Node2D
        loot.global_position = global_position
        get_parent().call_deferred("add_child", loot)

func update_ui() -> void:
    if shield_visual:
        shield_visual.visible = shield_active
        shield_visual.modulate = Color(0.2, 0.7, 1.0, 0.65)
    if status_label:
        var shield_text := "[PERISAI XOR: AKTIF]" if shield_active else "[PERISAI: HANCUR!]"
        status_label.text = "%s\nHP: %d/%d" % [shield_text, current_hp, max_hp]