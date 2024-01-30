extends State
class_name AutoGearState

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	if car.manual_drive:
		state_trasition.emit(self, "ManualGearState")
	
	if car.speedkmh > ((car.max_speed * 3.6) * 0.8) and car.current_gear < 5:
		car.current_gear += 1
	if car.speedkmh < ((car.max_speed * 3.6) * 0.6) and car.current_gear > 0:
		car.current_gear -= 1

func state_physics_process(delta):
	pass

