extends Node
class_name State
signal state_trasition
signal force_state

@export var car : CarScript
@onready var fsm : FiniteStateMachine = $"../"

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	pass
	

func state_physics_process(delta):
	pass
