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
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10) //Set to null instead of list, if there is only one.
	matter = list("plastic" = 500)
	transparent = TRUE
	volume = 250
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
	var/use_delay = 0.5 SECONDS

/obj/item/reagent_container/spray/afterattack(atom/A, mob/user, proximity)
	//this is what you get for using afterattack() TODO: make is so this is only called if attackby() returns 0 or something
	if(isstorage(A) || istype(A, /obj/structure/surface/table) || istype(A, /obj/structure/surface/rack) || istype(A, /obj/structure/closet) \
	|| istype(A, /obj/item/reagent_container) || istype(A, /obj/structure/sink) || istype(A, /obj/structure/janitorialcart) || istype(A, /obj/structure/ladder) || istype(A, /atom/movable/screen))
		return

	if(istype(A, /obj/structure/reagent_dispensers) && get_dist(src,A) <= 1) //this block copypasted from reagent_containers/glass, for lack of a better solution
		if(!A.reagents.total_volume && A.reagents)
			to_chat(user, SPAN_NOTICE("\The [A] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_NOTICE("\The [src] is full."))
			return

		var/trans = A.reagents.trans_to(src, A:amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("You fail to fill [src] with reagents from [A]."))
			return

		to_chat(user, SPAN_NOTICE("You fill \the [src] with [trans] units of the contents of \the [A]."))
		return

	if(world.time < last_use + use_delay)
		return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("\The [src] is empty!"))
		return

	if(safety)
		to_chat(user, SPAN_WARNING("The safety is on!"))
		return

	last_use = world.time

	if(Spray_at(A, user))
		playsound(src.loc, 'sound/effects/spray2.ogg', 25, 1, 3)

/obj/item/reagent_container/spray/proc/Spray_at(atom/A, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(!human_user.allow_gun_usage && reagents.contains_harmful_substances())
			to_chat(user, SPAN_WARNING("Your programming prevents you from using this!"))
			return FALSE
		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/ceasefire))
			to_chat(user, SPAN_WARNING("You will not break the ceasefire by doing that!"))
			return FALSE

	var/obj/effect/decal/chempuff/D = new /obj/effect/decal/chempuff(get_turf(src))
	D.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(D, amount_per_transfer_from_this, 1 / spray_size)
	D.color = mix_color_from_reagents(D.reagents.reagent_list)
	D.source_user = user
	D.move_towards(A, 3, spray_size)
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
	reagents.add_reagent("cleaner", src.volume)
//pepperspray
/obj/item/reagent_container/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon_state = "pepperspray"
	item_state = "pepperspray"
	possible_transfer_amounts = null
	volume = 40
	safety = TRUE
	use_delay = 0.25 SECONDS


/obj/item/reagent_container/spray/pepper/Initialize()
	. = ..()
	reagents.add_reagent("condensedcapsaicin", 40)

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
	use_delay = 0.25 SECONDS

/obj/item/reagent_container/spray/waterflower/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)

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



//this is a big copypasta clusterfuck, but it's still better than it used to be!
/obj/item/reagent_container/spray/chemsprayer/Spray_at(atom/A as mob|obj)
	var/Sprays[3]
	for(var/i=1, i<=3, i++) // intialize sprays
		if(src.reagents.total_volume < 1)
			break
		var/obj/effect/decal/chempuff/D = new/obj/effect/decal/chempuff(get_turf(src))
		D.create_reagents(amount_per_transfer_from_this)
		src.reagents.trans_to(D, amount_per_transfer_from_this)

		D.color = mix_color_from_reagents(D.reagents.reagent_list)

		Sprays[i] = D

	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T,T1,T2)

	for(var/i=1, i<=length(Sprays), i++)
		spawn()
			var/obj/effect/decal/chempuff/D = Sprays[i]
			if(!D)
				continue

			// Spreads the sprays a little bit
			var/turf/my_target = pick(the_targets)
			the_targets -= my_target

			for(var/j=1, j<=rand(6,8), j++)
				step_towards(D, my_target)
				D.reagents.reaction(get_turf(D))
				for(var/atom/t in get_turf(D))
					D.reagents.reaction(t)
				sleep(2)
			qdel(D)

	return

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
	reagents.add_reagent("plantbgone", 100)


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
	reagents.add_reagent("ammonia", src.volume)

/obj/item/reagent_container/spray/investigation
	name = "forensic spray"
	desc = /datum/reagent/forensic_spray::description

/obj/item/reagent_container/spray/investigation/Initialize()
	. = ..()

	reagents.add_reagent(/datum/reagent/forensic_spray::id, volume)
