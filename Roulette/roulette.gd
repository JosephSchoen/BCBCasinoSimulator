extends Node2D

@onready var balance = 100
var can_bet = false
var blue_chip = false
var black_chip = false
var chip_grabbed = false
var current_chip = ""
@onready var balance_text = $Label as Label
@onready var cannot_bet_label = $CannotBet as Label
@onready var timer = $Timer as Timer
var chip_color = ""

@onready var chip_sprite = preload("res://chip.tscn")

var bet_amount = 0
var roulette_number = null
var player_bets = {}

var can_place_chip = false


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
				print(roulette_number)
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
						# Grab the list of bets associated with the roulette number
						var value = player_bets[roulette_number]
						# Grab the last amount betted from the list
						bet_amount = value[len(value) - 1]
						# Remove this value from the list since the player is picking it up
						value.remove_at(len(value)-1)
						# If there are no more bets at that number, remove the key-value pair from the dictionary
						if len(value) == 0:
							player_bets.erase(roulette_number)
						# Otherwise, assign the value of the key to be the new list
						else:
							player_bets[roulette_number] = value
						# Get the chip color
						chip_color = get_chip(bet_amount)
						return_bet()
				
	"""	
	elif chip_grabbed == true:
		for key in player_bets:
			if key == roulette_number:
				if Input.is_action_just_pressed("Left Click"):
					chip_grabbed = !chip_grabbed
					var value_pair = player_bets[roulette_number]
					var bet = value_pair[len(value_pair) - 1]
					value_pair.remove_at(len(value_pair)-1)
					if len(value_pair) == 0:
						player_bets.erase(roulette_number)
					else:
						player_bets[roulette_number] = value_pair
					print(player_bets)
					chip_color = get_chip(bet)
					return_bet()
	"""
	

func player_has_bet_on_number(roulette_number) -> bool:
	for number in player_bets:
		if number == roulette_number:
			return true
	return false



# Decreases the player's balance by their selected bet amount
func place_bet():
	match chip_color:
		"White Chip":
			balance -= 1
		"Red Chip":
			balance -= 5
		"Blue Chip":
			balance -= 10
		"Green Chip":
			balance -= 25
		"Black Chip":
			balance -= 100
	
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
			player_bets[key].append(bet_amount)
			# Switch found to true to prevent the function from satisfying the below if statement
			found = true
			# Break out of the loop
			break
	# If the player has not bet on this value, we add the key-value pair to the dictionary
	if found == false:
		player_bets[roulette_number] = [bet_amount]
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
	roulette_number = "2356"

func _on_bet_2356_mouse_exited():
	mouse_exited()

func mouse_exited():
	can_bet = false

func _on_bet_3_and_6_mouse_entered():
	can_bet = true
	roulette_number = "3and6"

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
	roulette_number = "6,9,5,8"

func _on_bet_6_9_5_8_mouse_exited():
	mouse_exited()

func _on_bet_9_8_mouse_entered():
	can_bet = true
	roulette_number = "9 and 8"

func _on_bet_9_8_mouse_exited():
	mouse_exited()

func _on_bet_9_12_8_11_mouse_entered():
	can_bet = true
	roulette_number = "9,12,8,11"


func _on_bet_9_12_8_11_mouse_exited():
	mouse_exited()


func _on_bet_12_11_mouse_entered():
	can_bet = true
	roulette_number = "12 and 11"


func _on_bet_12_11_mouse_exited():
	mouse_exited()


func _on_bet_12_15_11_14_mouse_entered():
	can_bet = true
	roulette_number = "12,15,11,14"


func _on_bet_12_15_11_14_mouse_exited():
	mouse_exited()

func _on_bet_15_14_mouse_entered():
	can_bet = true
	roulette_number = "15 and 14"

func _on_bet_15_14_mouse_exited():
	mouse_exited()
	
func _on_bet_15_18_14_17_mouse_entered():
	can_bet = true
	roulette_number = "15,18,14,17"

func _on_bet_15_18_14_17_mouse_exited():
	mouse_exited()

func _on_bet_18_17_mouse_entered():
	can_bet = true
	roulette_number = "18 and 17"

func _on_bet_18_17_mouse_exited():
	mouse_exited()

func _on_bet_18_21_17_20_mouse_entered():
	can_bet = true
	roulette_number = "18,21,17,20"

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
	roulette_number = "21,24,20,23"

func _on_bet_21_24_20_23_mouse_exited():
	mouse_exited()

func _on_bet_24_23_mouse_entered():
	can_bet = true
	roulette_number = "24 and 23"

func _on_bet_24_23_mouse_exited():
	mouse_exited()

func _on_bet_3_6_2_5_mouse_entered():
	can_bet = true
	roulette_number = "3,6,2,5"

func _on_bet_3_6_2_5_mouse_exited():
	mouse_exited()
