extends CharacterBody2D

var speed = 100
var direction = 1
var prevdir = 1
var temp = 1
var player_direction_var = 0
var hurt_cooldown : int
var attack_cooldown: int
var health : int = 2

@onready var anim_tree : AnimationTree = get_node("AnimationTree")
@onready var state_machine = anim_tree.get("parameters/playback")
@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var player : CharacterBody2D = get_tree().get_nodes_in_group("player")[0]

func _ready() -> void:
	sprite.z_index = 100
	anim_tree.set("parameters/conditions/player_inside", false)
	anim_tree.set("parameters/conditions/not_player_inside", true)
	anim_tree.set("parameters/conditions/hurt", false)

func _physics_process(delta: float) -> void:
	if get_tree().get_first_node_in_group("player").health == 0:
		sprite.z_index = 0
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	if anim_tree.active == false:
		anim_tree.active = true
		
	if not anim_tree["parameters/conditions/hurt"]:
		player_direction()
		enemy_behaviour()
	if state_machine.get_current_node() == "attacktree":
		velocity = Vector2.ZERO
		
	if anim_tree["parameters/conditions/hurt"]:
		if hurt_cooldown > 0:
			hurt_cooldown -= delta
		else:
			anim_tree.set("parameters/conditions/hurt", false)
			
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	if health == 0:
		free()
	else:
		move_and_slide()

func enemy_behaviour():
	if not anim_tree["parameters/conditions/player_inside"]:
		velocity.x = direction * speed
	if anim_tree["parameters/conditions/player_inside"]:
		velocity.x = 0
		if attack_cooldown == 0:
			anim_tree["parameters/conditions/slash"] = true
			attack_cooldown = 200
	if state_machine.get_current_node() == "attacktree":
		anim_tree["parameters/conditions/slash"] = false
	
func player_direction():
	temp = player.position - position
	if temp.x > 1:
		temp = 1
	else:
		temp = -1
	if not temp == 0.0:
		direction = temp
	if not direction == prevdir:
		self.scale.x *= -1
	prevdir = direction

func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if state_machine.get_current_node() == "attacktree":
		return
	anim_tree.set("parameters/conditions/hurt", true)
	hurt_cooldown = 40
	health -= 1

func _on_detect_area_entered(area: Area2D) -> void:
	anim_tree["parameters/conditions/player_inside"] = true
	anim_tree["parameters/conditions/not_player_inside"] = false


func _on_detect_area_exited(area: Area2D) -> void:
	anim_tree["parameters/conditions/player_inside"] = false
	anim_tree["parameters/conditions/not_player_inside"] = true


func _on_hitbox_area_entered(area: Area2D) -> void:
	pass
