extends Node2D

const enemyscene = preload("res://enemy/enemy.tscn")
const coinscene = preload("res://coin.tscn")
var locations
@onready var timer : Timer = get_node("Timer")
@onready var timer2 : Timer = get_node("Timer2")

func _ready() -> void:
	if Global.difficulty == "easy":
		timer.wait_time = 8
		timer2.wait_time = 4
	if Global.difficulty == "hard":
		timer.wait_time = 5
		timer2.wait_time = 6
	get_node("Node2D").visible = false

func _process(delta: float) -> void:
	if get_tree().get_first_node_in_group("player").health == 0:
		get_node("Node2D").visible = true
		timer.paused = true

func spawnEnemy(randomPosition):
	var enemy = enemyscene.instantiate()
	enemy.position = randomPosition
	get_tree().current_scene.add_child(enemy)
		
func spawnCoin(randomPosition):
	var coin = coinscene.instantiate()
	coin.position = randomPosition
	get_tree().current_scene.add_child(coin)
		
func _on_timer_timeout() -> void:
	locations = get_tree().get_nodes_in_group("spawninglocations")
	spawnEnemy(locations.pick_random().position)
	spawnEnemy(locations.pick_random().position)


func _on_timer_2_timeout() -> void:
	if get_tree().get_first_node_in_group("player").health == 0:
		get_tree().change_scene_to_file("res://titlescreen.tscn")
		return
	spawnCoin(locations.pick_random().position)
