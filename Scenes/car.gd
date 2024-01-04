extends RigidBody3D
class_name CarScript

@export var debug : bool
@export_category("Engine")
@export var engine_power : float
@export var drag : float = 10

var accel_input : float

func _process(delta):
	accel_input = Input.get_axis("reverse", "accelerate")
