extends Node2D

@onready var casino_label_1 = $Label as Label
@onready var game_select_label_2 = $Label2 as Label
@onready var menu_buttons = $VBoxContainer as VBoxContainer
@onready var game_select_buttons1 = $MarginContainer as MarginContainer
@onready var game_select_buttons2 = $MarginContainer2 as MarginContainer
@onready var back_to_main = $BackToMain as Button
@onready var settings_ui = $MarginContainer3 as MarginContainer

func _on_game_button_pressed():
	casino_label_1.hide()
	menu_buttons.hide()
	game_select_label_2.show()
	game_select_buttons1.show()
	game_select_buttons2.show()
	back_to_main.show()
	
func _on_settings_button_pressed():
	settings_ui.show()
	casino_label_1.hide()
	menu_buttons.hide()
	back_to_main.show()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_back_to_main_pressed():
	casino_label_1.show()
	menu_buttons.show()
	game_select_label_2.hide()
	game_select_buttons1.hide()
	game_select_buttons2.hide()
	back_to_main.hide()
	settings_ui.hide()

	


func _on_roulette_button_pressed():
	get_tree().change_scene_to_file("res://Roulette/roulette.tscn")
