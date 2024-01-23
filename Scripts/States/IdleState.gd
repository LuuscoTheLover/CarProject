extends State
class_name IdleState

func enter():
	print("idle enter")

func exit():
	print("idle exit")
	

func state_process(delta):
	print("idleproceess")
	if Input.is_action_pressed("accelerate"):
		state_trasition.emit(self, "DrivingState")
	if Input.is_action_pressed("reverse"):
		state_trasition.emit(self, "ReverseState")

func state_physics_process(delta):
	pass

