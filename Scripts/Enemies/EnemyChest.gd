extends "res://Scripts/Enemies/EnemyChase.gd"

onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite3D

func _ready():
	SPEED = 4.5 + (levelnum * 0.1)
	ACCELERATION = 3
	KNOCKSTRENGTH = 25
	KNOCKWEAKNESS = 5
	STARTHEALTH = 8
	$Sprite3D.frame = 0
	chaseWaitTime = 0.1
	OrbPercentChance = 100
	.set_to_maxHealth()


func start(position, levelnumber):
	levelnum = levelnumber
	self.translation = position + Vector3(-0.5,0,0.5)
	set_to_maxHealth()


func idle_state():
	moveDir = Vector3.ZERO
	seek_player()
	if playerDetected and health <= STARTHEALTH-1:
		animPlayer.play("ChestRun")
		state = CHASE


func death():
	.death()
	animPlayer.stop()
	sprite.frame = 3
