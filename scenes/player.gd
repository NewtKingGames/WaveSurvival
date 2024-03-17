extends CharacterBody2D

var player_walk_speed: int = 400
var is_aiming: bool = false
var player_aim_walk_speed: int = 100
var player_sprint_speed: int = 600

func _process(_delta):
	# TODO Medium refactor of these nasty booleans
	# TODO look up animated trees and state machines to see how you can handle this nicer
	# Eventually cleanup the sprite images themselves to put the player in a consistent posistion
	# Grab the direction first so we can use it in the else block and the movement section
	var direction = Input.get_vector("left", "right", "up", "down")
	#$CharacterAnimatedSprite2D.play("shoot")
	if Input.is_action_pressed("aim"):
		look_at(get_global_mouse_position())
		if not is_aiming:
			$CharacterAnimatedSprite2D.play("aim")
		is_aiming = true
		# TODO could have the player "frozen" until they have finished aiming and then they can move
		if Input.is_action_just_pressed("shoot"):
			print("Shoot")
			var aim_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
			$Gun.shoot(aim_direction)
	else:
		# TODO could play a nice reverse aim animation
		# If we are not aiming face the player in the direction we are moving
		is_aiming = false
		if direction != Vector2.ZERO:
			look_at(direction + position)
	# Calculate player velocity
	var current_speed = player_aim_walk_speed if is_aiming else player_walk_speed
	velocity = direction * current_speed
	if direction != Vector2.ZERO:
		if is_aiming:
			# TODO reconcile this with shooting, right now you can aim and shoot and the animation won't play
			$CharacterAnimatedSprite2D.play("aim_walk")
		else:
			# Play walking animation
			$CharacterAnimatedSprite2D.play("walk")
	elif not is_aiming:
		$CharacterAnimatedSprite2D.play("default")
	move_and_slide()
	# Set global player position
	Globals.player_position = position
