/obj/item/reagent_container/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/items/spray.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/janitor_righthand.dmi',
	)
	icon_state = "spray"
	item_state = "cleaner"
	flags_atom = OPENCONTAINER|FPRINT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST
	throwforce = 3
	w_class = SIZE_SMALL
	throw_speed = SPEED_SLOW
	throw_range = 10
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null //Set to null instead of list, if there is only one.
	matter = list("plastic" = 500)
	transparent = TRUE
	volume = 150
	has_set_transfer_action = FALSE
	///How many tiles the spray will move
	var/spray_size = 3
	/// The spray_size based on the transfer amount
	var/list/spray_sizes = list(1,3)
	/// Whether you can spray the bottle
	var/safety = FALSE
	/// The world.time it was last used
	var/last_use = 1
	/// The delay between uses
	var/use_delay = 1.5 SECONDS

/obj/item/reagent_container/spray/afterattack(atom/target, mob/user, proximity)
	if(istype(target, /obj/structure/reagent_dispensers) && get_dist(src, target) <= 1) //this block copypasted from reagent_containers/glass, for lack of a better solution
		if(!target.reagents.total_volume && target.reagents)
			to_chat(user, SPAN_NOTICE("[target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_NOTICE("[src] is full."))
			return

		var/obj/structure/reagent_dispensers/dispenser = target
		var/trans = dispenser.reagents.trans_to(src, dispenser.amount_per_transfer_from_this)
		if(!trans)
			to_chat(user, SPAN_DANGER("You fail to fill [src] with reagents from [target]."))
			return

		to_chat(user, SPAN_NOTICE("You fill [src] with [trans] units of the contents of [target]."))
		return

	if(world.time < last_use + use_delay)
		return

	//this is what you get for using afterattack() TODO: make is so this is only called if attackby() returns 0 or something
	if(isstorage(target) || istype(target, /obj/structure/surface/table) || istype(target, /obj/structure/surface/rack) || istype(target, /obj/structure/closet) \
	|| istype(target, /obj/item/reagent_container) || istype(target, /obj/structure/sink) || istype(target, /obj/structure/janitorialcart) || istype(target, /obj/structure/ladder) || istype(target, /atom/movable/screen))
		return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("[src] is empty!"))
		return

	if(safety)
		to_chat(user, SPAN_WARNING("The safety is on!"))
		return

	last_use = world.time
	if(spray_at(target, user))
		playsound(loc, 'sound/effects/spray2.ogg', 25, 1, 3)

/obj/item/reagent_container/spray/proc/spray_at(atom/target, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(!human_user.allow_gun_usage && reagents.contains_harmful_substances())
			to_chat(user, SPAN_WARNING("Your programming prevents you from using this!"))
			return FALSE
		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/ceasefire))
			to_chat(user, SPAN_WARNING("You will not break the ceasefire by doing that!"))
			return FALSE

	var/obj/effect/decal/chempuff/puff = new /obj/effect/decal/chempuff(get_turf(src))
	puff.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(puff, amount_per_transfer_from_this, 1 / spray_size)
	puff.color = mix_color_from_reagents(puff.reagents.reagent_list)
	puff.source_user = user
	puff.move_towards(target, 3 DECISECONDS, spray_size)
	return TRUE

/obj/item/reagent_container/spray/attack_self(mob/user)
	..()

	if(!possible_transfer_amounts)
		return
	amount_per_transfer_from_this = next_in_list(amount_per_transfer_from_this, possible_transfer_amounts)
	spray_size = next_in_list(spray_size, spray_sizes)
	to_chat(user, SPAN_NOTICE("You adjusted the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray."))


/obj/item/reagent_container/spray/get_examine_text(mob/user)
	. = ..()
	. += "[floor(reagents.total_volume)] units left."

/obj/item/reagent_container/spray/verb/empty()

	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr

	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, SPAN_NOTICE("You empty \the [src] onto the floor."))
		reagents.reaction(usr.loc)
		spawn(5) src.reagents.clear_reagents()

//space cleaner
/obj/item/reagent_container/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	icon_state = "cleaner"

/obj/item/reagent_container/spray/cleaner/drone
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	volume = 50

/obj/item/reagent_container/spray/cleaner/Initialize()
	. = ..()
	reagents.add_reagent("cleaner", volume)

//pepperspray
/obj/item/reagent_container/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon_state = "pepperspray"
	item_state = "pepperspray"
	possible_transfer_amounts = null
	amount_per_transfer_from_this = 10
	volume = 40
	safety = TRUE

/obj/item/reagent_container/spray/pepper/Initialize()
	. = ..()
	reagents.add_reagent("condensedcapsaicin", volume)

/obj/item/reagent_container/spray/pepper/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user,src) <= 1)
		. += "The safety is [safety ? "on" : "off"]."

/obj/item/reagent_container/spray/pepper/attack_self(mob/user)
	..()
	safety = !safety
	to_chat(user, SPAN_NOTICE("You switch the safety [safety ? "on" : "off"]."))

//water flower
/obj/item/reagent_container/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10

/obj/item/reagent_container/spray/waterflower/Initialize()
	. = ..()
	reagents.add_reagent("water", volume)

//chemsprayer
/obj/item/reagent_container/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	throwforce = 3
	w_class = SIZE_MEDIUM
	possible_transfer_amounts = null
	volume = 600
	spray_size = 6
	amount_per_transfer_from_this = 60

//this is a big copypasta clusterfuck, but it's still better than it used to be!
/obj/item/reagent_container/spray/chemsprayer/spray_at(atom/target, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(!human_user.allow_gun_usage && reagents.contains_harmful_substances())
			to_chat(user, SPAN_WARNING("Your programming prevents you from using this!"))
			return FALSE
		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/ceasefire))
			to_chat(user, SPAN_WARNING("You will not break the ceasefire by doing that!"))
			return FALSE

	var/direction = get_dir(src, target)
	var/turf/my_turf = get_turf(src)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE
	var/turf/right_turf = get_step(target_turf, turn(direction, 90)) || target_turf
	var/turf/left_turf = get_step(target_turf, turn(direction, -90)) || target_turf
	var/list/target_turfs = list(target_turf, right_turf, left_turf)

	for(var/i in 1 to 3)
		if(reagents.total_volume < 1)
			break
		var/amount_to_transfer = min(amount_per_transfer_from_this, reagents.total_volume)
		var/obj/effect/decal/chempuff/puff = new/obj/effect/decal/chempuff(my_turf)
		puff.create_reagents(amount_to_transfer)
		reagents.trans_to(puff, amount_to_transfer, 1 / spray_size)
		puff.color = mix_color_from_reagents(puff.reagents.reagent_list)
		puff.source_user = user
		puff.move_towards(target_turfs[i], 2 DECISECONDS, spray_size)

	return TRUE

// Plant-B-Gone
/obj/item/reagent_container/spray/plantbgone // -- Skie
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/hydroponics_tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/hydroponics_tools_righthand.dmi',
	)
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100

/obj/item/reagent_container/spray/plantbgone/Initialize()
	. = ..()
	reagents.add_reagent("plantbgone", volume)


/obj/item/reagent_container/spray/plantbgone/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	..()

//ammonia spray
/obj/item/reagent_container/spray/hydro
	name = "hydroponics spray"
	desc = "A spray used in hydroponics initially containing ammonia."
	icon_state = "hydrospray"

/obj/item/reagent_container/spray/hydro/Initialize()
	. = ..()
	reagents.add_reagent("ammonia", volume)

/obj/item/reagent_container/spray/investigation
	name = "forensic spray"
	desc = /datum/reagent/forensic_spray::description

/obj/item/reagent_container/spray/investigation/Initialize()
	. = ..()

	reagents.add_reagent(/datum/reagent/forensic_spray::id, volume)
