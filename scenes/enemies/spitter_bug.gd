extends Enemy

signal bug_spat(pos, direction)

@export var speed: int = 100
var is_attacking: bool = false
var health: int = 100

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
		queue_free()
