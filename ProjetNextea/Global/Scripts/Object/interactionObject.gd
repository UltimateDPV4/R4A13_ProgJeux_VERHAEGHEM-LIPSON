extends Area2D

class_name InteractionObject

var listInteractionObject := {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialiser le dictionnaire avec tous les objets d'interaction
	for obj in get_tree().get_nodes_in_group("canInteractive"):
		listInteractionObject[obj] = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if is_in_group("canInteractive"):
			listInteractionObject[self] = true
			Global.canInteract = true
			print("A player Contact")
		else:
			Global.canInteract = false
			print("A player Contact but cant interact")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and is_in_group("canInteractive"):
		listInteractionObject[self] = false
		Global.canInteract = false
		print("A player No Contact")


func _on_interaction_button_pressed() -> void:
	# Lorsque le bouton d'interaction est pressé, vérifiez quel objet doit interagir
	for obj in listInteractionObject.keys():
		if listInteractionObject[obj]:
			# Appeler la fonction d'interaction pour cet objet
			if (!obj.is_in_group("alwaysInteractive")):
				print("Not Always Interactive")
				listInteractionObject[obj] = false
				obj.remove_from_group("canInteractive")			
				Global.canInteract = false  # Mettre à jour l'état global après l'interaction
			else:
				print("Always Interactive")
				listInteractionObject[obj] = true
				Global.canInteract = true
			print("Interactive")
			obj.startInteraction()
			break
	print("Not Found Interactive Object")
