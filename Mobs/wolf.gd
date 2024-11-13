extends CharacterBody2D

enum {
	SPAWN,
	CHASE,
	ATTACK,
	IDLE,
	DEAD
}

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction
var state = SPAWN
var change_state = true
var attack = false
var health = 50
@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var player = $"../Player/Player"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if health <= 0:
		state = DEAD
	if not is_on_floor():
		velocity.y += gravity * delta
	if change_state == true:
		match state:
			SPAWN:
				spawn_state()
			CHASE:
				chase_state()
			ATTACK:
				change_state = false
				attack_state()
			IDLE:
				idle_state()
			DEAD:
				death_state()

	update_direction()
	move_and_slide()

func update_direction():
	direction = (player.position - self.position).normalized()
	anim.flip_h = direction.x < 0

func _on_detector_body_entered(body):
	if body.name == "Player" and state == IDLE:
		state = CHASE
		await animPlayer.animation_finished

func _on_detector_body_exited(body):
	if body.name == "Player":
		state = IDLE

func death_state():
	change_state = false
	get_parent().spawn_item("Gold", self.position)
	animPlayer.play("death")
	await animPlayer.animation_finished
	queue_free()

func _on_attack_area_body_entered(body):
	if body.name == "Player":
		state = ATTACK
		attack = true

func _on_attack_area_body_exited(body):
	if body.name == "Player":
		state = CHASE
		attack = false

func attack_state():
	print(7683823)
	var rand = randi_range(1, 10)
	match rand:
		1, 2, 3, 4:
			strike_1()
		5, 6, 7, 8:
			strike_2()
		9, 10:
			strike_3()

func strike_1():
	perform_attack("strike1", 30)
	print(1)
func strike_2():
	perform_attack("strike2", 25)
	print(2)
func strike_3():
	perform_attack("strike3", 0, true)
	print(3)

func perform_attack(animation_name, damage, knockback=false):
	velocity.x = 0
	animPlayer.play(animation_name)
	await animPlayer.animation_finished
	if attack:
		if damage > 0:
			player.health -= damage
			give_damage()
		if knockback:
			player.movable = false
			player.velocity.y -= 300
			if $AnimatedSprite2D.flip_h:
				player.velocity.x -= 500
			else:
				player.velocity.x += 500
	change_state = true
		

func give_damage():
	if player.health > 0:
		player.movable = false
		player.velocity.y -= 100
		if $AnimatedSprite2D.flip_h:
			player.velocity.x -= 150
		else:
			player.velocity.x += 150
		player.anim.play("damage")
		player.movable = true

func chase_state():
	change_state = false
	velocity.x = direction.x * SPEED
	animPlayer.play("run")
	change_state = true

func idle_state():
	change_state = false
	velocity.x = 0
	animPlayer.play("idle")
	change_state = true

func spawn_state():
	change_state = false
	animPlayer.play("spawn")
	await animPlayer.animation_finished
	state = IDLE
	change_state = true
