extends CharacterBody3D

# Emite cuando el jugador salta encima de un mob.
signal squashed

# Velocidad mínima del mob en metros por segundo.
@export var min_speed = 10
# Velocidad máxima del mob en metros por segundo.
@export var max_speed = 18

func _physics_process(delta):
	move_and_slide()

func initialize(start_position, player_position):
	# Posicionaremos al mob colocandolo en start_position
	# y lo rotaremos hacia player_position, lo que estará 
	# mirando hacia el jugador.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotaremos este mob aleatoriamente dentro de un rango de -90 y +90 grados,
	# así que no ira directo hacia el jugador.
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# Calcularemos una velocidad aleatoria (Integer)
	var random_speed = randi_range(min_speed, max_speed)
	# Calcularemos una velocidad hacia adelante que representará la velocidad.
	velocity = Vector3.FORWARD * random_speed
	# Entonces rotaremos el vector de velocidad en base a la rotación Y del
	# mob en orden para moverse hacia la dirección a la que mira el mob.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.speed_scale = random_speed / min_speed


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()


func squash():
	squashed.emit()
	queue_free()
