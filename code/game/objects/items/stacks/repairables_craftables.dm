//the fact that the item stacking mechanic are specifically pathed to the stacks parent file is horrible

/obj/item/stack/repairable
	name = "repo item"
	singular_name = "repo item"
	desc = "You shouldn't see this, submit a bug report if you do."
	w_class = SIZE_SMALL
	amount = 10
	max_amount = 10


/obj/item/stack/repairable/gunlube
	name = "Multi-purpose combat lubricant"
	singular_name = "combat lubricant"
	desc = "A USCM-standard issued firearms lubricant consisting of more than a few ounces of synthetic firearm lubricant meant for field use. Do not consume."
	w_class = SIZE_TINY
	icon = 'icons/obj/items/clothing/helmet_garb.dmi'
	icon_state = "gunoil" //for now
	amount = 10
	max_amount = 10
	stack_id = "combatoil"

/obj/item/stack/repairable/gunkit
	name = "firearms repair kit"
	singular_name = "essential firearms-tool"
	desc = "A small kit containing the necessary tools to repair any broken firearm. Shamefully, the tools inside are a tad bit too small for use outside of firearms repair."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "upgradekit" //for now
	amount = 5
	max_amount = 5
	stack_id = "gunkit"
