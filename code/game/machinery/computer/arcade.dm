///Minesweeper Field boundaries
#define FIELD_SMALL list(8,8)
/// if an individual cell is a landmine
#define LANDMINE -1
/// if an individual cell is CLEAR (No numbers either)
#define	CLEAR -2
/// if an individual cell is closed
#define CELL_CLOSED "closed"
/// if an individual cell is open
#define CELL_OPEN "open"
/// if game state / player is currently playing
#define PLAYING "0"
///if minesweeper game was LOST
#define LOST "1"
/// game_state minesweeper was WON
#define WON "2"

/obj/structure/machinery/computer/arcade
	name = "Black Donnovan II: Double Revenge"
	desc = "Two years after the average high school teenager Josh transformed into the powerful ninja 'Black Donnovan' and defeated the evil forces of Colonel Ranchenko and his UPP experiments to save his captured ninja girlfriend Reino, chaos is unleashed again on the world. Josh's Canadian cousin, transforming into the powerful ninja 'Fury Fuhrer', has created a world in Florida no longer exists. Josh once again transforms into 'Black Donnovan' to fight against Fury Fuhrer's legions of goons and restore the hellscape world to its former glory."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "arcade"
	circuit = /obj/item/circuitboard/computer/arcade
	unacidable = FALSE
	density = TRUE
	black_market_value = 35 //mendoza likes games
	var/enemy_name = "Fury Fuhrer"
	var/temp = "Sponsored by Weyland-Yutani and the United States Colonial Marines" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 50 //Enemy health/attack points
	var/enemy_mp = 25
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set
	var/list/prizes = list( /obj/item/tool/lighter/zippo = 4,
							/obj/item/spacecash/ewallet = 3,
								worth = 25,
							/obj/item/facepaint/sniper = 4,
							/obj/item/toy/gun = 4,
							/obj/item/toy/crossbow = 4,
							/obj/item/toy/sword = 5,
							/obj/item/toy/katana = 1,
							/obj/item/toy/spinningtoy = 2,
							/obj/item/toy/prize/ripley = 2,
							/obj/item/toy/prize/fireripley = 2,
							/obj/item/toy/prize/deathripley = 2,
							/obj/item/toy/prize/gygax = 2,
							/obj/item/toy/prize/durand = 2,
							/obj/item/toy/prize/honk = 2,
							/obj/item/toy/prize/marauder = 2,
							/obj/item/toy/prize/seraph = 2,
							/obj/item/toy/prize/mauler = 2,
							/obj/item/toy/prize/odysseus = 2,
							/obj/item/toy/bikehorn = 2, // honk
							/obj/item/clothing/head/collectable/tophat/super = 2,
							/obj/item/toy/plush/farwa = 2,
							/obj/item/toy/plush/barricade = 2,
							/obj/item/toy/plush/shark = 2,
							/obj/item/toy/plush/bee = 2,
							/obj/item/toy/plush/gnarp = 2,
							/obj/item/toy/plush/gnarp/alt = 2,
							/obj/item/toy/plush/rock = 5,
							/obj/item/storage/box/snappops = 5,
							/obj/item/facepaint/lipstick = 1,
							/obj/item/facepaint/lipstick/jade = 1,
							/obj/item/clothing/head/headband/gray = 5,
							/obj/item/clothing/head/headband/red = 5,
							/obj/item/clothing/mask/tornscarf = 5,
							)

/obj/structure/machinery/computer/arcade
	var/turtle = 0

/obj/structure/machinery/computer/arcade/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/computer/arcade/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_interaction(src)
	var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a>"
	dat += "<center><h4>[src.enemy_name]</h4></center>"

	dat += "<br><center><h3>[src.temp]</h3></center>"
	dat += "<br><center>Health: [src.player_hp]|Magic: [src.player_mp]|Enemy Health: [src.enemy_hp]</center>"

	if (src.gameover)
		dat += "<center><b><a href='byond://?src=\ref[src];newgame=1'>New Game</a>"
	else
		dat += "<center><b><a href='byond://?src=\ref[src];attack=1'>Attack</a>|"
		dat += "<a href='byond://?src=\ref[src];heal=1'>Heal</a>|"
		dat += "<a href='byond://?src=\ref[src];charge=1'>Recharge Power</a>"

	dat += "</b></center>"

	show_browser(user, dat, name, "arcade")
	return

/obj/structure/machinery/computer/arcade/Topic(href, href_list)
	if(..())
		return

	if (!src.blocked && !src.gameover)
		if (href_list["attack"])
			src.blocked = 1
			var/attackamt = rand(2,6)
			src.temp = "Your sword strikes for [attackamt] damage!"
			src.updateUsrDialog()
			if(turtle > 0)
				turtle--

			sleep(10)
			src.enemy_hp -= attackamt
			src.arcade_action()

		else if (href_list["heal"])
			src.blocked = 1
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			src.temp = "You use [pointamt] magic to heal for [healamt] damage!"
			src.updateUsrDialog()
			turtle++

			sleep(10)
			src.player_mp -= pointamt
			src.player_hp += healamt
			src.blocked = 1
			src.updateUsrDialog()
			src.arcade_action()

		else if (href_list["charge"])
			src.blocked = 1
			var/chargeamt = rand(4,7)
			src.temp = "You regain [chargeamt] points"
			src.player_mp += chargeamt
			if(turtle > 0)
				turtle--

			src.updateUsrDialog()
			sleep(10)
			src.arcade_action()

	if (href_list["close"])
		usr.unset_interaction()
		close_browser(usr, "arcade")

	else if (href_list["newgame"]) //Reset everything
		temp = "New Round"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		turtle = 0

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/structure/machinery/computer/arcade/proc/arcade_action()
	if ((src.enemy_mp <= 0) || (src.enemy_hp <= 0))
		if(!gameover)
			src.gameover = 1
			src.temp = "[src.enemy_name] has fallen! Rejoice!"

			if(!length(contents))
				var/prizeselect = pick_weight(prizes)
				new prizeselect(src.loc)

				if(istype(prizeselect, /obj/item/toy/gun)) //Ammo comes with the gun
					new /obj/item/toy/gun_ammo(src.loc)

				else if(istype(prizeselect, /obj/item/clothing/suit/syndicatefake)) //Helmet is part of the suit
					new /obj/item/clothing/head/syndicatefake(src.loc)

			else
				var/atom/movable/prize = pick(contents)
				prize.forceMove(loc)

	else if ((src.enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		src.temp = "[src.enemy_name] steals [stealamt] of your power!"
		src.player_mp -= stealamt
		src.updateUsrDialog()

		if (src.player_mp <= 0)
			src.gameover = 1
			sleep(10)
			src.temp = "You have been drained! GAME OVER"

	else if ((src.enemy_hp <= 10) && (src.enemy_mp > 4))
		src.temp = "[src.enemy_name] heals for 4 health!"
		src.enemy_hp += 4
		src.enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		src.temp = "[src.enemy_name] attacks for [attackamt] damage!"
		src.player_hp -= attackamt

	if ((src.player_mp <= 0) || (src.player_hp <= 0))
		src.gameover = 1
		src.temp = "GAME OVER"

	src.blocked = 0
	return

/obj/structure/machinery/computer/arcade/emp_act(severity)
	. = ..()
	if(inoperable())
		return
	var/empprize = null
	var/num_of_prizes = 0
	switch(severity)
		if(1)
			num_of_prizes = rand(1,4)
		if(2)
			num_of_prizes = rand(0,2)
	for(num_of_prizes; num_of_prizes > 0; num_of_prizes--)
		empprize = pick_weight(prizes)
		new empprize(src.loc)

/obj/structure/machinery/computer/arcade/minesweeper
	name = "Double CLF strike: IED Edition"
	///amount of mines on the field
	var/difficulty = 10
	///whether you can lose with first click. technically if this is on we generate the mines AFTER the click was made. if not we generate it immediatly.
	var/first_click_safety = TRUE
	///if the first click was made
	var/first_click_made = FALSE
	var/list/field_boundaries = FIELD_SMALL
	///a var used for mine and field inner workings
	var/diagonal_spot = 7
	///if the game should not send any to_chats to user
	var/quiet_game = FALSE
	///if user can modify the game difficulty at will.
	var/settings_unlocked = FALSE
	///the 2D assosiate list with number, state and ID for each cell
	var/list/field
	var/game_state = PLAYING
	///Height that will be applied the next time field is generated.
	var/new_height = null
	///width that will be applied the next time field is generated.
	var/new_width = null
	///amount of mines that will be applied the next time field is generated.
	var/new_difficulty = null
	// cooldown to prevent from spam-generating a bunch of fields.
	COOLDOWN_DECLARE(field_generation)

/obj/structure/machinery/computer/arcade/minesweeper/Initialize(mapload, list/field_boundaries = FIELD_SMALL, difficulty = 10, settings_unlocked = FALSE)
	. = ..()
	src.field_boundaries = field_boundaries
	src.difficulty = difficulty
	src.settings_unlocked = settings_unlocked
	initiate_list()

/obj/structure/machinery/computer/arcade/minesweeper/attack_hand(mob/user)
	tgui_interact(user)

/obj/structure/machinery/computer/arcade/minesweeper/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Minesweeper", name)
		ui.open()

/obj/structure/machinery/computer/arcade/minesweeper/ui_state(mob/user)
	return GLOB.human_adjacent_two_state

/obj/structure/machinery/computer/arcade/minesweeper/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("open_cell")
			if(game_state != PLAYING)
				return
			for(var/columns in 1 to field_boundaries[1])
				for(var/rows in 1 to field_boundaries[2])
					if(field[columns][rows]["unique_cell_id"] == params["id"])
						if(field[columns][rows]["state"] != CELL_CLOSED)
							return
						open_cell(columns, rows, ui.user)
						if(!first_click_made)
							populate_field_with_mines()
							first_click_made = TRUE
							open_cell(columns, rows)
						return
		if("restart")
			if(COOLDOWN_FINISHED(src, field_generation) && game_state == PLAYING)
				lose_game()
				first_click_made = FALSE
				game_state = LOST
				COOLDOWN_START(src, field_generation, 20 SECONDS)
				to_chat(ui.user, SPAN_WARNING("Forfeited the field! New field in 5 seconds. you're on 20 second cooldown to forfeit again."))
				return TRUE
			else
				to_chat(ui.user, SPAN_WARNING("You have to wait before forfeiting this field again."))
		if("flag")
			for(var/columns in 1 to field_boundaries[1])
				for(var/rows in 1 to field_boundaries[2])
					if(field[columns][rows]["unique_cell_id"] == params["id"] && game_state == PLAYING)
						field[columns][rows]["flagged"] = !field[columns][rows]["flagged"]
		if("change_difficulty")
			if(settings_unlocked)
				new_width = tgui_input_number(ui.user, "Width for a new field. Must be within 4-20 range. using unequal width and height is not advised.","Width for new field", 8, 20, 4, 20 SECONDS)
				new_height = tgui_input_number(ui.user, "Height for a new field. Must be within 4-20 range. using unequal width and height is not advised.","Height for new field", 8, 20, 4, 20 SECONDS)
				new_difficulty = tgui_input_number(ui.user, "Amount of landmines for a new field. Must be within 5-80 range. A low number on a big board might cause internal CPU to throttle.","Amount of landmines", 8, 80, 5, 20 SECONDS)

	playsound(ui.user, get_sfx("keyboard"), 10, 1)

/obj/structure/machinery/computer/arcade/minesweeper/ui_data(mob/user)
	. = ..()
	var/list/data = list()
	data["boundaries"] = field_boundaries
	data["difficulty"] = difficulty
	data["field"] = field
	data["unlocked"] = settings_unlocked
	data["game_state"] = game_state
	return data

/obj/structure/machinery/computer/arcade/minesweeper/proc/open_cell(columns, rows, mob/user)
	if(field[columns][rows]["cell_type"] != CLEAR || field[columns][rows]["cell_type"] != LANDMINE) // passing this means its a "number" cell
		field[columns][rows]["state"] = CELL_OPEN
	if(field[columns][rows]["cell_type"] == CLEAR && !first_click_made)//field is not generated, fake open it.
		field[columns][rows]["state"] = CELL_OPEN
		return
	if(field[columns][rows]["cell_type"] == CLEAR)
		var/cell_id = field[columns][rows]["unique_cell_id"]
		field[columns][rows]["state"] = CELL_OPEN
		//opening adjacent NUMBER cells
		var/list/adjacent_fields = list(cell_id-diagonal_spot, cell_id-diagonal_spot+1, cell_id-diagonal_spot+2, cell_id-1, cell_id+1, cell_id+diagonal_spot-1, cell_id+diagonal_spot-2, cell_id+diagonal_spot)
		for(var/adjacent_cell_collumn in 1 to field_boundaries[1])
			for(var/adjacent_cell_rows in 1 to field_boundaries[2])
				if(field[adjacent_cell_collumn][adjacent_cell_rows]["unique_cell_id"] in adjacent_fields)
					if(rows - adjacent_cell_rows  > 1 || rows - adjacent_cell_rows < -1)
						continue
					if(field[adjacent_cell_collumn][adjacent_cell_rows]["cell_type"] == LANDMINE || field[adjacent_cell_collumn][adjacent_cell_rows]["state"] == CELL_OPEN )
						continue //dont want to auto open a landmine or get infinite loop lmao
					open_cell(adjacent_cell_collumn, adjacent_cell_rows)//recursive open
	if(field[columns][rows]["cell_type"] == LANDMINE)
		lose_game(user)

	check_win_condition(user)

/obj/structure/machinery/computer/arcade/minesweeper/proc/check_win_condition(mob/user)
	if(game_state == LOST)
		return
	for(var/cell_collumn in 1 to field_boundaries[1])
		for(var/cell_rows in 1 to field_boundaries[2])
			if(field[cell_collumn][cell_rows]["state"] != CELL_OPEN && field[cell_collumn][cell_rows]["cell_type"] != LANDMINE)
				return
	if(!quiet_game)
		to_chat(user, SPAN_WARNING("You won! New field in 5 seconds."))
	game_state = WON
	SEND_SIGNAL(src, COMSIG_MINESWEEPER_WON, user)
	addtimer(CALLBACK(src, PROC_REF(initiate_list)), 5 SECONDS)



/obj/structure/machinery/computer/arcade/minesweeper/proc/lose_game(mob/user)
	if(game_state == WON)
		return
	game_state = LOST
	SEND_SIGNAL(src, COMSIG_MINESWEEPER_LOST, user)
	addtimer(CALLBACK(src, PROC_REF(initiate_list)), 5 SECONDS)
	for(var/columns in 1 to field_boundaries[1])
		for(var/rows in 1 to field_boundaries[2])
			if(field[columns][rows]["cell_type"] == LANDMINE)
				field[columns][rows]["state"] = CELL_OPEN
	if(!quiet_game)
		to_chat(user, SPAN_WARNING("Boom! You lost. New field in 5 seconds!"))



/obj/structure/machinery/computer/arcade/minesweeper/proc/populate_field_with_mines()
	for(var/i in 1 to difficulty)
		var/picked_column = rand(1, field_boundaries[1])
		var/picked_row = rand(1, field_boundaries[2])
		var/list/picked_cell = field[picked_column][picked_row]
		//cell picked is already a mine or is open - 5 attempts at relocating
		if(picked_cell["cell_type"] == LANDMINE || picked_cell["state"] == CELL_OPEN)
			for(var/reassign_loop in 1 to 5)
				picked_row = rand(1, field_boundaries[2])
				picked_cell = field[rand(1, field_boundaries[1])][picked_row]
				if(picked_cell["cell_type"] != LANDMINE)
					break
		picked_cell["cell_type"] = LANDMINE
		increment_neighbour_cells(picked_cell["unique_cell_id"], picked_row)

/obj/structure/machinery/computer/arcade/minesweeper/proc/increment_neighbour_cells(cell_id, origin_row)
	var/list/cells_to_increment = list(cell_id-diagonal_spot, cell_id-diagonal_spot+1, cell_id-diagonal_spot+2, cell_id-1, cell_id+1, cell_id+diagonal_spot-1, cell_id+diagonal_spot-2, cell_id+diagonal_spot)
	for(var/columns in 1 to field_boundaries[1])
		for(var/rows in 1 to field_boundaries[2])
			if(field[columns][rows]["unique_cell_id"] in cells_to_increment)
				if(origin_row - rows > 1 ||origin_row  - rows < -1)
					continue
				if(field[columns][rows]["cell_type"] == CLEAR)
					field[columns][rows]["cell_type"] = 0
				if(field[columns][rows]["cell_type"] == LANDMINE)
					continue
				field[columns][rows]["cell_type"]++

/obj/structure/machinery/computer/arcade/minesweeper/proc/initiate_list()
	if(new_width)
		field_boundaries[1] = new_width
		new_width = null
	if(new_height)
		field_boundaries[2] = new_height
		new_height = null
	if(new_difficulty)
		difficulty = new_difficulty
		new_difficulty = null

	var/list/temp_field = new/list(field_boundaries[1],field_boundaries[2])
	game_state = PLAYING
	diagonal_spot = field_boundaries[2] + 1
	var/counter = 0
	for(var/columns in 1 to field_boundaries[1])
		for(var/rows in 1 to field_boundaries[2])
			temp_field[columns][rows] += list(
				"cell_type" = CLEAR,
				"state" = CELL_CLOSED,
				"unique_cell_id" = counter,
				"flagged" = FALSE
				)
			counter++
	field = temp_field
	first_click_made = FALSE
	if(!first_click_safety)
		first_click_made = TRUE
		populate_field_with_mines()

#undef	FIELD_SMALL
#undef	LANDMINE
#undef	CLEAR
#undef	CELL_CLOSED
#undef	CELL_OPEN
#undef	PLAYING
#undef	LOST
#undef	WON

