extends ParallaxBackground


var speed = 20



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.x -= speed * delta
