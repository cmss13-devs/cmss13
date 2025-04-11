//the fact that the item stacking mechanic are specifically pathed to the stacks parent file is horrible

/obj/item/stack/repairable
	name = "repo item"
	singular_name = "repo item"
	desc = "You shouldn't see this, submit a bug report if you do."
	w_class = SIZE_SMALL
	amount = 10
	max_amount = 10
	var/repair_amount_min = 1
	var/repair_amount_max = 10
	var/list/repair_verb = list()
	var/repair_time = 69 SECONDS //in seconds, ideally

/obj/item/stack/repairable/gunlube
	name = "Multi-purpose combat lubricant"
	singular_name = "combat lubricant"
	desc = "A USCM-standard issued firearms lubricant consisting of more than a few ounces of synthetic firearm lubricant meant for field use. Do not consume, or apply to self."
	w_class = SIZE_TINY
	icon = 'icons/obj/items/clothing/helmet_garb.dmi'
	icon_state = "gunoil" //for now
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
		)
	amount = 10
	max_amount = 10
	stack_id = "combatoil"
	repair_amount_min = 6
	repair_amount_max = 12
	repair_verb = list("lubes", "oils", "cleans", "tends to", "gently strokes", "repairs")
	repair_time = 6 SECONDS

/obj/item/stack/repairable/gunlube/single
	amount = 1

/obj/item/stack/repairable/gunkit
	name = "firearms repair kit"
	singular_name = "essential firearms-tool"
	desc = "A small kit containing the necessary tools to repair any broken firearm. Shamefully, the tools inside are a tad bit too small for use outside of firearms repair."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "repair_kit"
	amount = 5
	max_amount = 5
	stack_id = "gunkit"
	repair_amount_min = 50
	repair_amount_max = 50
	repair_verb = list("fixes", "fastens screws to", "recalculates the settings of", "tends to", "installs some fixes to", "repairs")
	repair_time = 18 SECONDS
