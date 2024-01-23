extends State
class_name DrivingState

func enter():
	print("driving enter")


func exit():
	print("driving exit")
	

func state_process(delta):
	print("drive process")
	car.accel_input = Input.get_action_strength("accelerate") * (car.horse_power * 200)
	
	if Input.is_action_just_released("accelerate"):
		state_trasition.emit(self, "IdleState")

func state_physics_process(delta):
	pass

