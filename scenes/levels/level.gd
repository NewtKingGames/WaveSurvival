extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/projectiles/bullet.tscn")
var roach_body_scene: PackedScene = preload("res://scenes/decorations/gore/roach_dead_body.tscn")
var roach_enemy: PackedScene = preload("res://scenes/enemies/roach.tscn")
var bug_spit: PackedScene = preload("res://scenes/projectiles/bug_spit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		# TODO going to need to refactor this signal to be generic and pass in the type of enemy
		if "roach_death" in enemy:
			enemy.connect("roach_death", _on_roach_death)
		if "bug_spat" in enemy:
			enemy.connect("bug_spat", _on_bug_spat)

# TODO - Consider subscribing to signals from enemies to place blood splatters on the ground when they're hit
func _on_roach_death(pos: Vector2, direction: Vector2):
	#Instantiate a sprite 2D of the dead body at this position
	var dead_body = roach_body_scene.instantiate() as Sprite2D
	dead_body.position = pos
	# I don't know if direction is correct, we might actually want the roation
	dead_body.rotation = direction.angle() - 90
	$Gore.add_child(dead_body)


func _on_gun_bullet_shot(pos, bullet_direction):
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.position = pos
	# Rotate the bullet
	bullet.rotation = bullet_direction.angle()
	bullet.direction = bullet_direction
	$Bullets.add_child(bullet)

func _on_bug_spat(pos, spit_direction):
	var spit = bug_spit.instantiate() as Area2D
	spit.position = pos
	spit.rotation = spit_direction.angle()
	spit.direction = spit_direction
	$Bullets.add_child(spit)
