extends RigidBody2D

var thrust = Vector2(0, 450)
var torque = 20000
var shipoverlaps
var footoverlaps
var deathtimer 

func _ready():
	#pass
	set_process(true)
	set_contact_monitor(true)
	set_max_contacts_reported(3)
	get_node("SkullSprite").hide()
	get_node("ExplosionSprite").hide()
	deathtimer = Timer.new()
	deathtimer.set_wait_time(3)
	deathtimer.set_one_shot(true)
	deathtimer.connect("timeout", self, "switchtomenu")
	add_child(deathtimer)

func _integrate_forces(state):
	if Input.is_action_pressed("thrust"):
		set_applied_force(state.get_total_gravity() - thrust.rotated(get_rot()))
		get_node("Particles2D").show()
	elif Input.is_action_pressed("revthrust"):
		set_applied_force(state.get_total_gravity() + thrust.rotated(get_rot()))
		get_node("Particles2D").hide()
	else:
		set_applied_force(state.get_total_gravity() + Vector2())
		get_node("Particles2D").hide()
	var t = Input.is_action_pressed("bear_right") - Input.is_action_pressed("bear_left")
	set_applied_torque(torque * t)


func _process(delta):
	shipoverlaps = get_node("ShipArea").get_overlapping_bodies()
	footoverlaps = get_node("FootArea").get_overlapping_bodies()
	if (shipoverlaps.size() > 1):
		get_node("SkullSprite").show()
		get_node("RocketSprite").hide()
		death()
	else:
		get_node("SkullSprite").hide()
	for i in footoverlaps:
		if(i.get_name() == "Moon"):
			get_node("SkullSprite").show()

func death():
	set_process(false)
	get_node("ExplosionSprite").show()
	get_node("ExplosionSprite").get_node("AnimationPlayer").play("explode")
	deathtimer.set_active(true)
	deathtimer.start()
	#while(deathtimer.get_wait_time() > 0.1):
	print(deathtimer.get_wait_time())

	
func switchtomenu():
	get_tree().change_scene("res://game/gui/menu/Menu.tscn")
