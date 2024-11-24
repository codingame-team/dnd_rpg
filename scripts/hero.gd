extends CharacterBody2D
class_name Joueur

var speed       = 300
var hp          = 10
var max_hp      = 10
var alive       = true
var attack: int = 1
var left_dir  = Vector2(-1, 0)
var right_dir = Vector2(1, 0)
var no_dir = Vector2(0, 0)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func _physics_process(delta):
	if not alive:
		$AnimatedSprite2D.play("dead")
		#queue_free()
		return

	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction == no_dir:
		$AnimatedSprite2D.play("idle")
	else:
		if direction == left_dir:
			$AnimatedSprite2D.flip_h = true
		elif direction == right_dir:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("attack")
		
	velocity = speed * direction
	#position += velocity * delta

	# Using move_and_slide.
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("I collided with ", collision.get_collider().name)
	
	
func _on_body_entered(body: Node2D) -> void:
	# hide() # Player disappears after being hit.
	hp -= 1
	if hp <= 0: alive = false
	# Must be deferred as we can't change physics properties on a physics callback.
	# $CollisionShape2D.set_deferred("disabled", true)
