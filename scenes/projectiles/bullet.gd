extends Area2D

@export var speed: int = 20
@export var direction: Vector2 = Vector2.UP
var has_hit: bool = false

func _process(delta):
	print("bullet shoting")
	if has_hit:
		return
	# TODO use tweens to make this look nice?
	# TODO could make it look like it travels like a bullet?
	# TODO often the point is drawing to a way further point, multiple collisions? See comment on line 20
	if $RayCast2D.is_colliding():
		has_hit = true
		print("is colliding")
		# Get the first object we intersected with
		var object = $RayCast2D.get_collider()
		# The line requires local scene coordinates, convert the collision point to local scene
		$Line2D.add_point(to_local($RayCast2D.get_collision_point()))
		if "hit" in object:
			object.hit()
			# TODO add particle effects?
	else:
		has_hit = true
		print("else block")
		# It's because of this else block and it's probably due to this set of code running in process
		$Line2D.add_point(Vector2.RIGHT*100000)




# Hit either an enemy or structure
func _on_body_entered(body):
	print(body)


## Delete the bullet if we hit nothing
func _on_bullet_lifetime_timeout():
	queue_free()
