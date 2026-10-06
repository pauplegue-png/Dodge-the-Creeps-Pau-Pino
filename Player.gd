extends Area2D

@export var speed = 400 # A quina velocitat es mourà el jugador (píxels/seg).
var screen_size # Mida de la finestra de joc.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
