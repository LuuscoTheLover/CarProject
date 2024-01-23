extends State
class_name IdleState

func enter():
	print("idle enter")

func exit():
	print("idle exit")
	

func state_process(delta):
	if Input.is_action_just_pressed("1"):
		state_trasition.emit(self, "DrivingState")
	print("idle process")
	

func state_physics_process(delta):
	pass

