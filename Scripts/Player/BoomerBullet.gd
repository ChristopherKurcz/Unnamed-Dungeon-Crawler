extends KinematicBody

var moveVel
var moveDir
var targetVel
var knockbackVector = Vector3.ZERO

var startPos
var flyDistance
var distFlew = false
var playerCollision = false

var stats = PlayerStats
var player
onready var playerDetection = $PlayerDetection


func start(position, direction, speed, distance):
	startPos = position + direction/2
	self.global_transform.origin = startPos
	moveVel = direction * speed
	targetVel = moveVel
	knockbackVector = direction
	flyDistance = distance * 0.35
	var _connection = get_tree().create_timer(0.2).connect("timeout", self, "activate_player_collision")


func _physics_process(delta):
	process_direction(delta)
	process_movement(delta)


func process_direction(_delta):
	player = playerDetection.player
	if (startPos.distance_to(self.global_transform.origin) >= flyDistance):
		distFlew = true
	if player != null and playerCollision and distFlew:
		moveDir = (player.global_transform.origin - self.global_transform.origin).normalized()
	elif playerCollision and distFlew:
		destroy()


func process_movement(delta):
	if moveDir != null:
		targetVel = moveDir * stats.BULLETSPEED
	moveVel = moveVel.linear_interpolate(targetVel, 1.5 * delta)
	
	knockbackVector = moveVel.normalized()
	
	var collision = move_and_collide(moveVel * delta)
	if collision:
		wall_hit()


func wall_hit():
	destroy()


func destroy():
	queue_free()


func activate_player_collision():
	playerCollision = true


func _on_Area_area_entered(area):
	if area.is_in_group("Enemy"):
		destroy()
	if area.is_in_group("Player") and playerCollision:
		destroy()
	if area.is_in_group("PlayerBullet"):
		destroy()
