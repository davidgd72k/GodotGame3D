extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()

func _process(delta):
	# Pulsa ESCAPE para quitar el juego.
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# Esto reinicia la escena actual.
		get_tree().reload_current_scene()

func _on_mob_timer_timeout():
	# Creamos una nueva instancia de la escena Mob.
	var mob = mob_scene.instantiate()
	
	# Escogemos una localización aleatoria de SpawnPath.
	# Almacenaremos la referencia en el nodo SpawnLocation.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# Y dandole un punto aleatorio.
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Spawnea el mob añadiendolo a la escena Main.
	add_child(mob)
	
	# Conectaremos el mob a la etiqueta de puntos (ScoreLabel) para actualizar
	# la puntuación cada vez que se aplaste a uno.
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()

