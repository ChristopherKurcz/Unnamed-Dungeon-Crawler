extends "res://Scripts/Enemies/Enemy.gd"

var player

var maxJumpTime = 8
var minJumpTime = 3
var jumpTime
var jumpWaitTime = 0

enum {
	IDLE,
	INAIR,
	GROUND,
	SPITTING
}

var state = IDLE
onready var rng = RandomNumberGenerator.new()


func _ready():
	SPEED = 5
	ACCELERATION = 2
	KNOCKSTRENGTH = 30
	KNOCKWEAKNESS = 1
	STARTHEALTH = 20
	.set_to_maxHealth()


func _process(delta):
	if not dead:
		process_state(delta)


func process_state(delta):
	match state:
		IDLE:
			idle_state()
		INAIR:
			in_air_state(delta)
		GROUND:
			ground_state()
		SPITTING:
			spitting_state()


func idle_state():
	moveDir = Vector3.ZERO
	seek_player()
	if playerDetected:
		state = GROUND


func in_air_state(delta):
	jumpTime += delta
	if jumpTime >= jumpWaitTime:
		jumpTime = 0
		jumpWaitTime = rng.randf_range(minJumpTime, maxJumpTime)
		ground_pound()
	
	player = playerDetection.player
	if player != null:
		moveDir = (player.global_transform.origin - self.global_transform.origin).normalized()
	else:
		state = IDLE


func ground_state():
	moveDir = Vector3.ZERO


func spitting_state():
	pass


func ground_pound():
	pass
