extends CanvasLayer
signal start_game

var configFile = ConfigFile.new()
var opcionJuego = true
var muerte = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Window Settings".hide()
	$"Window About".hide()
	$ScoreLabelJ2.hide()
	$ScoreLabel.position = Vector2(get_viewport().get_visible_rect().size.x / 2, 50)


func loadConfig() -> void:
	var err = configFile.load("user://scores.cfg")
	if err != OK:
		return
	var bus = AudioServer.get_bus_index("Master")
	$"Window Settings/MusicaScrollBar".set_value(configFile.get_value("Audio","volume", 0))
	AudioServer.set_bus_mute(bus, configFile.get_value("Audio","mute", false))
	get_viewport().mode = configFile.get_value("Audio","windowsMode", Window.MODE_WINDOWED)

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
	$SaveModeButton.show()
	$Settings.show()
	$About.show()

func update_score(jugador, score):
	if jugador == 1:
		$ScoreLabel.text = str(score)
	else:
		$ScoreLabelJ2.text = str(score)
	
func _on_message_timer_timeout() -> void:
	$StartButton.hide()
	$Missatge.hide()

func _on_start_button_pressed() -> void:
	emit_signal("start_game", opcionJuego, muerte)
	$StartButton.hide()
	$SaveModeButton.hide()
	$Settings.hide()
	$About.hide()
	$ModeIndividual.hide()
	$ModeMultiLocal.hide()

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
	loadConfig()
	$"Window Settings".show()
	

func _on_window_close_requested() -> void:
	$"Window Settings".hide()
	
func _on_musica_scroll_bar_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus, value)
	$"Window Settings/MusicaScrollBar".value = value


func _on_mute_buton_pressed() -> void:
	var bus = AudioServer.get_bus_index("Master")
	if AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus,false)
		$"Window Settings/btMuteButon".text = "Mutear musica"
	else: 
		AudioServer.set_bus_mute(bus,true)
		$"Window Settings/btMuteButon".text = "Desmutear musica"


func _on_mute_buton_2_pressed() -> void:
	if get_viewport().mode == Window.MODE_MAXIMIZED:
		get_viewport().mode = Window.MODE_WINDOWED
		$"Window Settings/btPantallaCompleta".text = "Pantalla Completa"
	else:
		get_viewport().mode = Window.MODE_MAXIMIZED
		$"Window Settings/btPantallaCompleta".text = "Pantalla Ventna"


func _on_bt_confirm_conf_pressed() -> void:
	var bus = AudioServer.get_bus_index("Master")
	configFile.set_value("Audio","volume", $"Window Settings/MusicaScrollBar".value)
	configFile.set_value("Audio","mute", AudioServer.is_bus_mute(bus))
	configFile.set_value("Window","windowsMode", get_viewport().mode)
	configFile.save("user://scores.cfg")

func _on_save_mode_button_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		muerte = false
	else:
		muerte = true
