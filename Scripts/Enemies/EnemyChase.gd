extends "res://Scripts/Enemies/Enemy.gd"

var chaseTimer = 0.0
var chaseWaitTime = 0.5

var player

onready var softCollision = $SoftCollision

enum {
	IDLE,
	CHASE
}

var state = IDLE

func _process(delta):
	if not dead:
		process_state(delta)

func process_state(delta):
	match state:
		IDLE:
			idle_state()
		CHASE:
			chase_state(delta)
	
	if softCollision.is_colliding():
		moveVel += softCollision.get_push_vector() * delta * KNOCKWEAKNESS


func idle_state():
	moveDir = Vector3.ZERO
	seek_player()
	if playerDetected:
		state = CHASE


func chase_state(delta):
	player = playerDetection.player
	if player != null:
		chaseTimer += delta
		if chaseTimer > chaseWaitTime:
			moveDir = (player.global_transform.origin - self.global_transform.origin).normalized()
	else:
		state = IDLE
		chaseTimer = 0.0


func death():
	.death()
	hurtBox.queue_free()
	playerDetection.queue_free()
	softCollision.queue_free()
	set_collision_layer(128)
	set_collision_mask(128)
