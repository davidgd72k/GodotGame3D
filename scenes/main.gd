extends Node

@export var mob_scene: PackedScene

func _process(delta):
	# Pulsa ESCAPE para quitar el juego.
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

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

func _on_player_hit():
	$MobTimer.stop()
