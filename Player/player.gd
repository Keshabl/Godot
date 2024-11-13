extends CharacterBody2D


const SPEED = 180.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var wolf = preload("res://Mobs/wolf.tscn")
@onready var anim = $AnimatedSprite2D
var alive = true
var movable = true
var gold = 0
var direction = 1
var damage = 0
var enemy = null
var rand = randi_range(1, 3)
func _physics_process(delta):
	
	if position.y > 700:
		health -= 100
	
	if health <= 0:
		movable = false
		alive = false
		velocity.y = -100
		match rand:
			1:
				anim.play("death1")
			2:
				anim.play("death2")
			3:
				anim.play("death3")

		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and movable == true:
		velocity.y = JUMP_VELOCITY
		anim.play("jump")

	if Input.is_action_just_pressed("left_mouse") and is_on_floor() and movable == true:
		movable = false
		damage = 50
		velocity = Vector2(0,0)
		if enemy != null:
			enemy.health -= damage
		anim.play("attack1")
		await anim.animation_finished
		movable = true

	if Input.is_action_just_pressed("ctrl") and is_on_floor() and movable == true:
		movable = false
		damage = 30
		velocity = Vector2(0,0)
		if enemy != null:
			enemy.health -= damage
		anim.play("attack2")
		await anim.animation_finished
		movable = true

	if Input.is_action_just_pressed("shift") and is_on_floor() and movable == true:
		movable = false
		damage = 20
		velocity = Vector2(0,0)
		if enemy != null:
			enemy.health -= damage
		anim.play("attack3")
		await anim.animation_finished
		movable = true

	if Input.is_action_just_pressed("ui_down") and is_on_floor() and movable == true:
		self.position.y += 4

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if movable == true:
		direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				anim.play("idle")
	
	if velocity.y < -400:
		velocity.y = -300
	
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
	if velocity.y > 0:
		anim.play("fall")
		movable = true
	
	if alive == true:
		move_and_slide()
	




func _on_animated_sprite_2d_animation_finished():
	if alive == false:
		get_tree().change_scene_to_file("res://Menu/menu.tscn")


func _on_left_attack_body_entered(body):
	if direction == -1:
		enemy = body


func _on_left_attack_body_exited(body):
	if direction == -1:
		enemy = null


func _on_right_attack_body_entered(body):
	if direction == 1:
		enemy = body


func _on_right_attack_body_exited(body):
	if direction == 1:
		enemy = null
