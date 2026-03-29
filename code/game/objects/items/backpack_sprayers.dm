//Hydroponics tank and base code
/obj/item/reagent_container/glass/watertank
	name = "backpack watertank"
	desc = "A commercially-produced backpack tank, capable of holding and spraying various liquids. Widely used in the agricultural industry on colonies and in space stations."
	icon = 'icons/obj/items/backpack_sprayers.dmi'
	icon_state = "backpack_sprayer"
	item_state = "backpack_sprayer"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/sprayers.dmi'
	)
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	flags_atom = OPENCONTAINER
	possible_transfer_amounts = null//no point giving it possibility when mister can't it just confuse people
	volume = 250
	var/fill_reagent = "water"
	var/spawn_empty = FALSE

	var/obj/item/noz

/obj/item/reagent_container/glass/watertank/fuel
	fill_reagent = "fuel"

/obj/item/reagent_container/glass/watertank/Initialize()
	. = ..()
	if(!spawn_empty)
		reagents.add_reagent(fill_reagent, volume)
	update_icon()

/obj/item/reagent_container/glass/watertank/update_icon()
	if(!noz || QDELETED(noz) || (noz in src))
		overlays += "[icon_state]_nozzle"
	else
		overlays = null
	return ..()

/obj/item/reagent_container/glass/watertank/Destroy()
	QDEL_NULL(noz)
	return ..()

/obj/item/reagent_container/glass/watertank/proc/toggle_mister(mob/living/user)
	if(!istype(user))
		return
	if(user.get_item_by_slot(WEAR_BACK) != src)
		to_chat(user, SPAN_WARNING("\The [src] must be worn properly to use!"))
		return
	if(user.is_mob_incapacitated())
		return

	if(QDELETED(noz))
		noz = make_noz()
		noz.AddElement(/datum/element/drop_retrieval/mister)
	if(noz in src)
		//Detach the nozzle into the user's hands
		if(!user.put_in_hands(noz))
			to_chat(user, SPAN_WARNING("You need a free hand to hold \the [noz]!"))
			update_icon()
			return
		update_icon()
	else
		//Remove from their hands and put back "into" the tank
		remove_noz()

/obj/item/reagent_container/glass/watertank/proc/make_noz()
	return new /obj/item/reagent_container/spray/mister(src)

/obj/item/reagent_container/glass/watertank/equipped(mob/user, slot)
	..()
	if(slot != WEAR_BACK)
		remove_noz()

/obj/item/reagent_container/glass/watertank/proc/remove_noz()
	qdel(noz)
	if(!QDELETED(noz))
		qdel(noz)
	update_icon()

/obj/item/reagent_container/glass/watertank/attack_hand(mob/user, list/modifiers)
	if(user.get_item_by_slot(WEAR_BACK) == src)
		toggle_mister(user)
	else
		return ..()

/obj/item/reagent_container/glass/watertank/attackby(obj/item/W, mob/user, params)
	if(W == noz)
		remove_noz()
		return TRUE
	return ..()

/obj/item/reagent_container/glass/watertank/verb/toggle_mister_verb()
	set name = "Toggle Mister"
	set category = "Object"
	set src in usr
	toggle_mister(usr)


/obj/item/reagent_container/glass/watertank/MouseDrop(obj/over_object as obj)
	if(!CAN_PICKUP(usr, src))
		return ..()
	if(!istype(over_object, /atom/movable/screen))
		return ..()
	if(loc != usr) //Makes sure that the sprayer backpack is equipped, so that we can't drag it into our hand from miles away.
		return ..()

	switch(over_object.name)
		if("r_hand")
			usr.drop_inv_item_on_ground(src)
			usr.put_in_r_hand(src)
		if("l_hand")
			usr.drop_inv_item_on_ground(src)
			usr.put_in_l_hand(src)
	add_fingerprint(usr)

/obj/item/reagent_container/glass/watertank/dropped(mob/user)
	..()
	remove_noz()

/obj/item/reagent_container/glass/watertank/get_examine_text(mob/user)
	. = ..()
	if(!noz || QDELETED(noz) || (noz in src))
		. += SPAN_NOTICE("Its nozzle is attached.")
	else
		. += SPAN_NOTICE("Its nozzle is detached.")

// This mister item is intended as an extension of the watertank and always attached to it.
// Therefore, it's designed to be "locked" to the player's hands or extended back onto
// the watertank backpack. Allowing it to be placed elsewhere or created without a parent
// watertank object will likely lead to weird behaviour or runtimes.
/obj/item/reagent_container/spray/mister
	name = "water mister"
	desc = "A mister nozzle attached to a water tank. This is what your reagents come out of."
	icon = 'icons/obj/items/backpack_sprayers.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi',
	)
	icon_state = "nozzle"
	item_state = "nozzle"
	w_class = SIZE_LARGE
	flags_equip_slot = null
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	spray_size = 5
	volume = 5
	flags_atom = FPRINT //not an opencontainer
	flags_item = NOBLUDGEON | ITEM_ABSTRACT  // don't put in storage
	use_delay = FIRE_DELAY_TIER_5 * 5


/obj/item/reagent_container/spray/mister/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/watertank/W = loc
	if(!istype(W))
		return INITIALIZE_HINT_QDEL

/obj/item/reagent_container/spray/mister/get_examine_text(mob/user)
	. = ..()
	var/obj/item/reagent_container/glass/watertank/tank = user.back
	if(!istype(tank))
		return
	. += "It is linked to [tank]."

/obj/item/reagent_container/spray/mister/afterattack(atom/target, mob/user, proximity)
	//this is what you get for using afterattack() TODO: make is so this is only called if attackby() returns 0 or something
	var/obj/item/reagent_container/glass/watertank/tank = user.back
	if(!istype(tank))
		return

	if(isstorage(target) || istype(target, /obj/structure/surface/table) || istype(target, /obj/structure/surface/rack) || istype(target, /obj/structure/closet) \
	|| istype(target, /obj/item/reagent_container) || istype(target, /obj/structure/sink) || istype(target, /obj/structure/janitorialcart) || istype(target, /obj/structure/ladder) || istype(target, /atom/movable/screen))
		return

	if(target == user) //Safety check so you don't fill your mister with mutagen or something and then blast yourself in the face with it
		return

	if(world.time < last_use + use_delay)
		return

	if(tank.reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("[tank] is empty!"))
		return

	if(safety)
		to_chat(user, SPAN_WARNING("The safety is on!"))
		return

	last_use = world.time
	if(spray_at(target, user))
		playsound(loc, 'sound/effects/spray2.ogg', 25, 1, 3)

/obj/item/reagent_container/spray/mister/spray_at(atom/target, mob/user)
	var/obj/item/reagent_container/glass/watertank/tank = user.back
	if(!istype(tank))
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(!human_user.allow_gun_usage && tank.reagents.contains_harmful_substances())
			to_chat(user, SPAN_WARNING("Your programming prevents you from using this!"))
			return FALSE
		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/ceasefire))
			to_chat(user, SPAN_WARNING("You will not break the ceasefire by doing that!"))
			return FALSE

	var/obj/effect/decal/chempuff/puff = new /obj/effect/decal/chempuff(get_turf(src))
	puff.create_reagents(amount_per_transfer_from_this)
	tank.reagents.trans_to(puff, amount_per_transfer_from_this, 1 / spray_size)
	puff.color = mix_color_from_reagents(puff.reagents.reagent_list)
	puff.source_user = user
	puff.move_towards(target, 3 DECISECONDS, spray_size)
	return TRUE

//ATMOS FIRE FIGHTING BACKPACK

#define EXTINGUISHER 0
#define METAL_LAUNCHER 1
#define METAL_FOAM 2

/obj/item/reagent_container/glass/watertank/atmos
	name = "backpack firefighting watertank"
	desc = "A refrigerated and pressurised backpack tank with an extinguisher nozzle, intended to fight fires and plug hull breaches. Swaps between extinguisher, metal foam launcher and a smaller scale metal foamer."
	icon_state = "backpack_foamer"
	item_state = "backpack_foamer"
	volume = 500
	fill_reagent = "water"
	var/nozzle_mode = EXTINGUISHER

/obj/item/reagent_container/glass/watertank/atmos/make_noz()
	return new /obj/item/reagent_container/spray/mister/atmos(src)

/obj/item/reagent_container/glass/watertank/atmos/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity || !(istype(O, /obj/structure/reagent_dispensers))) // this replaces and improves the get_dist(src,O) <= 1 checks used previously
		return
	if(src.reagents.total_volume < volume)
		O.reagents.trans_to(src, volume)
		to_chat(user, SPAN_NOTICE("You crack the cap off the top of \the [src] and fill it back up again with reagents from \the [O]."))
		playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
		return
	else if(src.reagents.total_volume == volume)
		to_chat(user, SPAN_NOTICE("\The [src] is already full!"))
		return
	..()

/obj/item/reagent_container/glass/watertank/atmos/get_examine_text(mob/user)
	. = ..()
	switch(nozzle_mode)
		if(EXTINGUISHER)
			. += SPAN_NOTICE("It is set to [SPAN_HELPFUL("extinguisher")] mode.")
			return
		if(METAL_FOAM)
			. += SPAN_NOTICE("It is set to [SPAN_HELPFUL("metal foamer")] mode.")
			return
		if(METAL_LAUNCHER)
			. += SPAN_NOTICE("It is set to [SPAN_HELPFUL("metal foam launcher")] mode.")
			return

/obj/item/reagent_container/spray/mister/atmos
	name = "multipurpose nozzle"
	desc = "A heavy-duty foam-spraying nozzle attached to a firefighter's backpack tank."
	icon_state = "fnozzle"
	item_state = "fnozzle"
	w_class = SIZE_LARGE
	var/obj/item/reagent_container/glass/watertank/atmos/tank
	var/nozzle_mode = 0
	var/foamer_cost = 10
	var/launcher_cost = 100
	var/extinguisher_cost = 10
	var/obj/item/tool/extinguisher/internal_extinguisher

/obj/item/reagent_container/spray/mister/atmos/Initialize(mapload)
	. = ..()
	if(!istype(loc, /obj/item/reagent_container/glass/watertank/atmos))
		return INITIALIZE_HINT_QDEL

	tank = loc
	nozzle_mode = tank.nozzle_mode

	initialize_internal_extinguisher()
	update_icon()

/obj/item/reagent_container/spray/mister/atmos/proc/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/pyro/atmos_tank()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/reagent_container/spray/mister/atmos/get_examine_text(mob/user)
	. = ..()
	switch(nozzle_mode)
		if(EXTINGUISHER)
			. += SPAN_NOTICE("It is set to [SPAN_HELPFUL("extinguisher")] mode.")
		if(METAL_FOAM)
			. += SPAN_NOTICE("It is set to [SPAN_HELPFUL("metal foamer")] mode.")
		if(METAL_LAUNCHER)
			. += SPAN_NOTICE("It is set to [SPAN_HELPFUL("metal foam launcher")] mode.")

/obj/item/reagent_container/spray/mister/atmos/update_icon()
	. = ..()
	overlays = null
	switch(nozzle_mode)
		if(EXTINGUISHER)
			overlays += "[icon_state]_extinguisher"
		if(METAL_FOAM)
			overlays += "[icon_state]_foamer"
		if(METAL_LAUNCHER)
			overlays += "[icon_state]_launcher"

/obj/item/reagent_container/spray/mister/atmos/attack_self(mob/user) //swapping mode
	..()
	var/obj/item/reagent_container/glass/watertank/atmos/tank = user.back
	if(!istype(tank))
		return ..()
	switch(nozzle_mode)
		if(EXTINGUISHER)
			nozzle_mode = METAL_LAUNCHER
			tank.nozzle_mode = METAL_LAUNCHER
			to_chat(user, SPAN_NOTICE("Swapped to metal foam launcher. Now using [launcher_cost] water per foam shot."))
		if(METAL_LAUNCHER)
			nozzle_mode = METAL_FOAM
			tank.nozzle_mode = METAL_FOAM
			to_chat(user, SPAN_NOTICE("Swapped to metal foamer. Now using [foamer_cost] water per foam shot."))
		if(METAL_FOAM)
			nozzle_mode = EXTINGUISHER
			tank.nozzle_mode = EXTINGUISHER
			to_chat(user, SPAN_NOTICE("Swapped to water extinguisher. Now using [extinguisher_cost] water per blast."))
	update_icon()

/obj/item/reagent_container/spray/mister/atmos/afterattack(atom/target, mob/user)
	if(!issynth(user))
		to_chat(user, SPAN_WARNING("You have no idea how use [src]!"))
		return

	var/is_adjacent = user.Adjacent(target)
	switch(nozzle_mode)
		if(EXTINGUISHER)
			if(world.time < last_use + use_delay)
				return
			if(istype(target, /atom/movable/screen)) //so we don't end up wasting water when clicking
				return
			if(!tank.reagents.has_reagent("water", extinguisher_cost))
				to_chat(user, SPAN_WARNING("You need at least [extinguisher_cost] units of water to use the extinguisher!"))
				return

			last_use = world.time
			tank.reagents.remove_reagent("water", extinguisher_cost)
			return internal_extinguisher.afterattack(target, user)

		if(METAL_LAUNCHER)
			if(is_adjacent)
				return //Safety check so you don't blast yourself trying to refill your tank
			if(world.time < last_use + use_delay * 1.5) // Extra delay for this mode
				to_chat(user, SPAN_WARNING("[tank] cannot fire another foam ball just yet."))
				return
			if(istype(target, /atom/movable/screen))
				return
			if(!tank.reagents.has_reagent("water", launcher_cost))
				to_chat(user, SPAN_WARNING("You need at least [launcher_cost] units of water to use the metal foam launcher!"))
				return
			for(var/foam in target)
				if(istype(foam, /obj/effect/particle_effect/foam) || istype(foam, /obj/structure/foamed_metal))
					to_chat(user, SPAN_WARNING("There's already metal foam here!"))
					return

			last_use = world.time
			tank.reagents.remove_reagent("water", launcher_cost)
			var/obj/effect/resin_container/ball = new (get_turf(src))
			playsound(src,'sound/items/syringeproj.ogg',40,TRUE)
			//projectile movement
			for(var/i in 1 to 5)
				step_towards(ball, target)
				sleep(2)
			ball.Smoke()
			return

		if(METAL_FOAM)
			if(world.time < last_use + use_delay * 0.5) // Less delay for this mode
				return
			if(!is_adjacent || !isturf(target) || istype(target, /atom/movable/screen))
				return
			//check for tank reagents
			if(!tank.reagents.has_reagent("water", foamer_cost))
				to_chat(user, SPAN_WARNING("You need at least [foamer_cost] units of water to use the metal foamer!"))
				return
			//check for the foamer - is there already foam on the tile?
			for(var/foam in target)
				if(istype(foam, /obj/effect/particle_effect/foam) || istype(foam, /obj/structure/foamed_metal))
					to_chat(user, SPAN_WARNING("There's already metal foam here!"))
					return

			//firing code
			last_use = world.time
			tank.reagents.remove_reagent("water", foamer_cost)
			var/datum/effect_system/foam_spread/foam = new /datum/effect_system/foam_spread(get_turf(target))
			foam.set_up(0, target, null, metal_foam = FOAM_METAL_TYPE_ALUMINIUM)
			foam.start()
			return

/obj/effect/resin_container //the projectile that the launcher fires
	name = "metal foam ball"
	desc = "A compacted ball of expansive metal foam, used to repair the atmosphere in a room, or seal off breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "foam_ball"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	var/foam_metal_type = FOAM_METAL_TYPE_ALUMINIUM

/obj/effect/resin_container/proc/Smoke()
	var/datum/effect_system/foam_spread/s = new /datum/effect_system/foam_spread(get_turf(loc))
	s.set_up(12, get_turf(src), metal_foam = foam_metal_type) //Metalfoam 1 for aluminum foam, 2 for iron foam (Stronger), 12 amt = 2 tiles radius (5 tile length diamond)
	s.start()
	playsound(src,'sound/effects/bamf.ogg',100,TRUE)
	qdel(src)

#undef EXTINGUISHER
#undef METAL_LAUNCHER
#undef METAL_FOAM
