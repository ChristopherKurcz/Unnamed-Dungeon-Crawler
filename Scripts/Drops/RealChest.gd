extends KinematicBody

var KNOCKWEAKNESS = 7
var ACCELERATION = 2.5

var knockback = Vector3.ZERO
var opened = false

onready var sprite = $ChestSprite

var ItemDrops = [
	preload("res://Scenes/Drops/Clover.tscn"),
	preload("res://Scenes/Drops/Arrow.tscn"),
	preload("res://Scenes/Drops/MultiShot.tscn"),
	preload("res://Scenes/Drops/Boomerang.tscn"),
	preload("res://Scenes/Drops/Wings.tscn"),
	]

func _ready():
	sprite.frame = 0


func _physics_process(delta):
	process_movement(delta)


func process_movement(delta):
	knockback = knockback.linear_interpolate(Vector3.ZERO, ACCELERATION * delta)
	var _knockback = move_and_slide(knockback)


func pick_item():
	var result = randi()%len(ItemDrops)
	var curItem = -1
	if PlayerStats.currentItem == "Clover":
		curItem = 0
	if PlayerStats.currentItem == "Arrow":
		curItem = 1
	if PlayerStats.currentItem == "MultiShot":
		curItem = 2
	if PlayerStats.currentItem == "Boomerang":
		curItem = 3
	if PlayerStats.currentItem == "Wings":
		curItem = 4
	while result == curItem:
		result = randi()%len(ItemDrops)
	return result


func spawn_item():
	var item = ItemDrops[pick_item()].instance()
	self.get_parent().add_child(item)
	item.global_transform.origin = self.global_transform.origin


func _on_HurtBox_area_entered(area):
	if not opened:
		opened = true
		sprite.frame = 1
		spawn_item()
		knockback = area.get_parent().knockbackVector * (area.get_parent().stats.KNOCKSTRENGTH + 1) * KNOCKWEAKNESS
