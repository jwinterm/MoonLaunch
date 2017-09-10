extends RigidBody2D


var time = 0.0
var thrust_force = Vector2()
var thrust 
var revthrust 
var bear_left 
var bear_right 


func _input(delta):
	# var lv = s.get_linear_velocity()
	# var step = s.get_step()
	var rotation = get_rot()
	# Get the controls
	thrust = Input.is_action_pressed("thrust")
	revthrust = Input.is_action_pressed("revthrust")
	bear_left = Input.is_action_pressed("bear_left")
	bear_right = Input.is_action_pressed("bear_right")

	thrust_force = 5*Vector2(sin(rotation), cos(rotation))

		
func _fixed_process(delta):
	time += delta
	# print(time)
	
	if (thrust):
		# print("Rotation: ", rotation, "   Linear velocity: ", lv, "   sin rotation: ", sin(rotation), "   cos rotation: ", cos(rotation))
		apply_impulse(Vector2(0,0), -thrust_force)
	if (revthrust):
		apply_impulse(Vector2(0,0), thrust_force)
	if (bear_left):
		rotate(0.1)
	if (bear_right):
		rotate(-0.1)

func _ready():
	# set_gravity_scale(1)
	set_process(true)
	set_process_input(true)
	set_fixed_process(true)