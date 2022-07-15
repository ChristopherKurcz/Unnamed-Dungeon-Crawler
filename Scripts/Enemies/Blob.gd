extends "res://Scripts/Enemies/Enemy.gd"

var CHASESPEED

onready var animPlayer = $AnimationPlayer

enum{
	IDLE,
	MOVE
}

var state = IDLE


func _ready():
	randomize()
	SPEED = 3 + (levelnum * 0.2)
	ACCELERATION = 6
	KNOCKSTRENGTH = 20
	KNOCKWEAKNESS = 1
	STARTHEALTH = 2
	.set_to_maxHealth()


func _process(delta):
	if not dead:
		process_state(delta)


func process_state(_delta):
	match state:
		IDLE:
			moveDir = Vector3.ZERO
			seek_player()
			if playerDetected:
				moveDir = playerDetection.player.global_transform.origin - self.global_transform.origin
				moveDir = -moveDir.normalized()
				state = MOVE
		MOVE:
			pass


func death():
	.death()
	hurtBox.queue_free()
	playerDetection.queue_free()
	animPlayer.play("BlobDeath")
	set_collision_layer(128)
	set_collision_mask(128)


func _on_DirChangeArea_body_entered(body):
	if body.is_in_group("Wall") or body.is_in_group("Gate") or body.is_in_group("Enemy") or body.is_in_group("PlayerBullet") or body.is_in_group("Spike") and body != self:
		moveDir = body.global_transform.origin - self.global_transform.origin
		moveDir = -moveDir.normalized()
		moveDir.y = 0
		moveVel = Vector3.ZERO
