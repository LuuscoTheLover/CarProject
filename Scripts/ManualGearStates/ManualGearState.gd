extends State
class_name ManualGearState

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	var w_rpm = car.wheel_rpm()
	
	if car.current_gear < 5 and car.current_gear >= 0 and w_rpm >= car.change_gear_rpm * 0.8:
		if Input.is_action_just_pressed('gear_up'):
			car.current_gear += 1
	
	if car.current_gear <= 5 and car.current_gear > 0 and w_rpm <= car.change_gear_rpm * 0.6:
		if Input.is_action_just_pressed('gear_down'):
			car.current_gear -= 1
	
	if car.speedkmh < ((car.max_speed * 3.6) * 0.6) and car.current_gear > 0:
		car.current_gear -= 1
	
func state_physics_process(delta):
	pass

