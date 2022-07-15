extends KinematicBody

var moveVel
var knockbackVector = Vector3.ZERO

var startPos
var distance = 0
var maxDistance


func start(position, direction, speed, maxDist):
	startPos = position + direction/2
	self.global_transform.origin = startPos
	moveVel = direction * speed
	knockbackVector = direction
	maxDistance = maxDist


func _physics_process(delta):
	process_movement(delta)
	if startPos.distance_to(self.global_transform.origin) >= maxDistance:
		destroy()


func process_movement(delta):
	var collision = move_and_collide(moveVel * delta)
	if collision:
		wall_hit()


func wall_hit():
	destroy()


func destroy():
	queue_free()
