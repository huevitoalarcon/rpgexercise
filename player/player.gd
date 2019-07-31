extends KinematicBody2D

#define una velocidad constante para el movimiento
const SPEED =70
#define una direccion de movimiento, inicializada en 0,0 para que no se mueva
var movedir = Vector2(0,0)

#indica la dirección del sprite para seleccionar la animación a utilizar
var spritedir = "down"

func _physics_process(delta):
	controls_loop()
	movement_loop()
	spritedir_loop()
	print (spritedir)
	
	#checkea si esta en una muralla
	if is_on_wall():
	#si detecta una muralla revisa si el personaje esta mirando directo a la muralla
	#o si solo esta al lado, de este modo evitamos que la animacion se active
	#y el personaje este en otra direccion
		if spritedir =="left" and test_move(transform, Vector2(-1,0)):
			anim_switch("push")
		if spritedir=="right" and test_move(transform, Vector2(1,0)):
			anim_switch("push")
		if spritedir=="up" and test_move(transform, Vector2(0,-1)):
			anim_switch("push")
		if spritedir=="down" and test_move(transform, Vector2(0,1)):
			anim_switch("push")
	elif movedir != Vector2(0,0):
		#si se presiona algun boton de direccion reproduce la animacion walk
		anim_switch("walk")
	else:
		#si no se esta apretando nada pasa a estado Idle
		anim_switch("idle")


#define funciones a utilizar


#controls loop maneja los controles para detectar la direccion en que debe moverse
#cuando una de las teclas es presionada las variables left, right up y down tendran valor 
#true o 1 si no lo hacen tendran false o 0
func controls_loop():
	var LEFT =Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
#la dirección de movimiento se define como un plano cartesiano para definir hacia donde
#se moveran en X y en Y por medio de una suma
#ej: si left es 1 y right es 0
# -(1) + 0 = -1 <-- ira hacia la izquierda del plano
#left es 1 y right tambien tambien -(1) + 1=0 y no pasara nada
#left es 0 y right es 1 ---> 0+1=1 y avanzara hacia la derecha del plano
#Lo mismo ocurre con el eje Y

	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
#movement loop se encarga de hacer el movimiento del personaje con la dirección definida
#en controls loop
func movement_loop():
	#crea una variable motion que usa la dirección y multiplica por velocidad para definir
	#cuanto se va a mover el personaje
	#la funcion normalized() no es necesaria pero estoy averiguando que hace
	var motion =movedir.normalized()*SPEED
	 
	#mueve el personaje utilizando el valor de Motion
	#aun estoy averiguando bien como funciona esa funcion
	#Sin utilizar Vector2(0,0) sigue funcionando sin problemas
	move_and_slide(motion, Vector2(0,0))
	
#spritedir loop cambia la dirección del sprite segun la direccion en la se que este moviendo
#el personaje	
func spritedir_loop():
	match movedir:
		Vector2(-1,0):
			spritedir="left"
		Vector2(1,0): 
			spritedir="right"
		Vector2(0,-1):
			spritedir="up"
		Vector2(0,1):
			spritedir="down"
	
#cambia la animacion segun spritedir
func anim_switch(animation):
	#crea un nombre que se forma uniendo animation y spritedir, es decir
	#si esta caminando une walk con up (nombre que definimos en el nodo animation player)
	var newanim= str(animation,spritedir)
	#si la animacion actual es distinta de "newanim" esta cambiara a la que indica newanim
	if $anim.current_animation != newanim:
		$anim.play(newanim)