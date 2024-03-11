extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/projectiles/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gun_laser_shot(pos, bullet_direction):
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.position = pos
	# Rotate the bullet
	bullet.rotation = bullet_direction.angle()
	bullet.direction = bullet_direction
	$Bullets.add_child(bullet)
