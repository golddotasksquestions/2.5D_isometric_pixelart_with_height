extends Area

onready var sprite = $Sprite3D
var cylinder = preload("res://cylinder.tscn")

func _on_switch_body_entered(body):
	if "player" in body.name:
		var new_cylinder = cylinder.instance()
		get_parent().add_child(new_cylinder)
		sprite.frame = 1


func _on_switch_body_exited(body):
	sprite.frame = 0
