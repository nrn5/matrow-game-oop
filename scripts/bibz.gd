extends Node3D

@onready var interaction_area: interactionArea = $InteractionArea

var inputReady = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inputReady && Input.is_action_just_pressed("interact"):
		print("BIBZ INTERACTINO DIALOGUE START")
		var dialogue = load("res://dialogue/dialogue01.dialogue")
		if DialogueManager and dialogue:  # Check if DialogueManager is available and dialogue is loaded
			DialogueManager.show_example_dialogue_balloon(dialogue, "intro_meeting")
		print("BIBS INTERACTION DIALOGUE COMPLETE")
	


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		print("interaction area enetred")
		inputReady = 1




func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		print("inteaction area left")