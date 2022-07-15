extends "res://Scripts/Enemies/EnemyChase.gd"

onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite3D

var minWaitShootTime = 1
var maxWaitShootTime = 3
var waitShootTime
var shootTime = 0

var stanceDistance = 3

onready var rng = RandomNumberGenerator.new()

var WatiBullet = preload("res://Scenes/Enemies/WatiBullet.tscn")

func _ready():
	rng.randomize()
	SPEED = 0.8 + (levelnum * 0.05)
	minWaitShootTime = 2 - (min(levelnum, 15) * 0.1)
	ACCELERATION = 4
	KNOCKSTRENGTH = 20
	KNOCKWEAKNESS = 5
	STARTHEALTH = 5
	.set_to_maxHealth()
	$Sprite3D.frame = 0
	$Sprite3D.translation = Vector3.ZERO
	waitShootTime = rng.randf_range(1.5, 3)


func chase_state(delta):
	.chase_state(delta)
	
	if player != null:
		moveDir = -moveDir
		var distToPlayer = self.global_transform.origin.distance_to(player.global_transform.origin)
		if distToPlayer >= stanceDistance-0.2 and distToPlayer < stanceDistance:
			moveDir = Vector3.ZERO
		if distToPlayer >= stanceDistance:
			moveDir = -moveDir
	
	shootTime += delta
	if shootTime >= waitShootTime:
		shootTime = 0
		waitShootTime = rng.randf_range(minWaitShootTime, maxWaitShootTime)
		moveVel = Vector3.ZERO
		shoot()


func shoot():
	sprite.frame = 1
	var w = WatiBullet.instance()
	w.levelnum = levelnum
	get_parent().add_child(w)
	w.global_transform.origin = self.global_transform.origin + (player.global_transform.origin - self.global_transform.origin).normalized()


func death():
	.death()
	animPlayer.play("WatiDeath")
