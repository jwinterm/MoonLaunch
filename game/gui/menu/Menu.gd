extends VBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
		# Called every time the node is added to the scene.
		# Initialization here
		pass


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_PlayButton_pressed():
	get_tree().change_scene("res://game/levels/1/Level1.tscn")


func _on_HelpButton_pressed():
	get_tree().change_scene("res://game/gui/help/Help.tscn")
