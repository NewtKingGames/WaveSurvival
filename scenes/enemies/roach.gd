extends Enemy

var speed: int = 100
var health: int = 30

signal roach_death(death_position, direction)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(Globals.player_position)
	# Calculate movement
	var direction = (Globals.player_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()


func hit():
	print("Hit bug")
	if vulnerable:
		# TODO - need to implement a damage system
		health -= 10
		vulnerable = false
		$Timers/InvulnerableTimer.start()
	if health <= 0:
		# TODO - can move this function to shared helper
		var direction_on_death = (Globals.player_position - global_position).normalized()
		roach_death.emit(position, direction_on_death)
		queue_free()
		
