extends Node2D

var wolf = preload("res://Mobs/wolf.tscn")
var gold = preload("res://Collectibles/Gold.tscn")

func spawn_item(item_type, pos):
	if item_type == "Gold":
		var instance_gold = gold.instantiate()
		instance_gold.position = pos
		var rand = randi_range(-3,3)
		instance_gold.linear_velocity.y = -100
		if rand == 0:
			rand = 1
		instance_gold.linear_velocity.x = 100 * rand
		add_child(instance_gold)

func spawn_mob(mob_type, pos):
	if mob_type == "wolf":
		var instance_wolf = wolf.instantiate()
		instance_wolf.position = pos
		add_child(instance_wolf)
