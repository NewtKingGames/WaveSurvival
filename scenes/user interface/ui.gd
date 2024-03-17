extends CanvasLayer


@onready var gun_texture_rect: TextureRect = $WeaponDisplay/VBoxContainer/GunDiisplay

var hud_pistol_texture: Texture2D = load("res://future-tds/hud/hud_pistol.png")
var hud_shotgun_texture: Texture2D = load("res://future-tds/hud/hud_shotgun.png")

func _ready():
	Globals.connect("weapon_changed", update_equipped_weapon)


func update_equipped_weapon(weapon_name: String):
	if weapon_name == "pistol":
		gun_texture_rect.texture = hud_pistol_texture
	if weapon_name == "shotgun":
		gun_texture_rect.texture = hud_shotgun_texture
