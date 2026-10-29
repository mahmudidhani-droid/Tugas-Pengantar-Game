extends Area2D

signal state_changed(new_state: bool)

@export var switch_name: String = "Input"
@export var is_active: bool = false
@export var state_label_vertical_offset: float = -32.0

# ---------------------------------------------------------------------------
# PENGATURAN ASET OTOMATIS:
# Anda bebas mengganti nama file di bawah ini atau menimpa file gambarnya
# di folder asset tanpa perlu menyentuh kode program lagi!
# ---------------------------------------------------------------------------
@export_dir var asset_folder: String = "res://assets/Dungeon_of_Logic_Split_Sprites/01_Auto_Cutouts/08_Interactive_Objects/"
@export var sprite_off_filename: String = "08_Interactive_Objects_sprite_001.png"
@export var sprite_on_filename: String = "08_Interactive_Objects_sprite_002.png"

@onready var sprite: Sprite2D = $Sprite2D
@onready var state_label: Label = get_node_or_null("StateLabel")

func _ready() -> void:
	if state_label:
		state_label.offset_top = state_label_vertical_offset
		state_label.offset_bottom = state_label_vertical_offset + 23.0
	update_visual()

func interact() -> void:
	is_active = !is_active
	update_visual()
	state_changed.emit(is_active)

func update_visual() -> void:
	if sprite:
		# Menggabungkan folder dan nama file secara otomatis saat game berjalan
		var path_off = asset_folder.path_join(sprite_off_filename)
		var path_on = asset_folder.path_join(sprite_on_filename)
		
		var tex_off = load(path_off) as Texture2D
		var tex_on = load(path_on) as Texture2D
		
		if tex_off and tex_on:
			sprite.texture = tex_on if is_active else tex_off
		
		sprite.modulate = Color(0.4, 1.0, 0.5) if is_active else Color(1.0, 0.5, 0.5)
		
	if state_label:
		var bit_val := "1 (ON)" if is_active else "0 (OFF)"
		state_label.text = "%s: %s" % [switch_name, bit_val]
