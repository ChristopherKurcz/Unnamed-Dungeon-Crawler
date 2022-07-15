extends Spatial

export(float) var acceleration = 10

var targetPos
var pos

func _ready():
	targetPos = Vector3(0,0,0)
	pos = targetPos

func _physics_process(delta):
	pos = pos.linear_interpolate(targetPos, acceleration * delta)
	self.global_transform.origin = pos

func move_up():
	targetPos = targetPos + Vector3(0,0,-30)

func move_down():
	targetPos = targetPos + Vector3(0,0,30)

func move_left():
	targetPos = targetPos + Vector3(-30,0,0)

func move_right():
	targetPos = targetPos + Vector3(30,0,0)
