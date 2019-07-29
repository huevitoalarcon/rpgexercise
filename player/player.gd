extends KinematicBody2D

#define una velocidad constante para el movimiento
const SPEED =200
#define una direccion de movimiento, inicializada en 0,0 para que no se mueva
var movedir = Vector2(0,0)

func _physics_process(delta):
	controls_loop()
	movement_loop()


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
	move_and_slide(motion, Vector2(0,0))
	
	
	