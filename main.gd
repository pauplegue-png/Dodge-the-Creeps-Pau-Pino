extends Node

@export var mob_scene: PackedScene = preload("res://mob.tscn")
@export var player_scene: PackedScene = preload("res://Player.tscn")
var scoreJ1
var scoreJ2
var yaColision
var gameTypeOp
var Player2
var death
var dificultVelocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	#new_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func game_over() -> void:
		$ScoreTimer.stop()
		$MobTimer.stop()
		if yaColision == false:
			if gameTypeOp == true:
				$Hud.show_game_over()
			else:
				$Hud.show_game_over(1)
			yaColision = true
			
		$Music.stop()
		$DeathSound.play()
	
func new_game(gameType, deathOption, velocidad):
	match velocidad:
		0: dificultVelocity = 0.5
		1: dificultVelocity = 1
		2: dificultVelocity = 1.5
	
	death = deathOption
	if gameType == false:
		if Player2:
			Player2.queue_free()
		Player2 = player_scene.instantiate()
		Player2.numJugador = 2
		gameTypeOp = gameType
		Player2.hit.connect(game_overJ2)
		add_child(Player2) 
		Player2.start($StartPosition.position + Vector2(50, 0), death)
		
	gameTypeOp = gameType
	yaColision = false
	scoreJ1 = 0
	scoreJ2 = 0
	$Player.start($StartPosition.position, death)
	$StartTimer.start()
	$Music.play()
	$Hud.update_score(1,scoreJ1)
	$Hud.update_score(2,scoreJ2)
	$Hud.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_mob_timer_timeout() -> void:
	# Crea una nova instància de l'escena Mob.
	var mob = mob_scene.instantiate()
	
	# Trieu una ubicació aleatòria a Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf() # Godot 4 recomana progress_ratio en lloc de .offset directament si vols un valor percentual, tot i que .offset funciona si està configurat en píxels.
	
	# Estableix la direcció de la multitud perpendicular a la direcció del camí.
	var direction = mob_spawn_location.rotation + PI / 2

	# Estableix la posició de la multitud a una ubicació aleatòria.
	mob.position = mob_spawn_location.position

	# Afegeix una mica d'aleatorietat a la direcció.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Tria la velocitat de la multitud.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0) * dificultVelocity
	mob.linear_velocity = velocity.rotated(direction)
	# Va fer que la multitud s'afegís a l'escena principal.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	scoreJ2 = scoreJ2 + 1
	scoreJ1 = scoreJ1 + 1
	$Hud.update_score(1,scoreJ1)
	$Hud.update_score(2,scoreJ2)
	
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func game_overJ2() -> void:
		$ScoreTimer.stop()
		$MobTimer.stop()
		if yaColision == false:
			if gameTypeOp == false:
				Player2.queue_free()
				$Hud.show_game_over(2)
			yaColision = true
		$Music.stop()
		$DeathSound.play()
