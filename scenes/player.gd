extends CharacterBody2D

var player_walk_speed: int = 400
var is_aiming: bool = false
var player_aim_walk_speed: int = 100
var player_sprint_speed: int = 600

func _process(delta):
	# TODO Medium refactor of these nasty booleans
	# Eventually look up animated trees and state machines to see how you can handle this nicer
	# Eventually cleanup the sprites themselves to put the player in a consistent posistion
	if Input.is_action_pressed("aim"):
		if not is_aiming:
			$CharacterAnimatedSprite2D.play("aim")
		is_aiming = true
		# TODO could have the player "frozen" until they have finished aiming and then they can move
		if Input.is_action_just_pressed("shoot"):
			var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
			$Gun.shoot(direction)
	else:
		# TODO could play a nice reverse aim animation
		is_aiming = false
	var direction = Input.get_vector("left", "right", "up", "down")
	var current_speed = player_aim_walk_speed if is_aiming else player_walk_speed
	velocity = direction * current_speed
	if direction:
		if is_aiming:
			# Play aim walking animation
			print("aim walk")
		else:
			# Play walking animation
			$CharacterAnimatedSprite2D.play("walk")
	elif not is_aiming:
		$CharacterAnimatedSprite2D.play("default")
	move_and_slide()
	look_at(get_global_mouse_position())
