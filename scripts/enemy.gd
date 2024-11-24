extends Area2D
class_name Enemy

var velocity: Vector2
var base_speed: int = 150
var speed: int = base_speed
var mob_types = ['walk', 'run']
#var mob_types = ['bee']
# var mob_types = ['snail']

signal hit

func _ready():
	var mob_anim_type: String = mob_types[randi() % mob_types.size()]
	if mob_anim_type == 'run':
		speed = 300
	else:
		speed = base_speed
	$AnimatedSprite2D.play(mob_anim_type)
	
func _process(delta: float) -> void:
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	position += velocity * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body: Node) -> void:
	hide() # Enemy disappears after being hit.
	hit.emit()
	# queue_free()
	## Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func _on_hit() -> void:
	get_node("/root/Main").update_score() # Replace with function body.
