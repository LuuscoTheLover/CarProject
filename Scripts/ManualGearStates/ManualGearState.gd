extends State
class_name ManualGearState

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	
	if car.current_gear < 5 and car.current_gear >= 0 and car.wheel_rpm() >= car.change_gear_rpm:
		if Input.is_action_just_pressed('1'):
			car.current_gear += 1
	
	if car.current_gear <= 5 and car.current_gear > 0 and car.wheel_rpm() <= car.change_gear_rpm:
		if Input.is_action_just_pressed('2'):
			car.current_gear -= 1
	
	if car.speedkmh < (car.max_speed) and car.current_gear > 0:
		car.current_gear -= 1
	
	print(car.wheel_rpm())
	print(car.change_gear_rpm)

	
func state_physics_process(delta):
	pass

