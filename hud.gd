extends CanvasLayer
signal start_game

var opcionJuego = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Window.hide()
	$ScoreLabelJ2.hide()
	$ScoreLabel.position = Vector2(get_viewport().get_visible_rect().size.x / 2, 50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_message(text):
	$Missatge.text = text
	$Missatge.show()
	$MessageTimer.start()


func show_game_over(jugadorPerdedor = null):
# DOS VERSIONES UNA MULTIPLAYER Y UNA JUGADOR UNICO 
	if jugadorPerdedor != null:
		if jugadorPerdedor == 1:
			show_message("Guanyador Jugador 2")
		else: 
			show_message("Guanyador Jugador 1")
		# Espereu fins que el MessageTimer hagi acabat de comptar.
		
	else: show_message("Game over")
		
	await $MessageTimer.timeout
	$Missatge.text = "Dodge the\nCreeps!"
	$Missatge.show()
	# Feu un temporitzador one-shot i espereu que acabi.
	await get_tree().create_timer(1).timeout
	$StartButton.show()
	$ModeIndividual.show()
	$ModeMultiLocal.show()

func update_score(jugador, score):
	if jugador == 1:
		$ScoreLabel.text = str(score)
	else:
		$ScoreLabelJ2.text = str(score)
	
func _on_message_timer_timeout() -> void:
	$StartButton.hide()
	$Missatge.hide()	
	$ModeIndividual.hide()
	$ModeMultiLocal.hide()

func _on_start_button_pressed() -> void:
	emit_signal("start_game", opcionJuego)
	$StartButton.hide()
	

func transformarHud(version):
	if version == true:
		$ScoreLabel.show()
		$ScoreLabelJ2.hide()
		$ScoreLabelJ2.visible = false
		$ScoreLabel.position = Vector2(get_viewport().get_visible_rect().size.x / 2, 50)
	else:
		$ScoreLabelJ2.show()
		$ScoreLabelJ2.visible = true
		$ScoreLabel.position = Vector2(get_viewport().get_visible_rect().size.x / 3, 50)
		$ScoreLabelJ2.position = Vector2((get_viewport().get_visible_rect().size.x / 3) + 130, 50)

func _on_mode_individual_pressed() -> void:
	opcionJuego = true
	transformarHud(opcionJuego)


func _on_mode_multi_local_pressed() -> void:
	opcionJuego = false
	transformarHud(opcionJuego)


func _on_settings_pressed() -> void:
	$Window.show()
	


func _on_window_close_requested() -> void:
	$Window.hide()
