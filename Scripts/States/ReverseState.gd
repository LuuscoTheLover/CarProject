extends State
class_name ReverseState

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	print("reverse process")
	car.reverse_input = Input.get_action_strength("reverse") * car.brake_force
	if Input.is_action_just_released("reverse"):
		state_trasition.emit(self, "IdleState")
	

func state_physics_process(delta):
	pass

