extends Enemy

signal bug_spat(pos, direction)
signal spitter_death(pos, direction)

@export var speed: int = 100
var is_attacking: bool = false
var health: int = 30

func _process(delta):
	look_at(Globals.player_position)
	if is_attacking:
		pass
	else:
		var move_direction: Vector2 = (Globals.player_position - global_position).normalized()
		velocity = move_direction * speed
		move_and_slide()

func _on_attack_area_body_entered(body):
	is_attacking = true
	$AnimatedSprite2D.play("Attack")


func _on_attack_area_body_exited(body):
	is_attacking = false
	$AnimatedSprite2D.play("Walk")


func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		# TODO - This would be fun to do in a burst
		#Emit a signal to the level script to generate bug spit
		var bullet_direction = (Globals.player_position - global_position).normalized()
		bug_spat.emit($SpitSpawn.global_position, bullet_direction)

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
