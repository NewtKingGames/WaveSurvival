extends Node2D

# Projectiles
var bullet_scene: PackedScene = preload("res://scenes/projectiles/bullet.tscn")
var bug_spit: PackedScene = preload("res://scenes/projectiles/bug_spit.tscn")
# Gore
var roach_body_scene: PackedScene = preload("res://scenes/decorations/gore/roach_dead_body.tscn")
# Enemies
var roach_enemy: PackedScene = preload("res://scenes/enemies/roach.tscn")
var spitter_enemy: PackedScene = preload("res://scenes/enemies/spitter_bug.tscn")


# Enemy spawn variables @onready is needed to initialize them
@onready var spawn_points: Array = [$EnemySpawnPoints/NorthSpawn, $EnemySpawnPoints/EastSpawn, $EnemySpawnPoints/SouthSpawn, $EnemySpawnPoints/WestSpawn]
var spawn_roaches: int = 3
var spawn_spitters: int = 3

# Notes on enemy spawn system
# 1. We need to have some initial spawning of enemies 
# 2. The game should be aware of when all of the enemies are gone
#    a. this could be checked in _process() or we could rely on checks in the _on_enemy_killed() functions
# 3. When all enemies are elimated we need to bump the total amount of enemies we want to spawn by some amount (this should be exponential)
# 4. The spawning of enemies should be split between different points on the map will be utilizing markers, will probably need to randomize it slightly as well to prevent collision bodies spawning on top of eachother
# 5. It'd be nice to have some visual indicators - A Light would be sweet by each of the spawn points



# Called when the node enters the scene tree for the first time.
func _ready():
	print(spawn_points)
	connect_enemy_signals()
	spawn_enemies()
	# Connect the nested player gun bullet shot
	$Player/Gun.connect("bullet_shot", _on_gun_bullet_shot)

func spawn_enemies():
	print("Spawning wave")
	# Instantiate enemies
	# TODO Enemies don't move around eachother smoothly, will want some kind of pathfinding or basic method where they avoid eachother
	for n in spawn_roaches:
		var selected_spawn: Marker2D = pick_random_spawn()
		var spawned_roach = roach_enemy.instantiate() as CharacterBody2D
		spawned_roach.position = generate_spawn_position(selected_spawn)
		$Enemies.add_child(spawned_roach)
	for n in spawn_spitters:
		var selected_spawn: Marker2D = pick_random_spawn()
		var spawned_spitter = spitter_enemy.instantiate() as CharacterBody2D
		spawned_spitter.position = generate_spawn_position(selected_spawn)
		$Enemies.add_child(spawned_spitter)
	# Connect enemy signals - TODO optimzation could be done to connect them as we spawn them
	connect_enemy_signals()
	
func generate_spawn_position(point: Marker2D) -> Vector2:
	# Return a point within a 100 px radius of the marker 2D
	var x_variance: float = randf_range(-100, 100)
	var y_variance: float = randf_range(-100, 100)
	var vector_variance = Vector2(x_variance, y_variance)
	return point.position + vector_variance

func pick_random_spawn() -> Marker2D:
	return spawn_points.pick_random()

func connect_enemy_signals():
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
	# TODO theres room to get these angle closer lined up
	dead_body.rotation = direction.angle() - 90
	$Gore.add_child(dead_body)

func _on_spitter_death(pos: Vector2, direction: Vector2):
	print("spitter dead")

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
