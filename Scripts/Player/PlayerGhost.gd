extends KinematicBody
#stats
var stats = PlayerStats
#vectors
var moveDir = Vector3.ZERO
var moveVel = Vector3.ZERO
var shootDir = Vector3.ZERO
var knockback = Vector3.ZERO
#timers
var shootingTime = 0.0
#nodes
var Bullet = preload("res://Scenes/Player/Bullet.tscn")
var BoomerBullet = preload("res://Scenes/Player/BoomerBullet.tscn")
var DeadPlayer = preload("res://Scenes/Player/PlayerDead.tscn")
onready var HurtBox = $HurtBox
onready var HeadSprite = $HeadSprite
onready var Hands = $Hands
onready var HandAnimationPlayer = $Hands/HandAnimationPlayer
onready var sfxHurt1 = $SFXHurt1
onready var sfxPickup = $SFXPickup


func _ready():
	stats.connect("no_health", self, "death")


func _process(_delta):
	if stats.active:
		process_input()
	else:
		moveDir = Vector3.ZERO
		shootDir = Vector3.ZERO


func _physics_process(delta):
	process_movement(delta)
	process_shooting(delta)
	process_animation(delta)


func process_input():
	moveDir = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		moveDir.x += 1
	if Input.is_action_pressed("move_left"):
		moveDir.x -= 1
	if Input.is_action_pressed("move_down"):
		moveDir.z += 1
	if Input.is_action_pressed("move_up"):
		moveDir.z -= 1
	moveDir = moveDir.normalized()
	
	shootDir = Vector3.ZERO
	if Input.is_action_pressed("shoot_right"):
		shootDir.x += 1
	if Input.is_action_pressed("shoot_left"):
		shootDir.x -= 1
	if Input.is_action_pressed("shoot_down"):
		shootDir.z += 1
	if Input.is_action_pressed("shoot_up"):
		shootDir.z -= 1
	if abs(shootDir.x) == 1 and abs(shootDir.z) == 1:
		shootDir.z = 0
	shootDir = shootDir.normalized()


func process_movement(delta):
	var targetVel = moveDir * stats.SPEED
	moveVel = moveVel.linear_interpolate(targetVel, stats.ACCELERATION * delta)
	moveVel.y = 0
	var _movement = move_and_slide(moveVel)
	
	knockback = knockback.linear_interpolate(Vector3.ZERO, stats.ACCELERATION * delta)
	knockback.y = 0
	var _knockback = move_and_slide(knockback)


func process_shooting(delta):
	shootingTime += delta
	if shootingTime > (1.0 / stats.FIRERATE):
		if shootDir != Vector3.ZERO:
			shootingTime = 0.0
			shoot_bullet(shootDir)


func process_animation(_delta):
	var headDir = shootDir
	if shootDir == Vector3.ZERO:
		headDir = moveDir
	
	if headDir.x == -1:
		HeadSprite.frame = 3
	if headDir.x == 1:
		HeadSprite.frame = 1
	if headDir.z == -1:
		HeadSprite.frame = 2
	if headDir.z == 1 or headDir == Vector3.ZERO:
		HeadSprite.frame = 0
	
	if HurtBox.invincible:
		HeadSprite.frame = 5


func shoot_bullet(direction):
	if PlayerStats.MULTISHOT:
		spawn_bullet(Vector3.LEFT)
		spawn_bullet(Vector3.RIGHT)
		spawn_bullet(Vector3.FORWARD)
		spawn_bullet(Vector3.BACK)
	else:
		spawn_bullet(direction)
	
	if direction == Vector3(0,0,-1):
		HandAnimationPlayer.play("ShootUp")
	if direction == Vector3(0,0,1):
		HandAnimationPlayer.play("ShootDown")
	if direction == Vector3(-1,0,0):
		HandAnimationPlayer.play("ShootLeft")
	if direction == Vector3(1,0,0):
		HandAnimationPlayer.play("ShootRight")


func spawn_bullet(direction):
	var b
	if stats.BOOMERANG:
		b = BoomerBullet.instance()
	else:
		b = Bullet.instance()
	get_parent().add_child(b)
	b.start(self.global_transform.origin, direction, stats.BULLETSPEED, stats.BULLETDISTANCE)


func death():
	var d = DeadPlayer.instance()
	get_parent().add_child(d)
	d.global_transform.origin = self.global_transform.origin
	queue_free()
	get_parent().game_over()


func _on_HurtBox_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("EnemyBullet"):
		sfxHurt1.play()
		HurtBox.start_invincibility(0.5)
		stats.health -= 1
		knockback = -(body.global_transform.origin - self.global_transform.origin).normalized() * body.KNOCKSTRENGTH
	
	if body.is_in_group("Spike") and !PlayerStats.WINGS:
		sfxHurt1.play()
		HurtBox.start_invincibility(0.5)
		stats.health -= 1


func _on_InteractBox_area_entered(area):
	if area.is_in_group("Key"):
		sfxPickup.play()
		stats.hasKey = true
		PlayerStats.add_to_score(100)
		get_tree().call_group("MessageUI", "create_message", "Key Aquired")
	
	if area.is_in_group("Heart"):
		if stats.health < stats.MAXHEALTH:
			sfxPickup.play()
			stats.health += 2
			get_tree().call_group("MessageUI", "create_message", "Health up")
			area.get_parent().heartPickedUp()
	
	if area.is_in_group("Orb"):
		sfxPickup.play()
		area.get_parent().picked_up()
		stats.orb_pickup()
	
	if area.is_in_group("Clover"):
		sfxPickup.play()
		area.get_node("AnimationPlayer").play("Aquired")
		stats.pickup_clover()
	
	if area.is_in_group("Arrow"):
		sfxPickup.play()
		area.get_node("AnimationPlayer").play("Aquired")
		stats.pickup_arrow()
	
	if area.is_in_group("MultiShot"):
		sfxPickup.play()
		area.get_node("AnimationPlayer").play("Aquired")
		stats.pickup_multishot()
	
	if area.is_in_group("Boomerang"):
		sfxPickup.play()
		area.get_node("AnimationPlayer").play("Aquired")
		stats.pickup_boomerang()
	
	if area.is_in_group("Wings"):
		sfxPickup.play()
		area.get_node("AnimationPlayer").play("Aquired")
		stats.pickup_wings()
