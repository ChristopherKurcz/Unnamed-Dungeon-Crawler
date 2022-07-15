extends "res://Scripts/Enemies/Bat.gd"

func _ready():
	SPEED = 5 + (levelnum * 0.15)
	ACCELERATION = 1.5 + (levelnum * 0.15)
	KNOCKSTRENGTH = 30
	KNOCKWEAKNESS = 1
	STARTHEALTH = 1
	OrbPercentChance = -1000
	chaseWaitTime = 0.1
	.set_to_maxHealth()

func process_animation(_delta):
	pass

func death():
	.death()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "BatDeath":
		queue_free()
