extends "res://Scripts/Enemies/EnemyChase.gd"

onready var animPlayer = $AnimationPlayer
onready var spriteBody = $SpriteBody
onready var spriteHead = $SpriteHead

var minWaitShootTime = 1
var maxWaitShootTime = 4
var waitShootTime
var shootTime = 0

onready var rng = RandomNumberGenerator.new()

var SkelBone = preload("res://Scenes/Enemies/SkelBone.tscn")
var boneSpeed = 4
var boneDistance = 25

func _ready():
	rng.randomize()
	SPEED = 1 + (levelnum * 0.05)
	minWaitShootTime = 2 - (min(levelnum, 15) * 0.1)
	boneSpeed = 3.5 + (levelnum * 0.1)
	ACCELERATION = 2
	KNOCKSTRENGTH = 10
	KNOCKWEAKNESS = 3
	STARTHEALTH = 4
	.set_to_maxHealth()
	waitShootTime = rng.randf_range(minWaitShootTime, maxWaitShootTime)


func process_animation(_delta):
	if moveDir.x > 0:
		spriteBody.flip_h = false
		spriteHead.flip_h = false
	else:
		spriteBody.flip_h = true
		spriteHead.flip_h = true


func chase_state(delta):
	.chase_state(delta)
	
	shootTime += delta
	if shootTime >= waitShootTime:
		shootTime = 0
		waitShootTime = rng.randf_range(minWaitShootTime, maxWaitShootTime)
		moveVel = Vector3.ZERO
		shoot()


func shoot():
	spriteBody.frame = 2
	var b = SkelBone.instance()
	get_parent().add_child(b)
	b.start(self.global_transform.origin, moveDir, boneSpeed, boneDistance)


func death():
	.death()
	animPlayer.play("SkelDeath")
