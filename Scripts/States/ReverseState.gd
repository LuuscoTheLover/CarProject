extends State
class_name ReverseState

var can_brake: bool

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	
	
	if Input.is_action_just_released("reverse"):
		state_trasition.emit(self, "IdleState")
	

func state_physics_process(delta):
	braking()


func braking():
	for wheel : WheelScript in car.wheels:
		var brakedir
		if car.linear_velocity.dot(car.basis.z) < -1:
			brakedir = car.basis.z
			can_brake = true
		elif car.linear_velocity.dot(car.basis.z) > 1:
			brakedir = -car.basis.z
			can_brake = true
		else:
			can_brake = false
		if can_brake:
			car.apply_force(car.reverse_input * brakedir, wheel.force_point - car.global_position)
