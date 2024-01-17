extends Camera3D

@onready var car = $"../.."
@onready var pivot = $".."
@export var direction_offset : float = 1.0

var look : Vector3
func _ready():
	look = car.global_position

func _process(delta):
	if car.rear_gear:
		$"../Rear Camera".current = true
	else:
		current = true

	if current:
		pivot.global_position = lerp(pivot.global_position, car.global_position, delta * 20.0)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, car.rotation.y, delta * direction_offset)
		look = lerp(look, car.global_position + Vector3(car.linear_velocity.x, car.linear_velocity.y, car.linear_velocity.z), delta * 20)
		look_at(look)
		rotation_degrees.x = clamp(rotation_degrees.x, -8, -10)
		rotation_degrees.y = clamp(rotation_degrees.y, 270, 0)
