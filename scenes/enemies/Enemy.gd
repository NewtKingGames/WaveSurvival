extends CharacterBody2D
class_name Enemy

var vulnerable: bool = true


func _on_timer_timeout():
	vulnerable = true
