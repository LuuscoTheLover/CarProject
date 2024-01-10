extends Node3D
@onready var car = $Car

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		car.global_position.y = 7
