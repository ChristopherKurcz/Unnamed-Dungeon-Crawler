extends Area

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended

onready var timer = $Timer

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invincibility_started():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)

func _on_HurtBox_invincibility_ended():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
