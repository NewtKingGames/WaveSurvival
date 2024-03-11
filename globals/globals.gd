extends Node

signal stat_change
var player_max_health: int = 200
var player_vulnerable: bool = true

var player_position: Vector2 = Vector2.ZERO

var player_health: int = 200:
	set(value):
		if value < player_health:
			if player_vulnerable:
				player_health = value
				player_vulnerable = false
				player_invulnerable_timer()
				# TODO add some visual/audio indicator
		else:
			player_health = min(value, player_max_health)
		stat_change.emit()

func player_invulnerable_timer():
	await get_tree().create_timer(.5).timeout
	player_vulnerable = true
