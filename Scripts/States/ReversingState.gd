extends State
class_name ReversingState

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	if car.grounded < 2:
		state_trasition.emit(self, "IdleState")
	
	if car.zmotion < 1 and not Input.is_action_pressed("reverse"):
		state_trasition.emit(self, "IdleState")
	
	if Input.is_action_pressed("accelerate"):
		state_trasition.emit(self, "DrivingState")

func state_physics_process(delta):
	pass

