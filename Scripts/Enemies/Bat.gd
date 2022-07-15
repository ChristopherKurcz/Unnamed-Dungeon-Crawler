extends "res://Scripts/Enemies/EnemyChase.gd"

onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite3D

func _ready():
	SPEED = 3 + (levelnum * 0.1)
	ACCELERATION = 2.25
	KNOCKSTRENGTH = 20
	KNOCKWEAKNESS = 7.5
	STARTHEALTH = 2
	.set_to_maxHealth()


func process_animation(_delta):
	if moveDir.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func death():
	.death()
	animPlayer.play("BatDeath")
