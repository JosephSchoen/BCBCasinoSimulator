extends Node2D

@onready var balance = 100
var can_bet = false
var blue_chip = false
var black_chip = false
var chip_grabbed = false
var current_chip = ""
@onready var balance_text = $Label as Label
@onready var balance_text2 = $Label2 as Label
@onready var cannot_bet_label = $CannotBet as Label
@onready var timer = $Timer as Timer

var chip_color = ""

@onready var chip_sprite = preload("res://chip.tscn")

var bet_amount = 0
var roulette_number = null
var player_bets = {}

var can_place_chip = false

@onready var camera = $Camera2D as Camera2D

const numbers = ["00", "0", "1", "2", "3", "4", "5", "6",
"7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17",
"18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28",
"29", "30", "31", "32", "33", "34", "35", "36"]

@onready var number_label = $NumberLabel as Label
@onready var wheel_timer = $WheelTimer as Timer
var label_num = null


# Called when the node enters the scene tree for the first time.
func _ready():
	balance_text.text = "Balance: " + str(balance)
	cannot_bet_label.text = "Sorry, you do not have the funds to do that."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	in_betting_or_chip_area()
	check_place_or_return_bet()


func in_betting_or_chip_area():
	# If the mouse is in the area of the blue chip
	if blue_chip == true:
		# If the user left clicks
		if Input.is_action_just_pressed("Left Click"):
			if balance >= 10:
				# Negate the boolean chip grabbed. Supposed to effectively return
				# the chip to the pile if they have it grabbed and click back on it
				chip_grabbed = !chip_grabbed
				chip_color = "Blue Chip"
				bet_amount = 10
			else:
				cannot_bet_label.show()
				timer.start(3)
				
	
	# If the mouse is in area of the black chip
	elif black_chip == true:
		# If the user left clicks
		if Input.is_action_just_pressed("Left Click"):
			if balance >= 100:
				# Negate the boolean chip grabbed. Supposed to effectively return
				# the chip to the pile if they have it grabbed and click back on it
				chip_grabbed = !chip_grabbed
				# Set the proper chip color and bet amount
				chip_color = "Black Chip"
				bet_amount = 100
			else:
				cannot_bet_label.show()
				timer.start(3)

func check_place_or_return_bet():
	# If the player is in a spot where they can bet
	if can_bet == true:
		if chip_grabbed == true:
			if Input.is_action_just_released("Left Click"):
				chip_grabbed = false
				bet_select()
				place_bet()
		else:
			# Checks if the player can grab a dropped chip
			if roulette_number != null:
				if player_has_bet_on_number(roulette_number):
					# If the player left clicks
					if Input.is_action_just_pressed("Left Click"):
						# Set chip_grabbed to true (The player picks up the last chip placed)
						chip_grabbed = true
						print('asdfasdfasdfdasf')
						balance += int(player_bets[roulette_number])
						bet_amount = player_bets[roulette_number]
						player_bets.erase(roulette_number)
						balance_text.text = "Balance: " + str(balance)
		


	
# Searches the dictionary to see if the player has bet on the roulette number their mouse is hovering over
func player_has_bet_on_number(roulette_number) -> bool:
	for number in player_bets:
		if number == roulette_number:
			return true
	return false

# Decreases the player's balance by their selected bet amount
func place_bet():
	balance -= bet_amount
	# Update the label to display the proper balance
	balance_text.text = "Balance: " + str(balance)

# Increases the player's balance if they want to return a placed bet on the table
func return_bet():
	match chip_color:
		"White Chip":
			balance += 1
		"Red Chip":
			balance += 5
		"Blue Chip":
			balance += 10
		"Green Chip":
			balance += 25
		"Black Chip":
			balance += 100
	
	# Update the label to display the proper balance
	balance_text.text = "Balance: " + str(balance)

# Selects the proper bet	
func bet_select():
	var found = false
	# Searches the dictionary to see if the player has bet at that number
	for key in player_bets:
		# Condition is true if player is betting on a value they already have bet on
		if key == roulette_number:
			# Append the bet amount to the key-value pair already in the dictionary
			player_bets[key] += bet_amount
			# Switch found to true to prevent the function from satisfying the below if statement
			found = true
			# Break out of the loop
			break
	# If the player has not bet on this value, we add the key-value pair to the dictionary
	if found == false:
		player_bets[roulette_number] = bet_amount
	print(player_bets)
		

# Finds the proper chip color
func get_chip(bet) -> String:
	match bet:
		1:
			current_chip = "White Chip"
		5:
			current_chip = "Red Chip"
		10:
			current_chip = "Blue Chip"
		25:
			current_chip = "Green Chip"
		100:
			current_chip = "Black Chip"
	return current_chip
	
# Player's mouse enters black chip area
func _on_texture_rect_3_mouse_entered():
	black_chip = true

# Player's mouse enters black chip area
func _on_texture_rect_3_mouse_exited():
	black_chip = false


func _on_timer_timeout():
	cannot_bet_label.hide()

	
func _on_bet_num_1_mouse_entered():
	can_bet = true
	roulette_number = "1"

func _on_bet_num_1_mouse_exited():
	mouse_exited()

func _on_bet_num_2_mouse_entered():
	can_bet = true
	roulette_number = "2"

func _on_bet_num_2_mouse_exited():
	mouse_exited()

func _on_bet_num_3_mouse_entered():
	can_bet = true
	roulette_number = "3"

# Number 3 on roulette table
func _on_bet_num_3_mouse_exited():
	mouse_exited()
	
func _on_bet_num_4_mouse_entered():
	can_bet = true
	roulette_number = "4"

func _on_bet_num_4_mouse_exited():
	mouse_exited()
	
func _on_bet_num_5_mouse_entered():
	can_bet = true
	roulette_number = "5"

func _on_bet_num_5_mouse_exited():
	mouse_exited()

func _on_bet_num_6_mouse_entered():
	can_bet = true
	roulette_number = "6"

func _on_bet_num_6_mouse_exited():
	mouse_exited()

func _on_bet_2356_mouse_entered():
	can_bet = true
	roulette_number = "2_3_5_6"

func _on_bet_2356_mouse_exited():
	mouse_exited()

func mouse_exited():
	can_bet = false

func _on_bet_3_and_6_mouse_entered():
	can_bet = true
	roulette_number = "3 and 6"

func _on_bet_3_and_6_mouse_exited():
	mouse_exited()

func _on_bet_3_and_2_mouse_entered():
	can_bet = true
	roulette_number = "3 and 2"

func _on_bet_3_and_2_mouse_exited():
	mouse_exited()

func _on_blue_chip_mouse_entered():
	blue_chip = true

func _on_black_chip_mouse_entered():
	black_chip = true

func _on_blue_chip_mouse_exited():
	blue_chip = false

func _on_black_chip_mouse_exited():
	black_chip = false

func _on_bet_6_5_mouse_entered():
	can_bet = true
	roulette_number = "6 and 5"

func _on_bet_6_5_mouse_exited():
	mouse_exited()

func _on_bet_6_9_5_8_mouse_entered():
	can_bet = true
	roulette_number = "6_9_5_8"

func _on_bet_6_9_5_8_mouse_exited():
	mouse_exited()

func _on_bet_9_8_mouse_entered():
	can_bet = true
	roulette_number = "9 and 8"

func _on_bet_9_8_mouse_exited():
	mouse_exited()

func _on_bet_9_12_8_11_mouse_entered():
	can_bet = true
	roulette_number = "9_12_8_11"


func _on_bet_9_12_8_11_mouse_exited():
	mouse_exited()


func _on_bet_12_11_mouse_entered():
	can_bet = true
	roulette_number = "12 and 11"


func _on_bet_12_11_mouse_exited():
	mouse_exited()


func _on_bet_12_15_11_14_mouse_entered():
	can_bet = true
	roulette_number = "12_15_11_14"


func _on_bet_12_15_11_14_mouse_exited():
	mouse_exited()

func _on_bet_15_14_mouse_entered():
	can_bet = true
	roulette_number = "15 and 14"

func _on_bet_15_14_mouse_exited():
	mouse_exited()
	
func _on_bet_15_18_14_17_mouse_entered():
	can_bet = true
	roulette_number = "15_18_14_17"

func _on_bet_15_18_14_17_mouse_exited():
	mouse_exited()

func _on_bet_18_17_mouse_entered():
	can_bet = true
	roulette_number = "18 and 17"

func _on_bet_18_17_mouse_exited():
	mouse_exited()

func _on_bet_18_21_17_20_mouse_entered():
	can_bet = true
	roulette_number = "18_21_17_20"

func _on_bet_18_21_17_20_mouse_exited():
	mouse_exited()


func _on_bet_21_20_mouse_entered():
	can_bet = true
	roulette_number = "21 and 20"

func _on_bet_21_20_mouse_exited():
	mouse_exited()

func _on_bet_20_mouse_entered():
	can_bet = true
	roulette_number = "20"

func _on_bet_20_mouse_exited():
	mouse_exited()

func _on_bet_20_23_mouse_entered():
	can_bet = true
	roulette_number = "20 and 23"

func _on_bet_20_23_mouse_exited():
	mouse_exited()

func _on_bet_21_24_20_23_mouse_entered():
	can_bet = true
	roulette_number = "21_24_20_23"

func _on_bet_21_24_20_23_mouse_exited():
	mouse_exited()

func _on_bet_24_23_mouse_entered():
	can_bet = true
	roulette_number = "24 and 23"

func _on_bet_24_23_mouse_exited():
	mouse_exited()

func _on_bet_3_6_2_5_mouse_entered():
	can_bet = true
	roulette_number = "3_6_2_5"

func _on_bet_3_6_2_5_mouse_exited():
	mouse_exited()

func _on_button_pressed():
	if len(player_bets) != 0:
		camera.position.y -= 750
		spin_wheel()


func spin_wheel():
	
	var selected_num = randi_range(0,37)
	selected_num = str(numbers[selected_num])
	
	number_label.text = "The roulette wheel landed on " + str(selected_num) + "."
	number_label.show()

	
	for bet in player_bets:
		
		match bet:
			"00":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"0":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"1":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"2":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"3":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"4":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"5":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"6":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"7":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"8":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"9":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"10":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"11":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"12":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"13":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"14":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"15":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"16":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"17":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"18":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"19":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"20":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"21":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"22":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"23":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"24":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"25":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"26":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"27":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"28":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"29":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"30":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"31":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"32":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"33":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"34":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"35":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"36":
				if selected_num == bet:
					balance += player_bets[roulette_number] * 36
			"1st12":
				if int(selected_num) > 0 and int(selected_num) <= 12:
					balance += player_bets[roulette_number] * 3
			"2nd12":
				if int(selected_num) > 12 and int(selected_num) <= 24:
					balance += player_bets[roulette_number] * 3
			"3rd12":
				if int(selected_num) > 24:
					balance += player_bets[roulette_number] * 3
			"1-18":
				if int(selected_num) > 0 and int(selected_num) < 19:
					balance += player_bets[roulette_number] * 2
			"19-36":
				if int(selected_num) > 18:
					balance += player_bets[roulette_number] * 2
			"Top Row":
				if int(selected_num) % 3 == 0:
					balance += player_bets[roulette_number] * 3
			"Middle Row":
				if int(selected_num) % 3 == 2:
					balance += player_bets[roulette_number] * 3
			"Bottom Row":
				if int(selected_num) % 3 == 1:
					balance += player_bets[roulette_number] * 3
			"Even":
				if int(selected_num) % 2 == 0:
					balance += player_bets[roulette_number] * 2
			"Odd":
				if int(selected_num) % 2 == 1:
					balance += player_bets[roulette_number] * 2
			"Red":
				const red = [
					1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36
				]
				for num in red:
					if int(selected_num) == num:
						balance += player_bets[roulette_number] * 2
						break
			"Black":
				const black = [
					2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35
				]
				for num in black:
					if int(selected_num) == num:
						balance += player_bets[roulette_number] * 2
						break
			"Green":
				if selected_num == "0" or selected_num == "00":
					balance += player_bets[roulette_number] * 17
			"1 and 4":
				if selected_num == "1" or selected_num == "4":
					balance += player_bets[roulette_number] * 17
			"2 and 5":
				if selected_num == "2" or selected_num == "5":
					balance += player_bets[roulette_number] * 17
			"3 and 6":
				if selected_num == "3" or selected_num == "6":
					balance += player_bets[roulette_number] * 17
			"4 and 7":
				if selected_num == "4" or selected_num == "7":
					balance += player_bets[roulette_number] * 17
			"5 and 8":
				if selected_num == "5" or selected_num == "8":
					balance += player_bets[roulette_number] * 17
			"6 and 9":
				if selected_num == "6" or selected_num == "9":
					balance += player_bets[roulette_number] * 17
			"7 and 10":
				if selected_num == "7" or selected_num == "10":
					balance += player_bets[roulette_number] * 17
			"8 and 11":
				if selected_num == "8" or selected_num == "11":
					balance += player_bets[roulette_number] * 17
			"9 and 12":
				if selected_num == "9" or selected_num == "12":
					balance += player_bets[roulette_number] * 17
			"10 and 13":
				if selected_num == "10" or selected_num == "13":
					balance += player_bets[roulette_number] * 17
			"11 and 14":
				if selected_num == "11" or selected_num == "14":
					balance += player_bets[roulette_number] * 17
			"12 and 15":
				if selected_num == "12" or selected_num == "15":
					balance += player_bets[roulette_number] * 17
			"13 and 16":
				if selected_num == "13" or selected_num == "16":
					balance += player_bets[roulette_number] * 17
			"14 and 17":
				if selected_num == "14" or selected_num == "17":
					balance += player_bets[roulette_number] * 17
			"15 and 18":
				if selected_num == "15" or selected_num == "18":
					balance += player_bets[roulette_number] * 17
			"16 and 19":
				if selected_num == "16" or selected_num == "19":
					balance += player_bets[roulette_number] * 17
			"17 and 20":
				if selected_num == "17" or selected_num == "20":
					balance += player_bets[roulette_number] * 17
			"18 and 21":
				if selected_num == "18" or selected_num == "21":
					balance += player_bets[roulette_number] * 17
			"19 and 22":
				if selected_num == "19" or selected_num == "22":
					balance += player_bets[roulette_number] * 17
			"20 and 23":
				if selected_num == "20" or selected_num == "23":
					balance += player_bets[roulette_number] * 17
			"21 and 24":
				if selected_num == "21" or selected_num == "24":
					balance += player_bets[roulette_number] * 17
			"22 and 25":
				if selected_num == "22" or selected_num == "25":
					balance += player_bets[roulette_number] * 17
			"23 and 26":
				if selected_num == "23" or selected_num == "26":
					balance += player_bets[roulette_number] * 17
			"24 and 27":
				if selected_num == "24" or selected_num == "27":
					balance += player_bets[roulette_number] * 17
			"25 and 28":
				if selected_num == "25" or selected_num == "28":
					balance += player_bets[roulette_number] * 17
			"26 and 29":
				if selected_num == "26" or selected_num == "29":
					balance += player_bets[roulette_number] * 17
			"27 and 30":
				if selected_num == "27" or selected_num == "30":
					balance += player_bets[roulette_number] * 17
			"28 and 31":
				if selected_num == "28" or selected_num == "31":
					balance += player_bets[roulette_number] * 17
			"29 and 32":
				if selected_num == "29" or selected_num == "32":
					balance += player_bets[roulette_number] * 17
			"30 and 33":
				if selected_num == "30" or selected_num == "33":
					balance += player_bets[roulette_number] * 17
			"31 and 34":
				if selected_num == "31" or selected_num == "34":
					balance += player_bets[roulette_number] * 17
			"32 and 35":
				if selected_num == "32" or selected_num == "35":
					balance += player_bets[roulette_number] * 17
			"33 and 36":
				if selected_num == "33" or selected_num == "36":
					balance += player_bets[roulette_number] * 17
			"1 and 2":
				if selected_num == "1" or selected_num == "2":
					balance += player_bets[roulette_number] * 17
			"2 and 3":
				if selected_num == "2" or selected_num == "3":
					balance += player_bets[roulette_number] * 17
			"4 and 5":
				if selected_num == "4" or selected_num == "5":
					balance += player_bets[roulette_number] * 17
			"5 and 6":
				if selected_num == "5" or selected_num == "6":
					balance += player_bets[roulette_number] * 17
			"7 and 8":
				if selected_num == "7" or selected_num == "8":
					balance += player_bets[roulette_number] * 17
			"8 and 9":
				if selected_num == "8" or selected_num == "9":
					balance += player_bets[roulette_number] * 17
			"10 and 11":
				if selected_num == "10" or selected_num == "11":
					balance += player_bets[roulette_number] * 17
			"11 and 12":
				if selected_num == "11" or selected_num == "12":
					balance += player_bets[roulette_number] * 17
			"13 and 14":
				if selected_num == "13" or selected_num == "14":
					balance += player_bets[roulette_number] * 17
			"14 and 15":
				if selected_num == "14" or selected_num == "15":
					balance += player_bets[roulette_number] * 17
			"16 and 17":
				if selected_num == "16" or selected_num == "17":
					balance += player_bets[roulette_number] * 17
			"17 and 18":
				if selected_num == "17" or selected_num == "18":
					balance += player_bets[roulette_number] * 17
			"19 and 20":
				if selected_num == "19" or selected_num == "20":
					balance += player_bets[roulette_number] * 17
			"20 and 21":
				if selected_num == "20" or selected_num == "21":
					balance += player_bets[roulette_number] * 17
			"22 and 23":
				if selected_num == "22" or selected_num == "23":
					balance += player_bets[roulette_number] * 17
			"23 and 24":
				if selected_num == "23" or selected_num == "24":
					balance += player_bets[roulette_number] * 17
			"25 and 26":
				if selected_num == "25" or selected_num == "26":
					balance += player_bets[roulette_number] * 17
			"26 and 27":
				if selected_num == "26" or selected_num == "27":
					balance += player_bets[roulette_number] * 17
			"28 and 29":
				if selected_num == "28" or selected_num == "29":
					balance += player_bets[roulette_number] * 17
			"29 and 30":
				if selected_num == "29" or selected_num == "30":
					balance += player_bets[roulette_number] * 17
			"31 and 32":
				if selected_num == "31" or selected_num == "32":
					balance += player_bets[roulette_number] * 17
			"32 and 33":
				if selected_num == "32" or selected_num == "33":
					balance += player_bets[roulette_number] * 17
			"34 and 35":
				if selected_num == "34" or selected_num == "35":
					balance += player_bets[roulette_number] * 17
			"35 and 36":
				if selected_num == "35" or selected_num == "36":
					balance += player_bets[roulette_number] * 17
			"3_6_2_5":
				if selected_num == "3" or selected_num == "6" or selected_num == "2" or selected_num == "5":
					balance += player_bets[roulette_number] * 6
			"2_5_1_4":
				if selected_num == "2" or selected_num == "5" or selected_num == "1" or selected_num == "4":
					balance += player_bets[roulette_number] * 6
			"6_9_5_8":
				if selected_num == "6" or selected_num == "9" or selected_num == "5" or selected_num == "8":
					balance += player_bets[roulette_number] * 6
			"5_8_4_7":
				if selected_num == "5" or selected_num == "8" or selected_num == "4" or selected_num == "7":
					balance += player_bets[roulette_number] * 6
			"9_12_8_11":
				if selected_num == "9" or selected_num == "12" or selected_num == "9" or selected_num == "11":
					balance += player_bets[roulette_number] * 6
			"8_11_7_10":
				if selected_num == "8" or selected_num == "11" or selected_num == "7" or selected_num == "10":
					balance += player_bets[roulette_number] * 6
			"12_15_11_14":
				if selected_num == "12" or selected_num == "15" or selected_num == "11" or selected_num == "14":
					balance += player_bets[roulette_number] * 6
			"11_14_10_13":
				if selected_num == "11" or selected_num == "14" or selected_num == "10" or selected_num == "13":
					balance += player_bets[roulette_number] * 6
			"15_18_14_17":
				if selected_num == "15" or selected_num == "18" or selected_num == "14" or selected_num == "17":
					balance += player_bets[roulette_number] * 6
			"14_17_13_16":
				if selected_num == "14" or selected_num == "17" or selected_num == "13" or selected_num == "16":
					balance += player_bets[roulette_number] * 6
			"18_21_17_20":
				if selected_num == "18" or selected_num == "21" or selected_num == "17" or selected_num == "20":
					balance += player_bets[roulette_number] * 6
			"17_20_16_19":
				if selected_num == "17" or selected_num == "20" or selected_num == "16" or selected_num == "19":
					balance += player_bets[roulette_number] * 6
			"21_24_20_23":
				if selected_num == "21" or selected_num == "24" or selected_num == "20" or selected_num == "23":
					balance += player_bets[roulette_number] * 6
			"20_23_19_22":
				if selected_num == "20" or selected_num == "23" or selected_num == "19" or selected_num == "22":
					balance += player_bets[roulette_number] * 6
			"24_27_23_26":
				if selected_num == "24" or selected_num == "27" or selected_num == "23" or selected_num == "26":
					balance += player_bets[roulette_number] * 6
			"23_26_22_25":
				if selected_num == "23" or selected_num == "26" or selected_num == "22" or selected_num == "25":
					balance += player_bets[roulette_number] * 6
			"27_30_26_29":
				if selected_num == "27" or selected_num == "30" or selected_num == "26" or selected_num == "29":
					balance += player_bets[roulette_number] * 6
			"26_29_25_28":
				if selected_num == "26" or selected_num == "29" or selected_num == "25" or selected_num == "28":
					balance += player_bets[roulette_number] * 6
			"30_33_29_32":
				if selected_num == "30" or selected_num == "33" or selected_num == "29" or selected_num == "32":
					balance += player_bets[roulette_number] * 6
			"29_32_28_31":
				if selected_num == "29" or selected_num == "32" or selected_num == "28" or selected_num == "31":
					balance += player_bets[roulette_number] * 6
			"33_36_32_35":
				if selected_num == "33" or selected_num == "36" or selected_num == "32" or selected_num == "35":
					balance += player_bets[roulette_number] * 6
			"32_35_31_34":
				if selected_num == "32" or selected_num == "35" or selected_num == "31" or selected_num == "34":
					balance += player_bets[roulette_number] * 6
			
			
					
		balance_text2.text = "Balance: " + str(balance)
		balance_text.text = "Balance: " + str(balance)
		
		clear_board()
		
	
		
	
func clear_board():
		player_bets.clear()
		var betting_board = [
			$MarginContainerSingles/GridContainerSingles/RouletteSlot, $MarginContainerSingles/GridContainerSingles/RouletteSlot2,$MarginContainerSingles/GridContainerSingles/RouletteSlot3,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot4,$MarginContainerSingles/GridContainerSingles/RouletteSlot5,$MarginContainerSingles/GridContainerSingles/RouletteSlot6,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot7,$MarginContainerSingles/GridContainerSingles/RouletteSlot8,$MarginContainerSingles/GridContainerSingles/RouletteSlot9,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot10,$MarginContainerSingles/GridContainerSingles/RouletteSlot11,$MarginContainerSingles/GridContainerSingles/RouletteSlot12,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot13,$MarginContainerSingles/GridContainerSingles/RouletteSlot14,$MarginContainerSingles/GridContainerSingles/RouletteSlot15,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot16,$MarginContainerSingles/GridContainerSingles/RouletteSlot17,$MarginContainerSingles/GridContainerSingles/RouletteSlot18,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot19,$MarginContainerSingles/GridContainerSingles/RouletteSlot20,$MarginContainerSingles/GridContainerSingles/RouletteSlot21,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot22,$MarginContainerSingles/GridContainerSingles/RouletteSlot23,$MarginContainerSingles/GridContainerSingles/RouletteSlot24,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot25,$MarginContainerSingles/GridContainerSingles/RouletteSlot26,$MarginContainerSingles/GridContainerSingles/RouletteSlot27,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot28,$MarginContainerSingles/GridContainerSingles/RouletteSlot29,$MarginContainerSingles/GridContainerSingles/RouletteSlot30,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot31,$MarginContainerSingles/GridContainerSingles/RouletteSlot32,$MarginContainerSingles/GridContainerSingles/RouletteSlot33,
			$MarginContainerSingles/GridContainerSingles/RouletteSlot34,$MarginContainerSingles/GridContainerSingles/RouletteSlot35,$MarginContainerSingles/GridContainerSingles/RouletteSlot36,
			$MarginContainerQuads/GridContainerQuads/RouletteSlot37,$MarginContainerQuads/GridContainerQuads/RouletteSlot38,$MarginContainerQuads/GridContainerQuads/RouletteSlot39,$MarginContainerQuads/GridContainerQuads/RouletteSlot40,
			$MarginContainerQuads/GridContainerQuads/RouletteSlot41,$MarginContainerQuads/GridContainerQuads/RouletteSlot42,$MarginContainerQuads/GridContainerQuads/RouletteSlot43,$MarginContainerQuads/GridContainerQuads/RouletteSlot44,
			$MarginContainerQuads/GridContainerQuads/RouletteSlot45,$MarginContainerQuads/GridContainerQuads/RouletteSlot46,$MarginContainerQuads/GridContainerQuads/RouletteSlot47,$MarginContainerQuads/GridContainerQuads/RouletteSlot48,
			$MarginContainerQuads/GridContainerQuads/RouletteSlot49,$MarginContainerQuads/GridContainerQuads/RouletteSlot50,$MarginContainerQuads/GridContainerQuads/RouletteSlot51,$MarginContainerQuads/GridContainerQuads/RouletteSlot52,
			$MarginContainerQuads/GridContainerQuads/RouletteSlot53,$MarginContainerQuads/GridContainerQuads/RouletteSlot54,$MarginContainerQuads/GridContainerQuads/RouletteSlot55,$MarginContainerQuads/GridContainerQuads/RouletteSlot56,
			$MarginContainerQuads/GridContainerQuads/RouletteSlot57,$MarginContainerQuads/GridContainerQuads/RouletteSlot58,$MarginContainerVertDoubles/GridContainer/RouletteSlot59,$MarginContainerVertDoubles/GridContainer/RouletteSlot60,
			$MarginContainerVertDoubles/GridContainer/RouletteSlot61,$MarginContainerVertDoubles/GridContainer/RouletteSlot62,$MarginContainerVertDoubles/GridContainer/RouletteSlot63,$MarginContainerVertDoubles/GridContainer/RouletteSlot64,
			$MarginContainerVertDoubles/GridContainer/RouletteSlot65,$MarginContainerVertDoubles/GridContainer/RouletteSlot66,$MarginContainerVertDoubles/GridContainer/RouletteSlot67,$MarginContainerVertDoubles/GridContainer/RouletteSlot68,
			$MarginContainerVertDoubles/GridContainer/RouletteSlot69,$MarginContainerVertDoubles/GridContainer/RouletteSlot70,$MarginContainerVertDoubles/GridContainer/RouletteSlot71,$MarginContainerVertDoubles/GridContainer/RouletteSlot72,
			$MarginContainerVertDoubles/GridContainer/RouletteSlot73,$MarginContainerVertDoubles/GridContainer/RouletteSlot74,$MarginContainerVertDoubles/GridContainer/RouletteSlot75,$MarginContainerVertDoubles/GridContainer/RouletteSlot76,
			$MarginContainerVertDoubles/GridContainer/RouletteSlot77,$MarginContainerVertDoubles/GridContainer/RouletteSlot78,$MarginContainerVertDoubles/GridContainer/RouletteSlot79,$MarginContainerVertDoubles/GridContainer/RouletteSlot80,
			$MarginContainerVertDoubles/GridContainer/RouletteSlot81,$MarginContainerVertDoubles/GridContainer/RouletteSlot82,$MarginContainerVertDoubles/GridContainer/RouletteSlot83,$MarginContainerVertDoubles/GridContainer/RouletteSlot84,
			$MarginContainerVertDoubles/GridContainer/RouletteSlot85,$MarginContainerVertDoubles/GridContainer/RouletteSlot86,$MarginContainerVertDoubles/GridContainer/RouletteSlot87,$MarginContainerVertDoubles/GridContainer/RouletteSlot88,
			$MarginContainerVertDoubles/GridContainer/RouletteSlot89,$MarginContainerVertDoubles/GridContainer/RouletteSlot90,$MarginContainerVertDoubles/GridContainer/RouletteSlot91,$MarginContainerHorzDoubles/GridContainer/RouletteSlot92,
			$MarginContainerHorzDoubles/GridContainer/RouletteSlot93,$MarginContainerHorzDoubles/GridContainer/RouletteSlot94,$MarginContainerHorzDoubles/GridContainer/RouletteSlot95,$MarginContainerHorzDoubles/GridContainer/RouletteSlot96,
			$MarginContainerHorzDoubles/GridContainer/RouletteSlot97,$MarginContainerHorzDoubles/GridContainer/RouletteSlot98,$MarginContainerHorzDoubles/GridContainer/RouletteSlot99,$MarginContainerHorzDoubles/GridContainer/RouletteSlot100,
			$MarginContainerHorzDoubles/GridContainer/RouletteSlot100,$MarginContainerHorzDoubles/GridContainer/RouletteSlot101,$MarginContainerHorzDoubles/GridContainer/RouletteSlot102,$MarginContainerHorzDoubles/GridContainer/RouletteSlot103,
			$MarginContainerHorzDoubles/GridContainer/RouletteSlot104,$MarginContainerHorzDoubles/GridContainer/RouletteSlot105,$MarginContainerHorzDoubles/GridContainer/RouletteSlot106,$MarginContainerHorzDoubles/GridContainer/RouletteSlot107,
			$MarginContainerHorzDoubles/GridContainer/RouletteSlot108,$MarginContainerHorzDoubles/GridContainer/RouletteSlot109,$MarginContainerHorzDoubles/GridContainer/RouletteSlot110,$MarginContainerHorzDoubles/GridContainer/RouletteSlot111,
			$MarginContainerHorzDoubles/GridContainer/RouletteSlot112,$MarginContainerHorzDoubles/GridContainer/RouletteSlot113,$MarginContainerHorzDoubles/GridContainer/RouletteSlot114,$MarginContainerHorzDoubles/GridContainer/RouletteSlot115
		]
		for item in betting_board:
			if item.texture != null:
				item.texture = null

func _on_wheel_timer_timeout():
	label_num = randi_range(0,37)
	number_label.text = numbers[label_num]


func _on_back_to_board_button_down():
	camera.position.y += 750


func _on_red_mouse_entered():
	can_bet = true
	roulette_number = "Red"

func _on_red_mouse_exited():
	mouse_exited()
