/obj/item/clothing/shoes/black
	name = "black shoes"
	icon_state = "black"
	desc = "A pair of black shoes."

	flags_cold_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"

/obj/item/clothing/shoes/blue
	name = "blue shoes"
	icon_state = "blue"

/obj/item/clothing/shoes/green
	name = "green shoes"
	icon_state = "green"

/obj/item/clothing/shoes/yellow
	name = "yellow shoes"
	icon_state = "yellow"

/obj/item/clothing/shoes/purple
	name = "purple shoes"
	icon_state = "purple"

/obj/item/clothing/shoes/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"

/obj/item/clothing/shoes/red/knife
	name = "dirty red shoes"
	desc = "Stylish red shoes with a small space to hold a knife."
	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/holdout,
		/obj/item/weapon/gun/pistol/clfpistol,
		/obj/item/tool/screwdriver,
		/obj/item/weapon/straight_razor,
	)

/obj/item/clothing/shoes/white
	name = "white shoes"
	icon_state = "white"
	permeability_coefficient = 0.01

/obj/item/clothing/shoes/leather
	name = "leather shoes"
	desc = "A sturdy pair of leather shoes."
	icon_state = "leather"

/obj/item/clothing/shoes/rainbow
	name = "rainbow shoes"
	desc = "Very gay shoes."
	icon_state = "rain_bow"

/obj/item/clothing/shoes/orange
	name = "orange shoes"
	icon_state = "orange"
	var/obj/item/restraint/handcuffs/chained = null

/obj/item/clothing/shoes/orange/proc/attach_cuffs(obj/item/restraint/cuffs, mob/user as mob)
	if(chained)
		return FALSE

	user.drop_held_item()
	cuffs.forceMove(src)
	chained = cuffs
	slowdown = 15
	icon_state = "orange1"
	time_to_equip = (cuffs.breakouttime / 4)
	time_to_unequip = cuffs.breakouttime
	return TRUE

/obj/item/clothing/shoes/orange/proc/remove_cuffs(mob/user as mob)
	if(!chained)
		return FALSE

	user.put_in_hands(chained)
	chained.add_fingerprint(user)

	slowdown = initial(slowdown)
	icon_state = "orange"
	chained = null
	time_to_equip = initial(time_to_equip)
	time_to_unequip = initial(time_to_unequip)
	return TRUE

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	..()
	remove_cuffs(user)

/obj/item/clothing/shoes/orange/attackby(attacking_object as obj, mob/user as mob)
	..()
	if(istype(attacking_object, /obj/item/restraint))
		var/obj/item/restraint/cuffs = attacking_object
		if(cuffs.target_zone == SLOT_LEGS)
			attach_cuffs(cuffs, user)

/obj/item/clothing/shoes/orange/get_examine_text(mob/user)
	. = ..()
	if(chained)
		. += SPAN_RED("They are chained with [chained].")
