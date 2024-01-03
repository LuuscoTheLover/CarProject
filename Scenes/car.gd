extends RigidBody3D
class_name Car

@export_category("Car Specs")
@export var wheel_base : float = 2.55
@export var turn_radius : float = 10.8
@export var rear_track : float = 1.525



@onready var car = $"."

func _physics_process(delta):
	pass


