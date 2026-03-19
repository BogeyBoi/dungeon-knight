extends Node2D


func _process(delta: float) -> void:
	pass

func gameStart():
	get_tree().change_scene_to_file("res://world.tscn")

func _on_texture_button_pressed() -> void:
	Global.difficulty = "easy"
	gameStart()

func _on_texture_button_2_pressed() -> void:
	Global.difficulty = "hard"
	gameStart()
