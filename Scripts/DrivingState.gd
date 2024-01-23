extends State
class_name DrivingState

func enter():
	print("driving enter")


func exit():
	print("driving exit")
	

func state_process(delta):
	print("drive process")
	if Input.is_action_just_pressed("2"):
		state_trasition.emit(self, "IdleState")

func state_physics_process(delta):
	pass

