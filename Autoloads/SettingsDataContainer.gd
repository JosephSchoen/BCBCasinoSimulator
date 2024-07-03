extends Node

var subtitles_state : bool = false

# I'm not gonna lie, I don't know what is going on with all these scripts and signals connecting.
func _ready():
	SignalBus.on_subtitles_toggled.connect(on_subtitles_toggled)
	
func on_subtitles_toggled(value : bool) -> void:
	subtitles_state = value

func get_subtitles_state() -> bool:
	return subtitles_state
