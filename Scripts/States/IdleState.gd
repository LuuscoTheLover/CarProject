extends State
class_name IdleState
@onready var driving_states = $".."

var driving : bool
var braking : bool
var reversing : bool

func enter():
	pass

func exit():
	pass
	

func state_process(delta):
	
	if Input.is_action_pressed("accelerate") and car.grounded > 2:
		state_trasition.emit(self, "DrivingState")
		
	if car.zmotion < -1 and car.grounded > 2:
		state_trasition.emit(self, "DrivingState")
	
func state_physics_process(delta):
	pass

