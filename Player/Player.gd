extends KinematicBody2D

# Movendo o Personagem
const ACCELERATION = 500 # faz ele ir mas rápido e mais devagar
const MAX_SPEED = 100 # velocidade que não vai mudar
const FRICTION = 500 # adicionando atrito

# Animações
onready var animationPlayer = $AnimationPlayer # onready já substitui a função "_ready()"

# Animações usando estrutura de árvore
onready var animationTree = $AnimationTree

onready var animationState = animationTree.get("parameters/playback") # guarda as informações da árvore de aminação

var velocity = Vector2.ZERO # Vector é a resultante do vetor X e Y | e o Zero é a posição atual (0, 0)

func _physics_process(delta): # cada frame roda essa função
	# delta é o tempo que um frame leva
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # up = -1 | down = 1
	
	input_vector = input_vector.normalized() # retorna a versão normalizada do vetor | porque na diagonal somaria a velocidade
		
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector) # link com Animation Tree
		animationTree.set("parameters/Run/blend_position", input_vector)
		
		animationState.travel("Run") # se estiver precionado ele entra no galho da corrida, que está na árvore
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")  # se estiver paradp ele entra no galho da pause (Idle), que está na árvore
		
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # adicionando uma "força contrária
	
	velocity = move_and_slide(velocity)  # a velocidade será relativa ao frame rate
