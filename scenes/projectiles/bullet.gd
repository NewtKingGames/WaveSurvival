extends Node2D

@export var speed: int = 20
@export var direction: Vector2 = Vector2.UP
var has_hit: bool = false

func _process(delta):
	if has_hit:
		return
	#await get_tree().create_timer(100).timeout
	# TODO use tweens to make this look nice?
	# TODO could make it look like it travels like a bullet?
	if $RayCast2D.is_colliding():
		has_hit = true
		# Get the first object we intersected with
		var object = $RayCast2D.get_collider()
		# The line requires local scene coordinates, convert the collision point to local scene
		$Line2D.add_point(to_local($RayCast2D.get_collision_point()))
		if "hit" in object:
			object.hit()
			# TODO add particle effects?
	# I ran into a lot of issues with trying to render the bullet shooting off in the distance if we missed,
	# but found the easiest solution was to just add objects with collisions way off in the distance beyond
	# the players view rather than trying to add this logic

## Delete the bullet after the timeout
func _on_bullet_lifetime_timeout():
	queue_free()
