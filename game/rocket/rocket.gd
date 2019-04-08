extends RigidBody2D

# Ship control variables
var thrust = Vector2(0, 350)
var torque = 5000
var shipoverlaps
var footoverlaps
var crashspeed = 100
var landingspeed = 40
# Timer variables
var deathtimer 
var moontimer
var moontimerdefault = 3
var landattempttimer
# Mission variables
var landattemptnow = true
var flagplaced = false

func _ready():
	# Turn on processes and monitors
	set_process(true)
	set_contact_monitor(true)
	set_max_contacts_reported(3)
	# Setup sprites
	get_node("SkullSprite").hide()
	get_node("ExplosionSprite").hide()
	get_node("CosmonautSprite").hide()
	# Initialize timers
	deathtimer = Timer.new()
	deathtimer.set_wait_time(3)
	deathtimer.set_one_shot(true)
	deathtimer.connect("timeout", self, "switchtomenu")
	add_child(deathtimer)
	moontimer = Timer.new()
	moontimer.set_wait_time(moontimerdefault)
	moontimer.set_one_shot(true)
	moontimer.connect("timeout", self, "flagplanted")
	add_child(moontimer)
	#print(get_node("../../MoonSpace").get_name())

func _integrate_forces(state):
	if Input.is_action_pressed("thrust"):
		set_applied_force(state.get_total_gravity() - thrust.rotated(get_rot()))
		get_node("RearThrust").show()
		get_node("RevThrust").hide()
		if not get_node("Sample_thrust").is_active():
			get_node("Sample_thrust").play("thrust", true)
	elif Input.is_action_pressed("revthrust"):
		set_applied_force(state.get_total_gravity() + thrust.rotated(get_rot()))
		get_node("RearThrust").hide()
		get_node("RevThrust").show()
		if not get_node("Sample_revthrust").is_active():
			get_node("Sample_revthrust").play("thrust", true)
	else:
		set_applied_force(state.get_total_gravity() + Vector2())
		get_node("RearThrust").hide()
		get_node("RevThrust").hide()
		get_node("Sample_thrust").stop_all()
		get_node("Sample_revthrust").stop_all()
	var t = Input.is_action_pressed("bear_right") - Input.is_action_pressed("bear_left")
	set_applied_torque(torque * t)


func _process(delta):
	shipoverlaps = get_node("ShipArea").get_overlapping_bodies()
	footoverlaps = get_node("FootArea").get_overlapping_bodies()
	if (shipoverlaps.size() > 1):
		get_node("RocketSprite").hide()
		death()
	else:
		get_node("SkullSprite").hide()
	for i in footoverlaps:
		#print(i.get_name())
		if (get_linear_velocity().length() > crashspeed and i.get_name() != "Rocket"):
			death()
		if(i.get_name() == "Moon" and get_linear_velocity().length() < landingspeed and flagplaced == false and landattemptnow == false):
			#print("LANDED!")
			moonland()
	if moontimer.is_active() and footoverlaps.size() < 2:
		moontimer.stop()
		moontimer.set_wait_time(moontimerdefault)
		landattemptnow = false


func death():
	moontimer.disconnect("timeout", self, "flagplanted")
	get_node("ExplosionSprite").show()
	get_node("RocketSprite").hide()
	get_node("ExplosionSprite").get_node("AnimationPlayer").play("explode")
	get_node("Sample_explosion").play("explosion", true)
	get_node("SkullSprite").show()
	set_process(false)
	deathtimer.set_active(true)
	deathtimer.start()
	#while(deathtimer.get_wait_time() > 0.1):
	#print(deathtimer.get_wait_time())

func moonland():
	print("START MOONLAND")
	#set_process(false)
	landattemptnow = true
	moontimer.set_active(true)
	#get_tree().get_root().set_disable_input(true)
	moontimer.start()

func flagplanted():
	globalvar.finaltime = get_node("../../MoonSpace/CanvasLayer/TimeLabel").time
	#finaltime = get_node("../../CanvasLayer/TimeLabel").time
	flagplaced = true
	print("FLAG PLACED")
	#get_tree().get_root().set_disable_input(false)
	get_node("CosmonautSprite").show()
#	get_tree().set_pause(true)
	get_tree().change_scene("res://game/gui/victory/Victory.tscn")
	#set_process(true)
	
func switchtomenu():
	get_tree().change_scene("res://game/gui/menu/Menu.tscn")
