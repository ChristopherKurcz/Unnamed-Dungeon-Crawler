extends "res://Scripts/Enemies/EnemyChase.gd"

onready var rng = RandomNumberGenerator.new()
onready var animPlayer = $SpriteAnimationPlayer
onready var hideAnimPLayer = $HideAnimationPlayer
onready var sprite = $Sprite3D

var minWaitHideTime = 3
var maxWaitHideTime = 5
var minHideTime = 3
var maxHideTime = 5
var waitHideTime
var curHideTime
var hideTimer = 0

var hiding = false

func _ready():
	rng.randomize()
	SPEED = 2.5 + (levelnum * 0.1)
	ACCELERATION = 3.5
	KNOCKSTRENGTH = 20
	KNOCKWEAKNESS = 5
	STARTHEALTH = 3
	waitHideTime = rng.randf_range(minWaitHideTime, maxWaitHideTime)
	curHideTime = rng.randf_range(minHideTime, maxHideTime)
	.set_to_maxHealth()


func chase_state(delta):
	player = playerDetection.player
	if player != null:
		chaseTimer += delta
		if chaseTimer > chaseWaitTime:
			var targetPos = player.global_transform.origin + player.moveDir.normalized() * 1
			moveDir = (targetPos - self.global_transform.origin).normalized()
	else:
		state = IDLE
		chaseTimer = 0.0
	
	hideTimer += delta
	if hideTimer >= waitHideTime and not hiding:
		hideTimer = 0
		curHideTime = rng.randf_range(minHideTime, maxHideTime)
		hiding = true
		self.set_collision_mask_bit(9,false)
		hurtBox.set_monitoring(false)
		hurtBox.set_monitorable(false)
		hideAnimPLayer.play("Hide")
	if hideTimer >= curHideTime and hiding:
		hideTimer = 0
		waitHideTime = rng.randf_range(minWaitHideTime, maxWaitHideTime)
		hiding = false
		hideAnimPLayer.play("UnHide")


func hide():
	sprite.modulate = Color(1,1,1,0)
	self.set_collision_mask_bit(9,false)
	hurtBox.set_monitoring(false)
	hurtBox.set_monitorable(false)


func unHide():
	sprite.modulate = Color(1,1,1,1)
	self.set_collision_mask_bit(9,true)
	hurtBox.set_monitoring(true)
	hurtBox.set_monitorable(true)


func death():
	.death()
	animPlayer.play("GnomDeath")


func _on_HideAnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hide":
		hide()
	
	if anim_name == "UnHide":
		unHide()
