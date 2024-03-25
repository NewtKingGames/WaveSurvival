extends Enemy

@export var speed: int = 100
var hitback_speed: int = 200
var health: int = 30
signal roach_death(death_position, direction)

func _ready():
	# Set Distance to stop at
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_position

func _physics_process(delta):
	var next_path_pos = $NavigationAgent2D.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	velocity = direction * speed
	
	# Changing how we look at player since the skeleton faces up
	look_at(Globals.player_position)
	if not vulnerable:
		## Very hacky way to push the enemies back
		direction = (global_position - Globals.player_position).normalized()
		velocity = direction * speed
	move_and_slide()


func hit():
	if vulnerable:
		# TODO - need to implement a damage system that allows us to pass numbers
		health -= 10
		vulnerable = false
		$Timers/InvulnerableTimer.start()
	if health <= 0:
		# TODO - can move this function to shared helper
		var direction_on_death = (Globals.player_position - global_position).normalized()
		roach_death.emit(position, direction_on_death)
		queue_free()
		


func _on_recalculate_timer_timeout():
	$NavigationAgent2D.target_position = Globals.player_position
