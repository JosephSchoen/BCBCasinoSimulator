extends Node


signal on_subtitles_toggled(value : bool)


func emit_on_subtitles_toggled(value : bool) -> void:
	on_subtitles_toggled.emit(value)
