extends Node2D

signal bullet_shot(pos, direction)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# TODO - see if you even want to implement reloading
func reload():
	print("reloading")

func shoot(direction: Vector2):
	print("shoot")
	bullet_shot.emit(global_position, direction)
