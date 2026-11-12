extends Area2D

signal state_changed(new_state: bool)

@export var switch_name: String = "Input"
@export var is_active: bool = false
@export var state_label_vertical_offset: float = -32.0
@export var show_switch_visual: bool = true

# ---------------------------------------------------------------------------
# PENGATURAN ASET OTOMATIS:
# Anda bebas mengganti nama file di bawah ini atau menimpa file gambarnya
# di folder asset tanpa perlu menyentuh kode program lagi!
# ---------------------------------------------------------------------------
@export_dir var asset_folder: String = "res://assets/Dungeon_of_Logic_Split_Sprites/01_Auto_Cutouts/14_Provided_AssetPack/03_Interaktif/"
@export var sprite_off_filename: String = "03_Interaktif_sprite_004.png"
@export var sprite_on_filename: String = "03_Interaktif_sprite_003.png"

@onready var sprite: Sprite2D = $Sprite2D
@onready var state_label: Label = get_node_or_null("StateLabel")

func _ready() -> void:
	is_active = false # Memaksa semua saklar mulai dari 0 (OFF) saat game berjalan
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
		sprite.visible = show_switch_visual
		# Menggabungkan folder dan nama file secara otomatis saat game berjalan
		var path_off = asset_folder.path_join(sprite_off_filename)
		var path_on = asset_folder.path_join(sprite_on_filename)
		
		var tex_off = load(path_off) as Texture2D
		var tex_on = load(path_on) as Texture2D
		
		if tex_off and tex_on:
			sprite.texture = tex_on if is_active else tex_off
			sprite.region_enabled = true
			sprite.region_rect = Rect2(0.0, 0.0, 29.0, 38.0)
		
		sprite.modulate = Color.WHITE
		
	if state_label:
		var bit_val := "1 (ON)" if is_active else "0 (OFF)"
		state_label.text = "%s: %s" % [switch_name, bit_val]
