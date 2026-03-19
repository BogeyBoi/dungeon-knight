extends Area2D

@onready var player = get_tree().get_nodes_in_group("player")[0]
	
func _on_body_entered(body: Node2D) -> void:
	player.coins += 1
	queue_free()
