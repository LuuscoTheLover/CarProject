extends Label

@onready var car = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rear_grip = snapped((%RRWheel.grip_factor + %RLWheel.grip_factor) / 2, 0.01)
	$"../Drift Check".text = "no drifting"
	if rear_grip < 0.5:
		$"../Drift Check".text = "drifting"
	text = "Rear Grip: %s" % rear_grip