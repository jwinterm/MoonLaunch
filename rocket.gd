extends RigidBody2D

var thrust = Vector2(0, 450)
var torque = 20000

func _ready():
	pass

func _integrate_forces(state):
	if Input.is_action_pressed("thrust"):
		set_applied_force(state.get_total_gravity() - thrust.rotated(get_rot()))
	elif Input.is_action_pressed("revthrust"):
		set_applied_force(state.get_total_gravity() + thrust.rotated(get_rot()))
	else:
		set_applied_force(state.get_total_gravity() + Vector2())
	var t = Input.is_action_pressed("bear_right") - Input.is_action_pressed("bear_left")
	set_applied_torque(torque * t)
