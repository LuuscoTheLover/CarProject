extends State
class_name IdleState

var driving : bool
var braking : bool
var reversing : bool

func enter():
	pass

func exit():
	pass
	

func state_process(delta):
	if car.grounded < 3:
		state_trasition.emit(self, "AirBornState")
	else:
		if Input.is_action_pressed("accelerate"):
			state_trasition.emit(self, "DrivingState")
			
		if car.zmotion < -1:
			state_trasition.emit(self, "DrivingState")
		
		if Input.is_action_pressed("reverse"):
			state_trasition.emit(self, "ReversingState")
		
		if car.zmotion > 1:
			state_trasition.emit(self, "ReversingState")
		
func state_physics_process(delta):
	pass

