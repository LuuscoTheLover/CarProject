extends State
class_name IdleState

func enter():
	pass

func exit():
	pass
	

func state_process(delta):
	if Input.is_action_pressed("accelerate"):
		state_trasition.emit(self, "DrivingState")
		
	if Input.is_action_pressed("reverse"):
		state_trasition.emit(self, "BrakingState")

func state_physics_process(delta):
	pass

