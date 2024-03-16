extends Area2D

@export var speed: int = 20
@export var direction: Vector2 = Vector2.UP

func _process(delta):
	#TODO use tweens to make this look nice?
	#TODO could make it look like it travels like a bullet?
	if $RayCast2D.is_colliding():
		# Get the first object we intersected with
		var object = $RayCast2D.get_collider()
		# The line requires local scene coordinates, convert the collision point to local scene
		$Line2D.add_point(to_local($RayCast2D.get_collision_point()))
		if "hit" in object:
			object.hit()
			# TODO add particle effects?
	else:
		$Line2D.add_point(Vector2.RIGHT*100000)




# Hit either an enemy or structure
func _on_body_entered(body):
	print(body)


## Delete the bullet if we hit nothing
func _on_bullet_lifetime_timeout():
	queue_free()
