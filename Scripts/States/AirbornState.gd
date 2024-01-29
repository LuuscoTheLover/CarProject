extends State
class_name AirBornState

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	if car.grounded:
		state_trasition.emit(self, "IdleState")

func state_physics_process(delta):
	pass

