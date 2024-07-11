extends Node2D

@onready var casino_label_1 = $MenulogoBlowup as Sprite2D
@onready var game_select_label_2 = $MenulogoBlowup2 as Sprite2D
@onready var menu_buttons = $VBoxContainer as VBoxContainer
@onready var game_select_buttons1 = $MarginContainer as MarginContainer
@onready var game_select_buttons2 = $MarginContainer2 as MarginContainer
@onready var back_to_main = $BackToMain as TextureButton
@onready var settings_ui = $MarginContainer3 as MarginContainer
@onready var play_button = $GameButton as TextureButton

func _on_game_button_pressed():
	casino_label_1.hide()
	play_button.hide()
	menu_buttons.hide()
	game_select_label_2.show()
	game_select_buttons1.show()
	game_select_buttons2.show()
	back_to_main.show()
	
func _on_settings_button_pressed():
	casino_label_1.hide()
	menu_buttons.hide()
	play_button.hide()
	back_to_main.show()
	settings_ui.show()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_back_to_main_pressed():
	casino_label_1.show()
	menu_buttons.show()
	play_button.show()
	game_select_label_2.hide()
	game_select_buttons1.hide()
	game_select_buttons2.hide()
	back_to_main.hide()
	settings_ui.hide()

func _on_roulette_button_pressed():
	get_tree().change_scene_to_file("res://Roulette/roulette.tscn")
