/datum/chess_piece
	var/name = "chess piece"
	var/color = "white"
	var/board_x_pos = 0
	var/board_y_pos = 0

/datum/chess_piece/New(var/set_name, var/set_color)
	color = "[set_color]"
	name = "[set_name]"

/// Toy Board Parent Object, for board games
/obj/item/toy/board
	name = "Chess Board"
	desc = "A simple chess board"
	icon = 'icons/obj/items/playing_cards.dmi'
	icon_state = "deck"
	w_class = SIZE_MEDIUM
	has_special_table_placement = TRUE

	var/list/white_chess_pieces = list(
		new /datum/chess_piece("rook", "white"),
		new /datum/chess_piece("rook", "white"),
		new /datum/chess_piece("knight", "white"),
		new /datum/chess_piece("knight", "white"),
		new /datum/chess_piece("bishop", "white"),
		new /datum/chess_piece("bishop", "white"),
		new /datum/chess_piece("queen", "white"),
		new /datum/chess_piece("king", "white"),
		new /datum/chess_piece("pawn", "white"),
		new /datum/chess_piece("pawn", "white"),
		new /datum/chess_piece("pawn", "white"),
		new /datum/chess_piece("pawn", "white"),
		new /datum/chess_piece("pawn", "white"),
		new /datum/chess_piece("pawn", "white"),
		new /datum/chess_piece("pawn", "white"),
		new /datum/chess_piece("pawn", "white")
	)

	var/list/black_chess_pieces = list(
		new /datum/chess_piece("rook", "black"),
		new /datum/chess_piece("rook", "black"),
		new /datum/chess_piece("knight", "black"),
		new /datum/chess_piece("knight", "black"),
		new /datum/chess_piece("bishop", "black"),
		new /datum/chess_piece("bishop", "black"),
		new /datum/chess_piece("queen", "black"),
		new /datum/chess_piece("king", "black"),
		new /datum/chess_piece("pawn", "black"),
		new /datum/chess_piece("pawn", "black"),
		new /datum/chess_piece("pawn", "black"),
		new /datum/chess_piece("pawn", "black"),
		new /datum/chess_piece("pawn", "black"),
		new /datum/chess_piece("pawn", "black"),
		new /datum/chess_piece("pawn", "black"),
		new /datum/chess_piece("pawn", "black")
	)

	var/TestValue = 0


/obj/item/toy/board/Initialize()
	. = ..()

/// When Chess Board is moved, the board shakens
/obj/item/toy/board/Move(NewLoc, direct)
	..()
	if(table_setup)
		teardown()

/// When Chess Board is placed onto a table
/obj/item/toy/board/set_to_table(obj/structure/surface/target)
	..()
	if(table_setup)
		icon_state = "deck_uno"

/// Disassembly of Chess Board
/obj/item/toy/board/teardown()
	..()
	icon_state = "deck"

/// On click of Chessboard
/obj/item/toy/board/attack_hand(mob/user)
	if(!table_setup)
		return ..()
	else
		tgui_interact(user)


/// TGUI
/obj/item/toy/board/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChessBoard", name)
		ui.open()

/obj/item/toy/board/ui_data(mob/user)
	var/list/data = list()
	data["white_chess_pieces"] = list()
	data["black_chess_pieces"] = list()

	for(var/datum/chess_piece/piece as anything in white_chess_pieces)
		var/list/piece_data = list()
		piece_data["name"] = piece.name
		piece_data["color"] = piece.color
		data["white_chess_pieces"] += list(piece_data)

	for(var/datum/chess_piece/piece as anything in black_chess_pieces)
		var/list/piece_data = list()
		piece_data["name"] = piece.name
		piece_data["color"] = piece.color
		data["black_chess_pieces"] += list(piece_data)

	data["health"] = TestValue
	data["color"] = "red"
	return data

/obj/item/toy/board/ui_act(action, params)
	if(..())
		return

	// On action
	switch(action)
		if("test")
			TestValue += 1
