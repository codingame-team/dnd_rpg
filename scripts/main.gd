extends Node

@export var mob_scene: PackedScene
var score
var time_left: int = 30

func _ready():
	new_game()
	
func game_over():
	$GameTimer.stop()
	$MobTimer.stop()
	var msg: String = "Game over!\nYour score: %d" % score
	$HUD.show_message(msg)
	get_tree().paused = true
	#get_node("/root/Hud/StartButton").show()
	#get_node("/root/Main").update_score() # Replace with function body.

	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("enemies", "queue_free")
	$HUD.update_score(score)
	$HUD.show_message("Kill the boars!")
	
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)

	# Flip the sprite based on movement direction
	# If moving left (negative x velocity), flip the sprite
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated(direction)
	#mob.get_node("AnimatedSprite2D").flip_h = velocity.x > 0

	# Calculate rotation based on velocity direction
	# Using atan2 to get the angle from velocity vector
	mob.rotation = velocity.angle() + PI
	
	# Since sprite faces left by default, we need to flip it when moving right
	# This keeps the sprite properly oriented with the velocity
	mob.get_node("AnimatedSprite2D").flip_v = velocity.x > 0
	
	# Set the velocity
	mob.velocity = velocity

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func update_score():
	score += 1
	$HUD.update_score(score)
	
func _on_start_timer_timeout():
	$MobTimer.start()
	$GameTimer.start()
	score = 0
	$HUD/StartButton.hide()


func _on_game_timer_timeout() -> void:
	if time_left == 0:
		game_over()
	time_left -= 1
