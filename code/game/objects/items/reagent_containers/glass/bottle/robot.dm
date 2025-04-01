
/obj/item/reagent_container/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100)
	volume = 60
	var/reagent = ""


/obj/item/reagent_container/glass/bottle/robot/inaprovaline
	name = "internal inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/items/chemistry.dmi'
	reagent = "inaprovaline"

/obj/item/reagent_container/glass/bottle/robot/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 60)
	return


/obj/item/reagent_container/glass/bottle/robot/antitoxin
	name = "internal anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/items/chemistry.dmi'
	reagent = "anti_toxin"

/obj/item/reagent_container/glass/bottle/robot/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 60)
	return
