extends CharacterBody3D

# Emite cuando el jugador es golpeado por un mob.
signal hit

# Como de rápido se mueve el jugador en metros por segundo.
@export var speed = 14
# La acceleración hacia abajo cuando estas en el aire, 
# en metros por segundo al cuadrado.
@export var fall_acceleration = 75
# Impulso vertical que se aplicará al personaje cuando 
# esté saltando en metros por segundo.
@export var jump_impulse = 20
# Impulso vertical aplicado al personaje cuando bote encima
# de un mob en metros por segundo.
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# Esta variable local guardara la dirección del input.
	var direction = Vector3.ZERO
	
	# Comprobaremos por cada input de movimiento y actualizaremos 
	# la dirección de forma acorde.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# Destacar como será trabajar con los ejes X y Z del vector.
		# En 3D, el plano XZ es el plano del suelo.
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	# Aplicación de la dirección actual en el modelo 3D.
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
	
	# Velocidad de suelo.
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Velocidad vertical.
	if not is_on_floor(): # Si está en el aire, caera hacia el suelo. AKA Gravedad.
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		print("NO Toca suelo")
	
	# Saltando.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		print("Saltando")
	
	# Itera a través de todas las colisiones que ocurre en este frame.
	for index in range(get_slide_collision_count()):
		# Obtenemos una de las colisiones con el jugador.
		var collision = get_slide_collision(index)
		
		# Si la colisión es con el suelo...
		if (collision.get_collider() == null):
			continue
		
		# Si la colisión es con un mob...
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# Comprobamos que le estamos dando por encima.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# Si asi es, sera aplastado y botaremos.
				mob.squash()
				target_velocity.y = bounce_impulse
	
	print("TARGET_VELOCITY = " + str(target_velocity))
	
	# Moviendo al personaje.
	velocity = target_velocity
	move_and_slide()

# Mata al jugador.
func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()
