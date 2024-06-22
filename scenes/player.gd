extends CharacterBody2D

var is_aiming: bool = false
var is_shooting: bool = false
var is_sprinting: bool = false 

var player_aim_walk_speed: int = 100
var player_sprint_speed: int = 400
var player_walk_speed: int = 300


var aim_reticle = load("res://red_crosshair.png")
var mouse_reticle = load("res://cursor.png")

func _process(_delta):
	if is_aiming:
		Input.set_custom_mouse_cursor(aim_reticle)
	else:
		Input.set_custom_mouse_cursor(mouse_reticle)
	look_at(get_global_mouse_position())

	# Grab the direction first so we can use it in the else block and the movement section
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction and not is_aiming and Input.is_action_pressed("sprint"): 
		is_sprinting = true
	else:
		is_sprinting = false
	if Input.is_action_pressed("aim"):
		look_at(get_global_mouse_position())
		if not is_aiming:
			$CharacterAnimatedSprite2D.play("aim")
		is_aiming = true
		if Input.is_action_just_pressed("shoot"):
			print("Shoot")
			is_shooting = true
			var aim_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
			$Gun.shoot(aim_direction)
	else:
		# TODO could play a nice reverse aim animation
		is_aiming = false
		if direction != Vector2.ZERO and is_sprinting:
			look_at(direction + position) # Only look at direction when sprinting?
	
	if is_shooting:
		return
	
	# Calculate player velocity
	var current_speed = 0
	if is_aiming:
		current_speed = player_aim_walk_speed
	elif is_sprinting:
		current_speed = player_sprint_speed
	else:
		current_speed = player_walk_speed
	velocity = direction * current_speed
	if direction != Vector2.ZERO:
		if is_aiming:
			# TODO reconcile this with shooting, right now you can aim and shoot and the animation won't play
			$CharacterAnimatedSprite2D.play("aim_walk")
		elif is_sprinting:
			$CharacterAnimatedSprite2D.play("sprint")
		else:
			# Play walking animation
			$CharacterAnimatedSprite2D.play("walk")
	elif not is_aiming:
		$CharacterAnimatedSprite2D.play("default")
	move_and_slide()
	# Set global player position
	Globals.player_position = position

func hit():
	Globals.player_health -= 10
	$Sounds/HurtSound.play()

func _on_pistol_shot_timer_timeout():
	is_shooting = false
