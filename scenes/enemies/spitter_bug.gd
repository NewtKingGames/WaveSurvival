extends Enemy

signal bug_spat(pos, direction)
signal spitter_death(pos, direction)

@export var speed: int = 100
var is_attacking: bool = false
var health: int = 30

func _ready():
	$AnimatedSprite2D.play("Walk")
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_position

func _physics_process(delta):
	look_at(Globals.player_position)
	if not is_attacking:
		var next_path_pos = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position).normalized()
		velocity = direction * speed
		if not vulnerable:
			## Very hacky way to slow down bug when hit
			velocity = direction * speed / 3
		move_and_slide()


func _on_attack_area_body_entered(body):
	is_attacking = true
	$AnimatedSprite2D.play("Attack")

# We want the disengage area larger than the engage area
func _on_disengage_area_body_exited(body):
	is_attacking = false
	$AnimatedSprite2D.play("Walk")
	


func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		# TODO - This would be fun to do in a burst
		#Emit a signal to the level script to generate bug spit
		$Node/SpitNoise.play()
		var bullet_direction = (Globals.player_position - global_position).normalized()
		bug_spat.emit($SpitSpawn.global_position, bullet_direction)
		$AnimatedSprite2D.play("Attack")

func hit():
	if vulnerable: 
		$Timers/InvulnerableTimer.start()
		vulnerable = false
		health -= 10
	if health <= 0:
		var direction_on_death = (Globals.player_position - global_position).normalized()
		# TODO possibly pass the whole object to the level function and let the level call queue_free?
		# Right now the issue is our signal is triggered before the deletion of the enemy
		# Alternatively we can just track how many enemies were spawned vs how many were killed and if they are equal we end the wave
		# Pursuing that second option for now
		spitter_death.emit(position, direction_on_death)
		queue_free()


func _on_recalculation_timer_timeout():
	$NavigationAgent2D.target_position = Globals.player_position



