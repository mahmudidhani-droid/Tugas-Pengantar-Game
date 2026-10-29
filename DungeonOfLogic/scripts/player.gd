extends CharacterBody2D

signal stats_changed(hp: int, max_hp: int, atk: int, inventory: Array[String])
signal show_message(title: String, text: String)

static var saved_atk: int = 25
static var saved_hp: int = 100
static var saved_inventory: Array[String] = []

@export var speed: float = 125.0
@export var max_hp: int = 100
@export var attack_damage: int = 25
@export var room_bounds: Rect2 = Rect2(34.0, 34.0, 572.0, 286.0)

var current_hp: int = 100
var is_attacking: bool = false
var is_knocked_out: bool = false
var inventory: Array[String] = []
var facing_direction: Vector2 = Vector2.RIGHT

var walk_frames: Array[Texture2D] = [
	preload("res://assets/Dungeon_of_Logic_Split_Sprites/01_Auto_Cutouts/01_Player_Character_Animations/01_Player_Character_Animations_sprite_001.png"),
	preload("res://assets/Dungeon_of_Logic_Split_Sprites/01_Auto_Cutouts/01_Player_Character_Animations/01_Player_Character_Animations_sprite_002.png"),
	preload("res://assets/Dungeon_of_Logic_Split_Sprites/01_Auto_Cutouts/01_Player_Character_Animations/01_Player_Character_Animations_sprite_003.png"),
	preload("res://assets/Dungeon_of_Logic_Split_Sprites/01_Auto_Cutouts/01_Player_Character_Animations/01_Player_Character_Animations_sprite_004.png")
]
var anim_timer: float = 0.0
var anim_index: int = 0

@onready var interaction_zone: Area2D = $InteractionZone
@onready var attack_zone: Area2D = $AttackZone
@onready var attack_visual: Sprite2D = $AttackZone/AttackVFX
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("player")
	attack_damage = saved_atk
	current_hp = saved_hp
	inventory = saved_inventory.duplicate()
	emit_stats()

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	global_position = global_position.clamp(room_bounds.position, room_bounds.end)
	
	if direction.length() > 0.1:
		if absf(direction.x) > absf(direction.y):
			facing_direction = Vector2.RIGHT if direction.x > 0.0 else Vector2.LEFT
		else:
			facing_direction = Vector2.DOWN if direction.y > 0.0 else Vector2.UP
		sprite.flip_h = facing_direction.x < 0.0
		attack_zone.position = facing_direction * 24.0
		
	if direction.length() > 0.1:
		anim_timer += delta
		if anim_timer >= 0.14:
			anim_timer = 0.0
			anim_index = (anim_index + 1) % walk_frames.size()
			sprite.texture = walk_frames[anim_index]
	else:
		anim_index = 0
		sprite.texture = walk_frames[0]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var closest_area: Area2D
		var closest_distance := INF
		for area in interaction_zone.get_overlapping_areas():
			if area.has_method("interact"):
				var distance := global_position.distance_squared_to(area.global_position)
				if distance < closest_distance:
					closest_area = area
					closest_distance = distance
		if closest_area:
			closest_area.interact()
				
	elif event.is_action_pressed("attack") and not is_attacking:
		perform_attack()

func perform_attack() -> void:
	is_attacking = true
	attack_visual.visible = true
	
	for body in attack_zone.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(attack_damage)
			
	await get_tree().create_timer(0.2).timeout
	attack_visual.visible = false
	is_attacking = false

func take_damage(amount: int) -> void:
	if is_knocked_out or amount <= 0:
		return

	current_hp = max(0, current_hp - amount)
	saved_hp = current_hp
	emit_stats()
	sprite.modulate = Color(1.0, 0.3, 0.3)
	if current_hp <= 0:
		is_knocked_out = true
	await get_tree().create_timer(0.15).timeout
	sprite.modulate = Color(1.0, 1.0, 1.0)
	
	if is_knocked_out:
		current_hp = max_hp
		saved_hp = current_hp
		global_position = Vector2(320, 290)
		is_knocked_out = false
		emit_stats()
		notify("SISTEM", "HP Habis! Kamu dikembalikan ke titik awal ruangan.")

func add_equipment(item_name: String, bonus_atk: int, heal_amount: int) -> void:
	if inventory.has(item_name):
		return

	inventory.append(item_name)
	saved_inventory = inventory.duplicate()
	attack_damage += bonus_atk
	saved_atk = attack_damage
	current_hp = min(max_hp, current_hp + heal_amount)
	saved_hp = current_hp
	emit_stats()
	notify("EQUIPMENT BARU!", "Mendapatkan [%s]! Attack +%d, HP +%d. Portal Boss kini dapat diakses!" % [item_name, bonus_atk, heal_amount])

func notify(title: String, text: String) -> void:
	show_message.emit(title, text)

func emit_stats() -> void:
	stats_changed.emit(current_hp, max_hp, attack_damage, inventory)
