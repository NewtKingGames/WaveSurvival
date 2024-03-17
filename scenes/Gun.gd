extends Node2D

signal bullet_shot(pos, direction)


var shotgun_ammo: int = 12

var active_gun: String = "pistol"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("switch_gun_pistol"):
		active_gun = "pistol"
		print("pistol!!!!")
	if Input.is_action_just_pressed("switch_gun_shotgun"):
		active_gun = "shotgun"
	
# TODO - see if you even want to implement reloading
func reload():
	print("reloading")


func shoot(direction: Vector2):
	if active_gun == "pistol":
		bullet_shot.emit(global_position, direction)
		$"../CharacterAnimatedSprite2D".play("fire")
		$"../Sounds/GunShotSound".play()
	if active_gun == "shotgun":
		print("shotgun shot")
		if shotgun_ammo > 0:
			shotgun_ammo -= 1
		else:
			print("no shotgun ammo")
