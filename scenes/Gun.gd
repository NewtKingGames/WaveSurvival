extends Node2D

signal bullet_shot(pos, direction)


var shotgun_ammo: int = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("switch_gun_pistol"):
		Globals.equipped_weapon = "pistol"
	if Input.is_action_just_pressed("switch_gun_shotgun"):
		Globals.equipped_weapon = "shotgun"
	
# TODO - see if you even want to implement reloading
func reload():
	print("reloading")


func shoot(direction: Vector2):
	if Globals.equipped_weapon == "pistol":
		bullet_shot.emit(global_position, direction)
		$"../CharacterAnimatedSprite2D".play("fire")
		$"../Sounds/GunShotSound".play()
	if Globals.equipped_weapon == "shotgun":
		print("shotgun shot")
		if shotgun_ammo > 0:
			shotgun_ammo -= 1
		else:
			print("no shotgun ammo")
