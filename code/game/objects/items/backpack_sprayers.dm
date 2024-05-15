//Hydroponics tank and base code
/obj/item/reagent_container/glass/watertank
	name = "backpack watertank"
	desc = "A commercially-produced backpack tank, capable of holding and spraying various liquids. Widely used in the agricultural industry on colonies and in space stations."
	icon = 'icons/obj/items/backpack_sprayers.dmi'
	icon_state = "backpack_sprayer"
	item_state = "backpack_sprayer"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	flags_atom = OPENCONTAINER
	possible_transfer_amounts = null//no point giving it possibility when mister can't it just confuse people
	volume = 500
	var/fill_reagent = "water"
	var/spawn_empty = FALSE

	var/obj/item/noz

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
	else
		. = ..()

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

/obj/item/reagent_container/glass/watertank/attackby(obj/item/W, mob/user, params)
	if(W == noz)
		remove_noz()
		return 1
	else
		return ..()

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
	icon_state = "nozzle"
	item_state = "nozzle"
	w_class = SIZE_LARGE
	flags_equip_slot = null
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	spray_size = 5
	volume = 500
	flags_atom = FPRINT //not an opencontainer
	flags_item = NOBLUDGEON | ITEM_ABSTRACT  // don't put in storage


/obj/item/reagent_container/spray/mister/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/watertank/W = loc
	if(!istype(W))
		return INITIALIZE_HINT_QDEL

/obj/item/reagent_container/spray/mister/get_examine_text(mob/user)
	. = ..()
	var/obj/item/reagent_container/glass/watertank/W = user.back
	if(!istype(W))
		return
	. += "It is linked to \the [W]."

/obj/item/reagent_container/spray/mister/afterattack(atom/A, mob/user, proximity)
	//this is what you get for using afterattack() TODO: make is so this is only called if attackby() returns 0 or something
	var/obj/item/reagent_container/glass/watertank/W = user.back
	if(!istype(W))
		return

	if(isstorage(A) || istype(A, /obj/structure/surface/table) || istype(A, /obj/structure/surface/rack) || istype(A, /obj/structure/closet) \
	|| istype(A, /obj/item/reagent_container) || istype(A, /obj/structure/sink) || istype(A, /obj/structure/janitorialcart) || istype(A, /obj/structure/ladder) || istype(A, /atom/movable/screen))
		return

	if(A == user) //Safety check so you don't fill your mister with mutagen or something and then blast yourself in the face with it
		return

	if(W.reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("\The [W] is empty!"))
		return

	if(safety)
		to_chat(user, SPAN_WARNING("The safety is on!"))
		return


	Spray_at(A, user)

	playsound(src.loc, 'sound/effects/spray2.ogg', 25, 1, 3)


/obj/item/reagent_container/spray/mister/Spray_at(atom/A, mob/user)
	var/obj/item/reagent_container/glass/watertank/W = user.back
	if(!istype(W))
		return
	var/obj/effect/decal/chempuff/D = new /obj/effect/decal/chempuff(get_turf(src))
	D.create_reagents(amount_per_transfer_from_this)
	W.reagents.trans_to(D, amount_per_transfer_from_this, 1 / spray_size)
	D.color = mix_color_from_reagents(D.reagents.reagent_list)
	D.source_user = user
	D.move_towards(A, 3, spray_size)

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
	var/launcher_cooldown //to prevent the spam

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
		to_chat(user, SPAN_WARNING("You have no idea how use \the [src]!"))
		return
	if(nozzle_mode == EXTINGUISHER)
		if(istype(target, /atom/movable/screen)) //so we don't end up wasting water when clicking
			return
		if(tank.reagents.has_reagent("water", extinguisher_cost))
			tank.reagents.remove_reagent("water", extinguisher_cost)
			return internal_extinguisher.afterattack(target, user)
		else
			to_chat(user, SPAN_WARNING("You need at least [extinguisher_cost] units of water to use the extinguisher!"))
			return
	var/Adj = user.Adjacent(target)
	if(nozzle_mode == METAL_LAUNCHER)
		if(Adj || istype(target, /atom/movable/screen))
			return //Safety check so you don't blast yourself trying to refill your tank
		for(var/S in target)
			if(istype(S, /obj/effect/particle_effect/foam) || istype(S, /obj/structure/foamed_metal))
				to_chat(user, SPAN_WARNING("There's already metal foam here!"))
				return
		//actually firing the launcher
		if(tank.launcher_cooldown > world.time)
			to_chat(user, SPAN_WARNING("\The [tank] cannot fire another foam ball just yet. Wait [floor(tank.launcher_cooldown/10)] seconds."))
			return
		if(tank.reagents.has_reagent("water", launcher_cost))
			tank.reagents.remove_reagent("water", launcher_cost)
			tank.launcher_cooldown = world.time + 50
			var/obj/effect/resin_container/A = new (get_turf(src))
			playsound(src,'sound/items/syringeproj.ogg',40,TRUE)
			//projectile movement
			for(var/i in 1 to 5)
				step_towards(A, target)
				sleep(2)
			A.Smoke()
			return
		else
			to_chat(user, SPAN_WARNING("You need at least [launcher_cost] units of water to use the metal foam launcher!"))
			return

	if(nozzle_mode == METAL_FOAM)
		if(!Adj || !isturf(target) || istype(target, /atom/movable/screen))
			return
		//check for the foamer - is there already foam on the tile?
		for(var/S in target)
			if(istype(S, /obj/effect/particle_effect/foam) || istype(S, /obj/structure/foamed_metal))
				to_chat(user, SPAN_WARNING("There's already metal foam here!"))
				return
		//check for tank reagents
		if(tank.reagents.has_reagent("water", foamer_cost))
			//firing code
			tank.reagents.remove_reagent("water", foamer_cost)
			var/datum/effect_system/foam_spread/S = new /datum/effect_system/foam_spread(get_turf(target))
			S.set_up(0, target, null, metal_foam = FOAM_METAL_TYPE_ALUMINIUM)
			S.start()
			return
		else
			to_chat(user, SPAN_WARNING("You need at least [foamer_cost] units of water to use the metal foamer!"))
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
