/obj/item/stack/sheet
	name = "sheet"
	layer = UPPER_ITEM_LAYER
	w_class = SIZE_MEDIUM
	force = 0
	throwforce = 5
	max_amount = 50
	throw_speed = SPEED_VERY_FAST
	throw_range = 3
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	var/perunit = 3750
	var/sheettype = null //this is used for girders in the creation of walls/false walls