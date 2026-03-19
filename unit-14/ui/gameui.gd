extends Control


@onready var sprite : AnimatedSprite2D = get_node("health/AnimatedSprite2D")
@onready var label : Label = get_node("coins/Amount")
var visible_health : int = 4
var score : int = 0

func _process(delta: float) -> void:
	visible_health = get_tree().get_nodes_in_group("player")[0].health
	sprite.play(str(visible_health))
	score = get_tree().get_nodes_in_group("player")[0].coins
	label.text = str(score)
