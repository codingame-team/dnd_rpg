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
	
func _process(delta):
	var viewport_size = get_viewport_rect().size
	
	# Get the current sprite frame size
	var sprite_size = $AnimatedSprite2D.sprite_frames.get_frame_texture("attack", 0).get_size()
	var half_width = sprite_size.x * scale.x / 2
	var half_height = sprite_size.y * scale.y / 2
	
	# Clamp position while accounting for player size
	position.x = clamp(position.x, half_width, viewport_size.x - half_width)
	position.y = clamp(position.y, half_height, viewport_size.y - half_height)


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
