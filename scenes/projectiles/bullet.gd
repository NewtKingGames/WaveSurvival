extends Area2D

@export var speed: int = 20
@export var direction: Vector2 = Vector2.UP

func _process(delta):
	print("PROCESS")
	position += direction * speed * delta
	if $RayCast2D.is_colliding():
		# Get the first object we intersected with
		var object = $RayCast2D.get_collider()
		#$Line2D.add_point(object.position - object.global_position)
		#$Line2D.add_point(object.position)
		if "hit" in object:
			object.hit()
			# TODO add a bulllet line here
			# TODO add particle effects?
			#queue_free()
	#print($RayCast2D.is_colliding())a




# Hit either an enemy or structure
func _on_body_entered(body):
	print("Hit")
	print(body)


## Delete the bullet if we hit nothing
func _on_bullet_lifetime_timeout():
	queue_free()
