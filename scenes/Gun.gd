extends Node2D


const gun_ray_length: int = 1000

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
	bullet_shot.emit(global_position, direction)
	# Old raycast solution that I'm not going to use anymore
	#var space_state = get_world_2d().direct_space_state
	#var shoot_query = PhysicsRayQueryParameters2D.create(global_position, direction*gun_ray_length)
	#var result = space_state.intersect_ray(shoot_query)
	#print(result)
