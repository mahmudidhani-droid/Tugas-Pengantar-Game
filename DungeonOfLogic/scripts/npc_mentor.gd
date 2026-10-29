extends Area2D

@export var npc_name: String = "Profesor Logic"

func interact() -> void:
    var player := get_tree().get_first_node_in_group("player")
    if not player:
        return
        
    if player.inventory.size() > 0:
        player.notify(npc_name, "Luar biasa! Kamu berhasil memecahkan perisai XOR dan mendapatkan [%s]! Kamu siap menghadapi Ruangan Boss!" % player.inventory[0])
    else:
        player.notify(npc_name, "Tips Logika: Gerbang AND butuh kedua saklar ON (1 & 1). Sedangkan Perisai XOR monster di atas hanya hancur jika TEPAT SATU saklar menyala (1 & 0)!")