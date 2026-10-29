extends Area2D

@export_file("*.tscn") var target_scene: String = "res://scenes/level_boss.tscn"
@export var require_equipment: bool = true

func interact() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if not player:
		return
		
	if require_equipment and player.inventory.size() == 0:
		player.notify("PORTAL TERKUNCI", "Kamu membutuhkan [Chip NAND] dari monster penjaga sebelum bisa masuk ke Ruangan Boss!")
		return
		
	get_tree().change_scene_to_file(target_scene)
