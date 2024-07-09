extends Node2D

var selected = false

var can_grab = false

@onready var chip_sprite = preload("res://chip.tscn")

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_grab:
		if Input.is_action_just_pressed("Left Click"):
			selected = !selected
	if selected:
		followMouse()

func followMouse():
	position = get_global_mouse_position()

func inst(pos):
	var instance = chip_sprite.instantiate()
	instance.position = pos
	add_child(instance)

func _on_area_2d_mouse_entered():
	can_grab = true

func _on_area_2d_mouse_exited():
	can_grab = false
