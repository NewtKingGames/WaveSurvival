extends Area2D

@export var spit_speed: int = 300
@export var direction: Vector2 = Vector2.UP 

func _process(delta):
	position += direction * spit_speed * delta

func _on_body_entered(body):
	# Current collisions pay attention to player and walls
	if "hit" in body:
		body.hit()
	# Destroy the bullet
	queue_free()

func _on_spit_life_timeout():
	queue_free()
