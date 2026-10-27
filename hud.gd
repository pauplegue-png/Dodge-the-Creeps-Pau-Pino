extends CanvasLayer
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_message(text):
	$Missatge.text = text
	$Missatge.show()
	$MessageTimer.start()


func show_game_over(jugadorPerdedor):
	if jugadorPerdedor == 1:
		show_message("Guanyador Jugador 2")
	else: 
		show_message("Guanyador Jugador 1")
	# Espereu fins que el MessageTimer hagi acabat de comptar.
	await $MessageTimer.timeout
	$Missatge.text = "Dodge the\nCreeps!"
	$Missatge.show()
	# Feu un temporitzador one-shot i espereu que acabi.
	await get_tree().create_timer(1).timeout
	$StartButton.show()

func update_score(jugador, score):
	if jugador == 1:
		$ScoreLabel.text = str(score)
	else:
		$ScoreLabelJ2.text = str(score)
	
func _on_message_timer_timeout() -> void:
	$StartButton.hide()
	$Missatge.hide()	

func _on_start_button_pressed() -> void:
	emit_signal("start_game")
	$StartButton.hide()
	
