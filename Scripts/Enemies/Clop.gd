extends "res://Scripts/Enemies/Enemy.gd"

var CHASESPEED

onready var rayUp = $Rays/RayCastUp
onready var rayDown = $Rays/RayCastDown
onready var rayLeft = $Rays/RayCastLeft
onready var rayRight = $Rays/RayCastRight

onready var headSprite = $SpriteHead
onready var hands = $Hands
onready var animPlayer = $AnimationPlayer
onready var sfxTarget = $SFXTarget

enum{
	IDLE,
	SEARCH,
	CHASE
}

var state = IDLE


func _ready():
	SPEED = 2
	CHASESPEED = 5 + (levelnum * 0.2)
	ACCELERATION = 5
	KNOCKSTRENGTH = 20
	KNOCKWEAKNESS = 3
	STARTHEALTH = 4
	.set_to_maxHealth()


func _process(delta):
	if not dead:
		process_state(delta)


func process_state(delta):
	match state:
		IDLE:
			moveDir = Vector3.ZERO
			seek_player()
			if playerDetected:
				moveDir = playerDetection.player.global_transform.origin - self.global_transform.origin
				moveDir = -moveDir.normalized()
				state = SEARCH
		SEARCH:
			search_state(delta)
		CHASE:
			chase_state(delta)


func search_state(_delta):
	KNOCKWEAKNESS = 3
	hands.translation = Vector3(0,0,0.01)
	animPlayer.playback_speed = 1
	if rayUp.is_colliding():
		moveDir = Vector3(0,0,-1) * CHASESPEED/SPEED
		state = CHASE
		sfxTarget.play()
	if rayDown.is_colliding():
		moveDir = Vector3(0,0,1) * CHASESPEED/SPEED
		state = CHASE
		sfxTarget.play()
	if rayLeft.is_colliding():
		moveDir = Vector3(-1,0,0) * CHASESPEED/SPEED
		state = CHASE
		sfxTarget.play()
	if rayRight.is_colliding():
		moveDir = Vector3(1,0,0) * CHASESPEED/SPEED
		state = CHASE
		sfxTarget.play()


func chase_state(_delta):
	KNOCKWEAKNESS = 0
	animPlayer.playback_speed = 1.5
	if moveDir == Vector3(0,0,-1) * CHASESPEED/SPEED:
		headSprite.frame = 3
		hands.translation = Vector3(0,0.3,-0.2)
	if moveDir == Vector3(0,0,1) * CHASESPEED/SPEED:
		headSprite.frame = 1
		hands.translation = Vector3(0,0.3,0.2)
	if moveDir == Vector3(-1,0,0) * CHASESPEED/SPEED:
		headSprite.frame = 4
		hands.translation = Vector3(-0.15,0.3,0.05)
	if moveDir == Vector3(1,0,0) * CHASESPEED/SPEED:
		headSprite.frame = 2
		hands.translation = Vector3(0.15,0.3,0.05)


func process_animation(_delta):
	match state:
		SEARCH:
			headSprite.frame = 0
		CHASE:
			if moveDir == Vector3(0,0,-1) * CHASESPEED/SPEED:
				headSprite.frame = 3
			if moveDir == Vector3(0,0,1) * CHASESPEED/SPEED:
				headSprite.frame = 1
			if moveDir == Vector3(-1,0,0) * CHASESPEED/SPEED:
				headSprite.frame = 4
			if moveDir == Vector3(1,0,0) * CHASESPEED/SPEED:
				headSprite.frame = 2


func death():
	.death()
	hurtBox.queue_free()
	playerDetection.queue_free()
	rayUp.queue_free()
	rayDown.queue_free()
	rayLeft.queue_free()
	rayRight.queue_free()
	animPlayer.play("ClopDeath")
	set_collision_layer(128)
	set_collision_mask(128)


func _on_DirChangeArea_body_entered(body):
	if body.is_in_group("Wall") or body.is_in_group("Gate") or body.is_in_group("Enemy") and body != self:
		moveDir = body.global_transform.origin - self.global_transform.origin
		moveDir = -moveDir.normalized()
		moveDir.y = 0
		moveVel = Vector3.ZERO
		state = SEARCH
