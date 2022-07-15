extends KinematicBody

onready var sprite = $OrbSprite
onready var tween = $Tween
onready var colShape = $CollisionShape
onready var area = $Area
onready var animPlayer = $AnimationPlayer

var moveVel


func start(pos, moveVelocity):
	self.global_transform.origin = pos
	moveVel = moveVelocity


func _physics_process(delta):
	process_movement(delta)


func process_movement(delta):
	var targetVel = Vector3.ZERO
	moveVel = moveVel.linear_interpolate(targetVel, 2 * delta)
	var _movement = move_and_slide(moveVel)


func picked_up():
	area.get_child(0).disabled = true
	colShape.disabled = true
	animPlayer.play("pickedUp")
	var _connection = get_tree().create_timer(1).connect("timeout", self, "delete_self")


func delete_self():
	queue_free()
