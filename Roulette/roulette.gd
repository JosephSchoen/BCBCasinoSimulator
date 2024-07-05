extends Node2D

@onready var balance = 100
var can_bet = false
var blue_chip = false
var black_chip = false
var chip_grabbed = false
var current_chip = ""
@onready var current_bet = $"BettingNodes/3" as Area2D
@onready var balance_text = $Label as Label
@onready var cannot_bet = $CannotBet as Label
@onready var timer = $Timer as Timer
var chip_color = ""

var bet_amount = 0
var roulette_number = null
var player_bets = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	balance_text.text = "Balance: " + str(balance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
				cannot_bet.text = "Sorry, you do not have the funds to do that."
				cannot_bet.show()
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
				cannot_bet.text = "Sorry, you do not have the funds to do that."
				cannot_bet.show()
				timer.start(3)
	
	# If the player is in a spot where they can bet
	if can_bet == true:
		if chip_grabbed == true:
			if Input.is_action_just_pressed("Left Click"):
				chip_grabbed = !chip_grabbed
				bet_select()
				place_bet()
		else:
			# Checks if the player can grab a dropped chip
			if player_has_bet_on_number(roulette_number):
				# If the player left clicks
				if Input.is_action_just_pressed("Left Click"):
					# Set chip_grabbed to true (The player picks up the last chip place)
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
					print(player_bets)
					# Get the chip color
					chip_color = get_chip(bet_amount)
					return_bet()
					
				
			
	elif chip_grabbed == true:
		for key in player_bets:
			if key == roulette_number:
				if Input.is_action_just_pressed("Left Click"):
					chip_grabbed = true
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

func player_has_bet_on_number(roulette_number) -> bool:
	for number in player_bets:
		if number == roulette_number:
			return true
	return false

# Number 3 on roulette table
func _on_bet_num_3_mouse_entered():
	can_bet = true
	current_bet = $"BettingNodes/3" as Area2D
	roulette_number = 3

# Number 3 on roulette table
func _on_bet_num_3_mouse_exited():
	can_bet = false
	roulette_number = null

# Player's mouse enters blue chip area
func _on_texture_rect_2_mouse_entered():
	blue_chip = true
	
# Player's mouse exits blue chip area
func _on_texture_rect_2_mouse_exited():
	blue_chip = false

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
	cannot_bet.hide()
