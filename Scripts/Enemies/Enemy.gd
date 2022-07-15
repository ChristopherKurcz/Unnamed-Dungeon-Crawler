extends KinematicBody
# Constants
var SPEED = 3 setget setSpeed
var ACCELERATION = 2 setget setAcceleration
var KNOCKSTRENGTH = 25 setget setKnockStrength
var KNOCKWEAKNESS = 5 setget setKnockWeakness
var STARTHEALTH = 1 setget setStartHealth

var levelnum
var health
var dead

var moveVel = Vector3.ZERO
var moveDir = Vector3.ZERO
var knockback = Vector3.ZERO

var playerDetected = false

onready var playerDetection = $PlayerDetection
onready var hurtBox = $HurtBox
onready var sfxHurt1 = $SFXHurt1
onready var sfxHurt2 = $SFXHurt2

var Orb = preload("res://Scenes/Drops/OrbDrop.tscn")
var OrbPercentChance = 5

func start(position, levelnumber):
	levelnum = levelnumber
	self.translation = position
	set_to_maxHealth()


func set_to_maxHealth():
	health = STARTHEALTH


func _physics_process(delta):
	if not dead:
		process_movement(delta)
		process_animation(delta)


func process_movement(delta):
	var targetVel = moveDir * SPEED
	moveVel = moveVel.linear_interpolate(targetVel, ACCELERATION * delta)
	moveVel.y = 0
	var _movement = move_and_slide(moveVel)
	
	knockback = knockback.linear_interpolate(Vector3.ZERO, ACCELERATION * delta)
	knockback.y = 0
	var _knockback = move_and_slide(knockback)


func process_animation(_delta):
	pass


func seek_player():
	if playerDetection.can_see_player():
		playerDetected = true
	else:
		playerDetected = false


func death():
	if randi()%100+1 <= (OrbPercentChance + PlayerStats.LUCK):
		spawn_orb()
	
	PlayerStats.add_to_score(10)
	
	dead = true
	self.remove_from_group("Enemy")
	get_parent().check_for_enemies()


func spawn_orb():
	var o = Orb.instance()
	get_parent().add_child(o)
	o.start(self.global_transform.origin, moveVel)


func _on_HurtBox_area_entered(area):
	if randi() & 1:
		if sfxHurt1 != null:
			sfxHurt1.play()
	else:
		if sfxHurt2 != null:
			sfxHurt2.play()
	
	health -= 1
	if health == 0:
		death()
	knockback = area.get_parent().knockbackVector * area.get_parent().stats.KNOCKSTRENGTH * KNOCKWEAKNESS


func setSpeed(speed):
	SPEED = max(0,speed)

func setAcceleration(acceleration):
	ACCELERATION = max(0,acceleration)

func setKnockStrength(knockStrength):
	KNOCKSTRENGTH = max(0,knockStrength)

func setKnockWeakness(knockWeakness):
	KNOCKWEAKNESS = max(0,knockWeakness)

func setStartHealth(startHealth):
	STARTHEALTH = max(1,startHealth)
