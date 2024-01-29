extends State
class_name BrakingState

var can_brake: bool

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	
	
	if Input.is_action_just_released("reverse"):
		state_trasition.emit(self, "IdleState")
	if car.zmotion in range(-3, 3):
		state_trasition.emit(self, "IdleState")
	

func state_physics_process(delta):
	if car.speedkmh < 3:
			car.linear_velocity = Vector3.ZERO
			#car.angular_velocity = Vector3.ZERO
	braking()


func braking():
	for wheel : WheelScript in car.wheels:
		if wheel.is_colliding():
			var brakedir
			if car.zmotion < -1:
				brakedir = car.global_basis.z
				can_brake = true
			elif car.zmotion > 1:
				brakedir = -car.global_basis.z
				can_brake = true
			else:
				can_brake = false
			if can_brake:
				car.apply_force(car.brake_input * brakedir, wheel.force_point - car.global_position)
