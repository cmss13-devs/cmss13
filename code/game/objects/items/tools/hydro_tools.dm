
// *************************************
// Hydroponics Tools
// *************************************

/obj/item/tool/plantspray
	icon = 'icons/obj/items/spray.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/hydroponics_tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/hydroponics_tools_righthand.dmi',
	)
	item_state = "spraycan"
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST
	throwforce = 4
	w_class = SIZE_SMALL
	throw_speed = SPEED_SLOW
	throw_range = 10
	var/toxicity = 4
	var/pest_kill_str = 0
	var/weed_kill_str = 0

/obj/item/tool/plantspray/weeds // -- Skie

	name = "weed-spray"
	desc = "It's a toxic mixture, in spray form, to kill small weeds."
	icon_state = "weedspray"
	weed_kill_str = 6

/obj/item/tool/plantspray/pests
	name = "pest-spray"
	desc = "It's some pest eliminator spray! <I>Do not inhale!</I>"
	icon_state = "pestspray"
	pest_kill_str = 6

/obj/item/tool/plantspray/pests/old
	name = "bottle of pestkiller"

/obj/item/tool/plantspray/pests/old/carbaryl
	name = "bottle of carbaryl"
	toxicity = 4
	pest_kill_str = 2

/obj/item/tool/plantspray/pests/old/lindane
	name = "bottle of lindane"
	toxicity = 6
	pest_kill_str = 4

/obj/item/tool/plantspray/pests/old/phosmet
	name = "bottle of phosmet"
	toxicity = 8
	pest_kill_str = 7



/obj/item/tool/weedkiller
	name = "bottle of weedkiller"
	icon = 'icons/obj/items/chemistry.dmi'
	var/toxicity = 0
	var/weed_kill_str = 0

/obj/item/tool/weedkiller/triclopyr
	name = "bottle of glyphosate"
	toxicity = 4
	weed_kill_str = 2

/obj/item/tool/weedkiller/lindane
	name = "bottle of triclopyr"
	toxicity = 6
	weed_kill_str = 4

/obj/item/tool/weedkiller/D24
	name = "bottle of 2,4-D"
	toxicity = 8
	weed_kill_str = 7




/obj/item/tool/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/items/tools.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/hydroponics_tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/hydroponics_tools_righthand.dmi',
	)
	icon_state = "hoe"
	item_state = "hoe"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	force = 5
	throwforce = 7
	w_class = SIZE_SMALL
	matter = list("metal" = 50)
	attack_verb = list("slashed", "sliced", "cut", "clawed")




//Hatchets and things to kill kudzu
/obj/item/tool/hatchet
	name = "hatchet"
	desc = "A sharp hand hatchet, commonly used to cut things apart, be it timber or other objects. Often found in the hands of woodsmen, scouts, and looters."
	icon = 'icons/obj/items/weapons/melee/axes.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/axes_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/axes_righthand.dmi'
	)
	icon_state = "hatchet"
	flags_atom = FPRINT|CONDUCT
	force = MELEE_FORCE_NORMAL
	w_class = SIZE_SMALL
	throwforce = 20
	throw_speed = SPEED_VERY_FAST
	throw_range = 4
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	matter = list("metal" = 15000)

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("chopped", "torn", "cut")


/obj/item/tool/scythe
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	icon = 'icons/obj/items/tools.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/melee_weapons.dmi'
	)
	icon_state = "scythe"
	force = 13
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 3
	w_class = SIZE_LARGE
	flags_atom = FPRINT|CONDUCT
	flags_item = NOSHIELD
	flags_equip_slot = SLOT_BACK

	attack_verb = list("chopped", "sliced", "cut", "reaped")

/obj/item/tool/scythe/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A, /obj/effect/plantsegment))
		for(var/obj/effect/plantsegment/B in orange(A,1))
			if(prob(80))
				qdel(B)
		qdel(A)
