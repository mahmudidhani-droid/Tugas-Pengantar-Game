extends CanvasLayer

@onready var hp_bar: ProgressBar = $TopPanel/HPBar
@onready var stats_label: Label = $TopPanel/StatsLabel
@onready var dialog_panel: Panel = $DialogPanel
@onready var dialog_text: Label = $DialogPanel/DialogLabel

var message_sequence: int = 0
var hp_fill_style: StyleBoxFlat

func _ready() -> void:
	var hp_background := StyleBoxFlat.new()
	hp_background.bg_color = Color(0.035, 0.055, 0.09, 0.95)
	hp_background.set_corner_radius_all(3)
	hp_background.set_border_width_all(1)
	hp_background.border_color = Color(0.25, 0.48, 0.68, 1)
	hp_bar.add_theme_stylebox_override("background", hp_background)

	hp_fill_style = StyleBoxFlat.new()
	hp_fill_style.bg_color = Color(0.2, 0.82, 0.38, 1)
	hp_fill_style.set_corner_radius_all(3)
	hp_bar.add_theme_stylebox_override("fill", hp_fill_style)

	await get_tree().process_frame
	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.stats_changed.connect(_on_player_stats_changed)
		player.show_message.connect(_on_show_message)
		player.emit_stats()

func _on_player_stats_changed(hp: int, max_hp: int, atk: int, inv: Array[String]) -> void:
	if hp_bar:
		hp_bar.max_value = max_hp
		hp_bar.value = hp
		var hp_ratio: float = float(hp) / max_hp if max_hp > 0 else 0.0
		if hp_ratio <= 0.25:
			hp_fill_style.bg_color = Color(0.9, 0.16, 0.16, 1)
		elif hp_ratio <= 0.5:
			hp_fill_style.bg_color = Color(1.0, 0.58, 0.12, 1)
		else:
			hp_fill_style.bg_color = Color(0.2, 0.82, 0.38, 1)
		hp_bar.queue_redraw()
	if stats_label:
		var item_str := ", ".join(inv) if inv.size() > 0 else "Belum ada"
		stats_label.text = "HP: %d/%d  |  ATK: %d  |  Equipment: %s" % [hp, max_hp, atk, item_str]

func _on_show_message(speaker: String, message: String) -> void:
	if dialog_panel and dialog_text:
		message_sequence += 1
		var current_sequence := message_sequence
		dialog_panel.visible = true
		dialog_text.text = "[%s]: %s" % [speaker, message]
		await get_tree().create_timer(6.0).timeout
		if current_sequence == message_sequence:
			dialog_panel.visible = false
