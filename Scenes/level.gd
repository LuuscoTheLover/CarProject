extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		$Car.global_position = $Respawn.global_position
	if Input.is_action_pressed("1"):
		$CSGBox3D.global_position.y += 0.1
	if Input.is_action_pressed("2"):
		$CSGBox3D.global_position.y -= 0.1
