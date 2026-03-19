extends CharacterBody2D

const max_speed = 100
const accel = 1500
const friction = 1200
var input = Vector2.ZERO
var direction = 1
var prevdir = 1
var temp = 1
var state = null
var player_input : Vector2
var climb : bool = false
var a
var b

@onready var health : int = 4
@onready var coins : int = 0
@onready var anim_tree : AnimationTree = get_node("AnimationTree")
@onready var state_machine = anim_tree.get("parameters/playback")
@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var hurtbox : Area2D = get_node("hurtbox")

func _ready() -> void:
	sprite.z_index = 100
	add_to_group("player", true)

func _physics_process(delta: float) -> void:
	
	update_state()
	
	hurtbox.monitoring = not (state == "Block")
	if state != "Block" and state != "Slash" and state != "Death":
		player_input = get_input()
		if state != "Climb":
			player_input.y = 0
		player_direction()
	else:
		player_input = Vector2.ZERO
	player_movement(delta, player_input)
	
	climbing()
	
	update_animations()
	
	if not is_on_floor():
		if not climb:
			velocity += get_gravity() * delta
	if health == 0:
		gameOver()
	move_and_slide()
	
func gameOver():
	pass
	
func climbing():
	if climb:
		if Input.is_action_pressed("w"):
			velocity.y = -150
			
func update_state():
	state = state_machine.get_current_node()

func update_animations():
	if anim_tree.active == false:
		anim_tree.active = true
	if Input.is_action_pressed("w"):
		anim_tree.set("parameters/conditions/upward", true)
	else:
		anim_tree.set("parameters/conditions/upward", false)
	if (Input.is_action_just_pressed("click")):
		anim_tree["parameters/conditions/swing"] = true
	else:
		anim_tree["parameters/conditions/swing"] = false
	if Input.is_action_pressed("block"):
		anim_tree["parameters/conditions/block"] = true
	else:
		anim_tree["parameters/conditions/block"] = false
	anim_tree["parameters/conditions/not block"] = !anim_tree["parameters/conditions/block"]
	
func player_direction():
	temp = Input.get_axis("a", "d")
	if not temp == 0.0:
		direction = temp
	if not direction == prevdir:
		self.scale.x *= -1
	prevdir = direction
	
func get_input():
	input = Input.get_vector("a", "d", "w", "s")
	return input.normalized()
	
func player_movement(delta, input):
	if input:
		velocity = velocity.move_toward(input * max_speed, delta * accel)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * friction)
	
	move_and_slide()

func _on_slash_body_entered(body: Node2D) -> void:
	pass

func _on_hurtbox_area_entered(area: Area2D) -> void:
	health -= 1
	if health < 0:
		health = 0

func _on_climb_body_entered(body: Node2D) -> void:
	climb = true
	anim_tree.set("parameters/conditions/climb", true)

func _on_climb_body_exited(body: Node2D) -> void:
	climb = false
	anim_tree.set("parameters/conditions/climb", false)
