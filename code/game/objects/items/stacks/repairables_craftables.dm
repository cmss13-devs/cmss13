//the fact that the item stacking mechanic are specifically pathed to the stacks parent file is horrible

/obj/item/stack/repairable
	name = "repo item"
	singular_name = "repo item"
	desc = "this is just a parent item, doesnt do shit"
	w_class = SIZE_SMALL
	amount = 10
	max_amount = 10


/obj/item/stack/repairable/gunlube
	name = "Multi-purpose combat lubricant"
	singular_name = "combat lubricant"
	desc = "If God wasn't real, then he would have never made something as awe-inspiring to the average room-temperature IQ grunt of the USCM. Use this to repair your damaged equipment."
	w_class = SIZE_TINY
	icon = 'icons/obj/items/clothing/helmet_garb.dmi'
	icon_state = "gunoil" //for now
	amount = 10
	max_amount = 10
	stack_id = "combatoil"

/obj/item/stack/repairable/gunkit
	name = "firearms repair kit"
	singular_name = "essential firearms-tool"
	desc = "A small kit containing the necessary tools to repair any broken firearm. Shamefully, the tools inside are a tad bit too small for use outside of firearms."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "upgradekit" //for now
	amount = 5
	max_amount = 5
	stack_id = "gunkit"
