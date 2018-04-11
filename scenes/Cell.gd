extends Control

var tile_type
var x
var y

onready var anim = get_node("AnimationPlayer")

func initialize_tile(x, y):
	self.x = x
	self.y = y
	
func set_type(type):
	tile_type = type
	if tile_type == 0:
		anim.play("Living")
	else:
		anim.play("Dead")

func get_type():
	return tile_type