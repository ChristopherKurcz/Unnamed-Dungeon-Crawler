extends Label

var lifeTime = 4

onready var animPlayer = $AnimationPlayer


func _ready():
	var _connection = get_tree().create_timer(lifeTime).connect("timeout", self, "fade_away")


func fade_away():
	animPlayer.play("FadeAway")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeAway":
		queue_free()
