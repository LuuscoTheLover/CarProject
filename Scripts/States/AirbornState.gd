extends State
class_name AirBornState

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	pass
	

func state_physics_process(delta):
	if car.grounded > 2:
		state_trasition.emit(self, "IdleState")
