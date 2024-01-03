extends Camera3D


@onready var car = $"../.."
@onready var pivot = $".."


var look
var speed
var speedkmh

func _ready():
	look = global_position
	pass

func _process(delta):
	speed = car.linear_velocity.length()
	speedkmh = int(speed * 3.6)
	
	#if speedkmh > 10 :
	pivot.global_position = pivot.global_position.lerp(car.global_position, delta * 20.0)
	pivot.transform = pivot.transform.interpolate_with(car.transform, delta * 5.0)
	look = look.lerp(car.global_position + car.linear_velocity, delta * 5)
	look_at(look)
