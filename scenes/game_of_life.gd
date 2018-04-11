extends Node2D

var grid = {}

export var width = 10
export var height = 10
export var cell_size = 32
export var spawn_rate = 50
var spacer = 5

var start_position
var step_timer

var cell = preload("res://scenes/cell.tscn")

func _ready():
	randomize()
	start_position = get_node("StartPosition")
	step_timer = get_node("StepTimer")
	initialize_grid()
	randomize_grid()
	step_timer.connect("timeout", self, "_on_step_timer_timeout")

func initialize_grid():
	for y in height:
		for x in width:
			var new_cell = cell.instance()
			new_cell.initialize_tile(x,y)
			new_cell.rect_position = (Vector2(start_position.position.x + x*(cell_size+spacer), start_position.position.y + y*(cell_size+spacer)))
			add_child(new_cell)
			grid[Vector2(x,y)] = new_cell
			
func randomize_grid():
	for y in height:
		for x in width:
			var cell = grid[Vector2(x,y)]
			if rand_range(1,101) <= spawn_rate:
				cell.set_type(0)
			else:
				cell.set_type(1)
				
func get_living_neighbors(cell):
	var living_neighbors = 0
	for i in range(-1,2):
		for j in range(-1,2):
			var x = cell.x+i
			var y = cell.y+j
			if i == 0 and j == 0:
				pass
			elif x >= 0 and x <=width-1 and y >=0 and y <=height-1:
				if grid[Vector2(x,y)].get_type() == 0:
					living_neighbors += 1
					
	return living_neighbors
	
func step():
	var types = []
	for y in height:
		for x in width:
			cell = grid[Vector2(x,y)]
			var living_neighbors = get_living_neighbors(cell)
			if cell.get_type() == 0:
				if living_neighbors < 2 or living_neighbors > 3:
					types.append(1)
				elif living_neighbors == 2 or living_neighbors == 3:
					types.append(0)
			elif living_neighbors == 3:
				types.append(0)
			else:
				types.append(1)
				
	var index = 0
	for y in height:
		for x in width:
			grid[Vector2(x,y)].set_type(types[index])
			index+=1
			
func _on_step_timer_timeout():
	step()