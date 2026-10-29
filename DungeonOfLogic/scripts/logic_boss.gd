extends CharacterBody2D

@export var max_hp: int = 150
@export var move_speed: float = 35.0
@export var contact_damage: int = 20

@export var switch_a: Area2D
@export var switch_b: Area2D
@export var switch_c: Area2D

var current_hp: int = 150
var shield_active: bool = true
var is_defeated: bool = false
var attack_cooldown: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var shield_visual: Sprite2D = $ShieldVisual
@onready var status_label: Label = $StatusLabel

func _ready() -> void:
	current_hp = max_hp
	if switch_a:
		switch_a.state_changed.connect(_on_switch_changed)
	if switch_b:
		switch_b.state_changed.connect(_on_switch_changed)
	if switch_c:
		switch_c.state_changed.connect(_on_switch_changed)
	evaluate_circuit()

func _physics_process(delta: float) -> void:
	if attack_cooldown > 0.0:
		attack_cooldown -= delta
		
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if not player:
		return
		
	var dist := global_position.distance_to(player.global_position)
	if dist < 220.0 and dist > 26.0:
		var dir := (player.global_position - global_position).normalized()
		velocity = dir * move_speed
		move_and_slide()
		if dir.x != 0:
			sprite.flip_h = dir.x < 0
	else:
		velocity = Vector2.ZERO
		
	if dist <= 30.0 and attack_cooldown <= 0.0:
		if player.has_method("take_damage"):
			player.take_damage(contact_damage)
			attack_cooldown = 1.0

func _on_switch_changed(_state: bool) -> void:
	evaluate_circuit()

func evaluate_circuit() -> void:
	if not switch_a or not switch_b or not switch_c:
		return
		
	var a: bool = switch_a.is_active
	var b: bool = switch_b.is_active
	var c: bool = switch_c.is_active
	
	var step_and: bool = a and b
	var circuit_output: bool = step_and != c
	
	shield_active = not circuit_output
	update_ui(a, b, c, step_and, circuit_output)

func take_damage(amount: int) -> void:
	if is_defeated or amount <= 0:
		return

	var player := get_tree().get_first_node_in_group("player")
	if shield_active:
		status_label.text = "PERISAI AKTIF! Selesaikan: (A AND B) XOR C = 1"
		shield_visual.modulate = Color(1.0, 0.2, 0.2, 0.9)
		await get_tree().create_timer(0.4).timeout
		evaluate_circuit()
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
		if player and player.has_method("notify"):
			player.notify("TAMAT!", "Selamat! Core Guardian telah dikalahkan! Kembali ke Main Menu dalam 4 detik...")
		visible = false
		set_physics_process(false)
		await get_tree().create_timer(4.0).timeout
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		evaluate_circuit()

func update_ui(a: bool, b: bool, c: bool, step_and: bool, out: bool) -> void:
	if shield_visual:
		shield_visual.visible = shield_active
		shield_visual.modulate = Color(0.9, 0.3, 1.0, 0.65)
	if status_label:
		var state_str := "PERISAI AKTIF" if shield_active else "PERISAI MATI - SERANG!"
		status_label.text = "CORE GUARDIAN [%s]\n(A:%d AND B:%d)=%d XOR C:%d -> Out:%d\nHP: %d/%d" % [
			state_str, int(a), int(b), int(step_and), int(c), int(out), current_hp, max_hp
		]
