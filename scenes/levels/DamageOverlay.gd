extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("player_damage", damage_animation)

func damage_animation():
	$AnimationPlayer.play("damage_splatter")
