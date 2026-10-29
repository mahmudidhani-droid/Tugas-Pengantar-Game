extends CanvasLayer

@onready var hp_bar: ProgressBar = $TopPanel/HPBar
@onready var stats_label: Label = $TopPanel/StatsLabel
@onready var dialog_panel: Panel = $DialogPanel
@onready var dialog_text: Label = $DialogPanel/DialogLabel

var message_sequence: int = 0

func _ready() -> void:
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