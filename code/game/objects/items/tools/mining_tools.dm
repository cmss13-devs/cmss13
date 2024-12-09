

//*****************************Pickaxe********************************/

/obj/item/tool/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/items/tools.dmi'
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/tools.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi'
	)
	icon_state = "pickaxe"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_STRONG
	throwforce = 4
	item_state = "pickaxe"
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	matter = list("metal" = 3750)
	/// moving the delay to an item var so R&D can make improved picks. --NEO
	var/digspeed = 40

	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "picking"
	sharp = IS_SHARP_ITEM_SIMPLE
	var/excavation_amount = 100

/obj/item/tool/pickaxe/hammer
	name = "mining sledgehammer"
	icon_state = "minesledge"
	item_state = "minesledge"
	desc = "A mining hammer made of reinforced metal. Works just as well as a pickaxe."

/obj/item/tool/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 30

	desc = "This makes no metallurgic sense."
	black_market_value = 25

/obj/item/tool/pickaxe/drill
	/// Can dig sand as well!
	name = "mining drill"
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 30

	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"

/obj/item/tool/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	/// faster than drill, but cannot dig
	digspeed = 20

	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"

/obj/item/tool/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 20

	desc = "This makes no metallurgic sense."
	black_market_value = 30

/obj/item/tool/pickaxe/plasmacutter
	name = "plasma cutter"
	icon_state = "plasmacutter"
	item_state = "gun"
	/// it is smaller than the pickaxe
	w_class = SIZE_MEDIUM
	damtype = "fire"
	/// Can slice though normal walls, all girders, or be used in reinforced wall deconstruction/ light thermite on fire
	digspeed = 20
	desc = "A rock cutter that uses bursts of hot plasma. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	drill_verb = "cutting"
	heat_source = 3800
	flags_item = IGNITING_ITEM

/obj/item/tool/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 10

	desc = "A pickaxe with a diamond pick head, this is just like minecraft."
	black_market_value = 5 //fuck you!

/obj/item/tool/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	/// Digs through walls, girders, and can dig up sand
	digspeed = 5

	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"
	black_market_value = 35

/obj/item/tool/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	desc = ""
	drill_verb = "drilling"





