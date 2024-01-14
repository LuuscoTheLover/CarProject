extends Camera3D

@onready var car = $"../.."
@onready var pivot = $".."
@export var direction_offset : float = 1.0

var look : Vector3
func _ready():
	look = car.global_position

func _process(delta):
	if Input.is_action_pressed("accelerate"):
		current = true
	elif car.linear_velocity.dot(car.basis.z) > -1 and Input.is_action_pressed("reverse"):
		$"../Rear Camera".current = true
	elif car.linear_velocity.dot(car.basis.z) > 0:
		$"../Rear Camera".current = true
	elif car.linear_velocity.dot(car.basis.z) < 0:
		current = true
	if current:
		pivot.global_position = lerp(pivot.global_position, car.global_position, delta * 20.0)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, car.rotation.y, delta * 5.0)
		look = lerp(look, car.global_position + Vector3(car.linear_velocity.x * direction_offset, car.linear_velocity.y, car.linear_velocity.z) , delta * 5.0)
		look_at(look)
