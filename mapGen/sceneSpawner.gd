@tool
extends Node3D


@export var start : bool = false : set = set_start
func set_start(_val: bool):
	generate()

@onready var map = $"../.."
@onready var grid_map = $"../../GridMap"


@onready var treeScene : PackedScene = preload("res://mapGen/sceneGeneration/dead_tree_01.tscn")
@onready var bushScene : PackedScene = preload("res://mapGen/sceneGeneration/dead_bush_02.tscn")
@onready var plainwallScene : PackedScene = preload("res://mapGen/sceneGeneration/plain_wall.tscn")
@onready var brokenwallScene : PackedScene = preload("res://mapGen/sceneGeneration/brokenWall.tscn")



var instances : Array[Node3D] = []


# built world on ready
func _ready():
	clear_instantiations()
	print("WORKING")
	for row in range(-1, map.border_size):
		for col in range(-1, map.border_size):
			var pos : Vector3i = Vector3i(col, 0, row)



# build world on generate
func generate():
	clear_instantiations()
	
	for row in range(-1, map.border_size):
		for col in range(-1, map.border_size):
			var pos : Vector3i = Vector3i(col, 0, row)



## SPAWNERS

# spawn trees on the forest/tree blocks
func spawn_tree(pos: Vector3):
	# create tree + give height
	var tree = treeScene.instantiate()
	pos.y = 0.9
	
	# rand scale
	var scale_tree = randf_range(2, 5)
	tree.scale = Vector3(scale_tree, scale_tree, scale_tree)
	
	# tree position on block
	tree.position = pos
	# rand rotate
	tree.rotate_y(randf_range(-20, 20))
	tree.rotate_x(randf_range(-0.5, 0.5))
	
	# add to instances for clear
	instances.append(tree)
	# create
	add_child(tree)

# spawn bushes on the forest/bush blocks
func spawn_bush(pos: Vector3):
	# create bush + give height
	var bush = bushScene.instantiate()
	pos.y = 0.9
	
	# rand scale
	var scale_bush = randf_range(2, 5)
	bush.scale = Vector3(scale_bush, scale_bush, scale_bush)
	
	# bush position on block
	bush.position = pos
	# rand rotate
	bush.rotate_y(randf_range(-20, 20))
	bush.rotate_x(randf_range(-0.5, 0.5))
	
	# add to instances for clear
	instances.append(bush)
	# create
	add_child(bush)


# spawn broken wall on broken wall blocks
func spawn_broken_wall(_pos: Vector3):
	pass

# spawn normal wall on wall blocks
func spawn_normal_wall(_pos: Vector3):
	pass


## CLEARERS

# clear array of instances
func clear_instantiations():
	print("CLEARING 1")
	for instance in instances:
		instance.queue_free()
	instances.clear()


