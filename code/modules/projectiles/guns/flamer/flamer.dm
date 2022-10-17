


//FLAMETHROWER

/obj/item/weapon/gun/flamer
	name = "\improper M240A1 incinerator unit"
	desc = "M240A1 incinerator unit has proven to be one of the most effective weapons at clearing out soft-targets. This is a weapon to be feared and respected as it is quite deadly."

	icon_state = "m240"
	item_state = "m240"
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	force = 15
	fire_sound = ""
	unload_sound = 'sound/weapons/handling/flamer_unload.ogg'
	reload_sound = 'sound/weapons/handling/flamer_reload.ogg'
	aim_slowdown = SLOWDOWN_ADS_INCINERATOR
	current_mag = /obj/item/ammo_magazine/flamer_tank
	var/fuel_pressure = 1 //Pressure setting of the attached fueltank, controls how much fuel is used per tile
	var/max_range = 9 //9 tiles, 7 is screen range, controlled by the type of napalm in the canister. We max at 9 since diagonal bullshit.

	attachable_allowed = list( //give it some flexibility.
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/flamer_nozzle
	)
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_WIELDED_FIRING_ONLY|GUN_TRIGGER_SAFETY
	gun_category = GUN_CATEGORY_HEAVY


/obj/item/weapon/gun/flamer/Initialize(mapload, spawn_empty)
	. = ..()
	update_icon()

/obj/item/weapon/gun/flamer/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 0, "muzzle_y" = 0, "rail_x" = 11, "rail_y" = 20, "under_x" = 21, "under_y" = 14, "stock_x" = 0, "stock_y" = 0)

/obj/item/weapon/gun/flamer/x_offset_by_attachment_type(var/attachment_type)
	switch(attachment_type)
		if(/obj/item/attachable/flashlight)
			return 8
	return 0

/obj/item/weapon/gun/flamer/y_offset_by_attachment_type(var/attachment_type)
	switch(attachment_type)
		if(/obj/item/attachable/flashlight)
			return -1
	return 0

/obj/item/weapon/gun/flamer/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4 * 5

/obj/item/weapon/gun/flamer/unique_action(mob/user)
	toggle_gun_safety()

/obj/item/weapon/gun/flamer/gun_safety_message(var/mob/user)
	to_chat(user, SPAN_NOTICE("You [SPAN_BOLD(flags_gun_features & GUN_TRIGGER_SAFETY ? "extinguish" : "ignite")] the pilot light."))
	playsound(user,'sound/weapons/handling/flamer_ignition.ogg', 25, 1)
	update_icon()

/obj/item/weapon/gun/flamer/get_examine_text(mob/user)
	. = ..()
	if(current_mag)
		. += "The fuel gauge shows the current tank is [round(current_mag.get_ammo_percent())]% full!"
	else
		. += "There's no tank in [src]!"

/obj/item/weapon/gun/flamer/update_icon()
	..()

	// Have to redo this here because we don't want the empty sprite when the tank is empty (just when it's not in the gun)
	var/new_icon_state = base_gun_icon
	if(has_empty_icon && !current_mag)
		new_icon_state += "_e"
	icon_state = new_icon_state

	if(current_mag && current_mag.reagents)
		var/image/I = image(icon, icon_state="[base_gun_icon]_strip")
		I.color = mix_color_from_reagents(current_mag.reagents.reagent_list)
		overlays += I

	if(!(flags_gun_features & GUN_TRIGGER_SAFETY))
		var/obj/item/attachable/attached_gun/flamer_nozzle/nozzle = locate() in contents
		var/image/I = image('icons/obj/items/weapons/guns/gun.dmi', src, "+lit")
		I.pixel_x += nozzle && nozzle == active_attachable ? 6 : 1
		overlays += I

/obj/item/weapon/gun/flamer/able_to_fire(mob/user)
	. = ..()
	if(.)
		if(!current_mag || !current_mag.current_rounds)
			return

/obj/item/weapon/gun/flamer/proc/get_fire_sound()
	var/list/fire_sounds = list(
					 'sound/weapons/gun_flamethrower1.ogg',
					 'sound/weapons/gun_flamethrower2.ogg',
					 'sound/weapons/gun_flamethrower3.ogg')
	return pick(fire_sounds)

/obj/item/weapon/gun/flamer/Fire(atom/target, mob/living/user, params, reflex)
	set waitfor = 0

	if(!able_to_fire(user))
		return

	var/turf/curloc = get_turf(user) //In case the target or we are expired.
	var/turf/targloc = get_turf(target)
	if (!targloc || !curloc)
		return //Something has gone wrong...

	if(active_attachable && active_attachable.flags_attach_features & ATTACH_WEAPON) //Attachment activated and is a weapon.
		if(active_attachable.flags_attach_features & ATTACH_PROJECTILE)
			return
		if(active_attachable.current_rounds <= 0)
			click_empty(user) //If it's empty, let them know.
			to_chat(user, SPAN_WARNING("[active_attachable] is empty!"))
			to_chat(user, SPAN_NOTICE("You disable [active_attachable]."))
			active_attachable.activate_attachment(src, null, TRUE)
		else
			active_attachable.fire_attachment(target, src, user) //Fire it.
			active_attachable.last_fired = world.time
		return

	if(flags_gun_features & GUN_TRIGGER_SAFETY)
		to_chat(user, SPAN_WARNING("\The [src] isn't lit!"))
		return

	if(!current_mag)
		return

	if(current_mag.current_rounds <= 0)
		click_empty(user)
	else
		user.track_shot(initial(name))
		unleash_flame(target, user)

/obj/item/weapon/gun/flamer/reload(mob/user, obj/item/ammo_magazine/magazine)
	if(!magazine || !istype(magazine))
		to_chat(user, SPAN_WARNING("That's not a magazine!"))
		return

	if(magazine.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("That [magazine.name] is empty!"))
		return

	if(!istype(src, magazine.gun_type))
		to_chat(user, SPAN_WARNING("That magazine doesn't fit in there!"))
		return

	if(!QDELETED(current_mag) && current_mag.loc == src)
		to_chat(user, SPAN_WARNING("It's still got something loaded!"))
		return

	else
		if(user)
			if(magazine.reload_delay > 1)
				to_chat(user, SPAN_NOTICE("You begin reloading [src]. Hold still..."))
				if(do_after(user,magazine.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY)) replace_magazine(user)
				else
					to_chat(user, SPAN_WARNING("Your reload was interrupted!"))
					return
			else replace_magazine(user, magazine)
		else
			current_mag = magazine
			magazine.forceMove(src)
			replace_ammo(,magazine)
	var/obj/item/ammo_magazine/flamer_tank/tank = magazine
	fuel_pressure = tank.fuel_pressure
	update_icon()
	return 1

/obj/item/weapon/gun/flamer/unload(mob/user, reload_override = 0, drop_override = 0)
	if(!current_mag)
		return //no magazine to unload
	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		current_mag.forceMove(get_turf(src)) //Drop it on the ground.
	else if (user)
		user.put_in_hands(current_mag)

	if (user)
		playsound(user, unload_sound, 25, 1)
		user.visible_message(SPAN_NOTICE("[user] unloads [current_mag] from [src]."),
		SPAN_NOTICE("You unload [current_mag] from [src]."))

	current_mag.update_icon()
	current_mag = null
	fuel_pressure = 1

	update_icon()

/obj/item/weapon/gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	last_fired = world.time
	if(!current_mag || !current_mag.reagents || !current_mag.reagents.reagent_list.len)
		return

	var/datum/reagent/R = current_mag.reagents.reagent_list[1]

	var/flameshape = R.flameshape
	var/fire_type = R.fire_type

	R.intensityfire = Clamp(R.intensityfire, current_mag.reagents.min_fire_int, current_mag.reagents.max_fire_int)
	R.durationfire = Clamp(R.durationfire, current_mag.reagents.min_fire_dur, current_mag.reagents.max_fire_dur)
	R.rangefire = Clamp(R.rangefire, current_mag.reagents.min_fire_rad, current_mag.reagents.max_fire_rad)
	var/max_range = R.rangefire
	if (max_range < fuel_pressure) //Used for custom tanks, allows for higher ranges
		max_range = Clamp(fuel_pressure, 0, current_mag.reagents.max_fire_rad)
	if(R.rangefire == -1)
		max_range = current_mag.reagents.max_fire_rad

	var/turf/temp[] = getline2(get_turf(user), get_turf(target))

	var/turf/to_fire = temp[2]

	var/obj/flamer_fire/fire = locate() in to_fire
	if(fire)
		qdel(fire)

	playsound(to_fire, src.get_fire_sound(), 50, TRUE)

	new /obj/flamer_fire(to_fire, create_cause_data(initial(name), user), R, max_range, current_mag.reagents, flameshape, target, CALLBACK(src, .proc/show_percentage, user), fuel_pressure, fire_type)

/obj/item/weapon/gun/flamer/proc/show_percentage(var/mob/living/user)
	if(current_mag)
		to_chat(user, SPAN_WARNING("The gauge reads: <b>[round(current_mag.get_ammo_percent())]</b>% fuel remains!"))

/obj/item/weapon/gun/flamer/underextinguisher
	starting_attachment_types = list(/obj/item/attachable/attached_gun/extinguisher)

/obj/item/weapon/gun/flamer/deathsquad //w-y deathsquad waist flamer
	name = "\improper M240A3 incinerator unit"
	desc = "A next-generation incinerator unit, the M240A3 is much lighter and dextrous than its predecessors thanks to the ceramic alloy construction. It can be slinged over a belt and usually comes equipped with X-type fuel."
	starting_attachment_types = list(/obj/item/attachable/attached_gun/extinguisher)
	flags_equip_slot = SLOT_BACK | SLOT_WAIST
	current_mag = /obj/item/ammo_magazine/flamer_tank/EX

/obj/item/weapon/gun/flamer/M240T
	name = "\improper M240-T incinerator unit"
	desc = "An improved version of the M240A1 incinerator unit, the M240-T model is capable of dispersing a larger variety of fuel types."
	icon_state = "m240t"
	item_state = "m240t"
	unacidable = TRUE
	indestructible = 1
	current_mag = null
	var/obj/item/storage/large_holster/fuelpack/fuelpack

	attachable_allowed = list(
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/extinguisher
	)
	starting_attachment_types = list(/obj/item/attachable/attached_gun/extinguisher/pyro)
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_WIELDED_FIRING_ONLY
	flags_item = TWOHANDED|NO_CRYO_STORE

/obj/item/weapon/gun/flamer/M240T/unique_action(mob/user)
	if(fuelpack)
		fuelpack.do_toggle_fuel(user)

/obj/item/weapon/gun/flamer/M240T/Destroy()
	if(fuelpack)
		if(fuelpack.linked_flamer == src)
			fuelpack.linked_flamer = null
		fuelpack = null
	. = ..()

/obj/item/weapon/gun/flamer/M240T/retrieval_check(var/mob/living/carbon/human/user, var/retrieval_slot)
	if(retrieval_slot == WEAR_IN_SCABBARD)
		var/obj/item/storage/large_holster/fuelpack/FP = user.back
		if(istype(FP) && !length(FP.contents))
			return TRUE
		return FALSE
	return ..()

/obj/item/weapon/gun/flamer/M240T/retrieve_to_slot(var/mob/living/carbon/human/user, var/retrieval_slot)
	if(retrieval_slot == WEAR_J_STORE) //If we are using a magharness...
		if(..(user, WEAR_IN_SCABBARD)) //...first try to put it onto the Broiler.
			return TRUE
	return ..()

/obj/item/weapon/gun/flamer/M240T/x_offset_by_attachment_type(var/attachment_type)
	switch(attachment_type)
		if(/obj/item/attachable/flashlight)
			return 7
	return 0

/obj/item/weapon/gun/flamer/M240T/y_offset_by_attachment_type(var/attachment_type)
	switch(attachment_type)
		if(/obj/item/attachable/flashlight)
			return -1
	return 0

/obj/item/weapon/gun/flamer/M240T/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 0, "muzzle_y" = 0, "rail_x" = 13, "rail_y" = 20, "under_x" = 21, "under_y" = 14, "stock_x" = 0, "stock_y" = 0)

/obj/item/weapon/gun/flamer/M240T/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if (!link_fuelpack(user) && !current_mag)
		to_chat(user, SPAN_WARNING("You must equip the specialized Broiler-T back harness or load in a fuel tank to use this incinerator unit!"))
		click_empty(user)
		return
	if (fuelpack)
		// Check we're actually firing the right fuel tank
		if (current_mag != fuelpack.active_fuel)
			// This was a manually loaded fuel tank
			if (current_mag && !(current_mag in list(fuelpack.fuel, fuelpack.fuelB, fuelpack.fuelX)))
				to_chat(user, SPAN_WARNING("\The [current_mag] is ejected by the Broiler-T back harness and replaced with \the [fuelpack.active_fuel]!"))
				unload(user, drop_override = TRUE)
			current_mag = fuelpack.active_fuel
			update_icon()
	..()


/obj/item/weapon/gun/flamer/M240T/reload(mob/user, obj/item/ammo_magazine/magazine)
	if (fuelpack)
		to_chat(user, SPAN_WARNING("The Broiler-T feed system cannot be reloaded manually."))
		return
	..()

/obj/item/weapon/gun/flamer/M240T/unload(mob/user, reload_override = 0, drop_override = 0, loc_override = 0)
	if (fuelpack && (current_mag in list(fuelpack.fuel, fuelpack.fuelB, fuelpack.fuelX)))
		to_chat(user, SPAN_WARNING("The incinerator tank is locked in place. It cannot be removed."))
		return
	..()

/obj/item/weapon/gun/flamer/M240T/able_to_fire(mob/user)
	. = ..()
	if(.)
		if(!current_mag || !current_mag.current_rounds)
			return FALSE

		if(!skillcheck(user, SKILL_SPEC_WEAPONS,  SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_PYRO)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return FALSE

/obj/item/weapon/gun/flamer/M240T/proc/link_fuelpack(var/mob/user)
	if (fuelpack)
		fuelpack.linked_flamer = null
		fuelpack = null

	if(istype(user.back, /obj/item/storage/large_holster/fuelpack))
		var/obj/item/storage/large_holster/fuelpack/FP = user.back
		if(FP.linked_flamer)
			FP.linked_flamer.fuelpack = null
		FP.linked_flamer = src
		fuelpack = FP
		return TRUE
	return FALSE


//////////////////////////////////////////////////////////////////////////////////////////////////
//Time to redo part of abby's code.
//Create a flame sprite object. Doesn't work like regular fire, ie. does not affect atmos or heat
/obj/flamer_fire
	name = "fire"
	desc = "Ouch!"
	anchored = 1
	mouse_opacity = 0
	icon = 'icons/effects/fire.dmi'
	icon_state = "dynamic_2"
	layer = BELOW_OBJ_LAYER

	var/firelevel = 12 //Tracks how much "fire" there is. Basically the timer of how long the fire burns
	var/burnlevel = 10 //Tracks how HOT the fire is. This is basically the heat level of the fire and determines the temperature.

	 /// After the fire is created, for 0.5 seconds this variable will be TRUE.
	var/initial_burst = TRUE

	var/flame_icon = "dynamic"
	var/flameshape = FLAMESHAPE_DEFAULT // diagonal square shape
	var/datum/cause_data/weapon_cause_data
	var/turf/target_clicked

	var/datum/reagent/tied_reagent
	var/datum/reagents/tied_reagents
	var/datum/callback/to_call

	var/fire_variant = FIRE_VARIANT_DEFAULT

/obj/flamer_fire/Initialize(mapload, var/datum/cause_data/cause_data, var/datum/reagent/R, fire_spread_amount = 0, var/datum/reagents/obj_reagents = null, new_flameshape = FLAMESHAPE_DEFAULT, var/atom/target = null, var/datum/callback/C, var/fuel_pressure = 1, var/fire_type = FIRE_VARIANT_DEFAULT)
	. = ..()
	if(!R)
		R = new /datum/reagent/napalm/ut()

	if(!tied_reagents)
		create_reagents(100) // So that the expanding flames are all linked together by 1 tied_reagents object
		tied_reagents = reagents
		tied_reagents.locked = TRUE

	flameshape = new_flameshape

	fire_variant = fire_type

	//non-dynamic flame is already colored
	if(R.burn_sprite == "dynamic")
		color = R.burncolor
	else
		flame_icon = R.burn_sprite

	tied_reagent = new R.type() // Can't get deleted this way
	tied_reagent.make_alike(R)

	tied_reagents = obj_reagents

	target_clicked = target

	if(istype(cause_data))
		weapon_cause_data = cause_data
	else if(cause_data)
		weapon_cause_data = create_cause_data(cause_data)
	else
		weapon_cause_data = create_cause_data(initial(name), null)

	icon_state = "[flame_icon]_2"

	//Fire duration increases with fuel usage
	firelevel = R.durationfire + fuel_pressure*R.durationmod
	burnlevel = R.intensityfire

	update_flame()

	addtimer(CALLBACK(src, .proc/un_burst_flame), 0.5 SECONDS)
	START_PROCESSING(SSobj, src)

	to_call = C

	var/burn_dam = burnlevel*FIRE_DAMAGE_PER_LEVEL

	if(tied_reagents && !tied_reagents.locked)
		var/removed = tied_reagents.remove_reagent(tied_reagent.id, FLAME_REAGENT_USE_AMOUNT * fuel_pressure)
		if(removed)
			qdel(src)
			return

	if(fire_spread_amount > 0)
		var/datum/flameshape/FS = GLOB.flameshapes[flameshape]
		if(!FS)
			CRASH("Invalid flameshape passed to /obj/flamer_fire. (Expected /datum/flameshape, got [FS] (id: [flameshape]))")

		FS.handle_fire_spread(src, fire_spread_amount, burn_dam, fuel_pressure)
	//Apply fire effects onto everyone in the fire

	// Melt a single layer of snow
	if (istype(loc, /turf/open/snow))
		var/turf/open/snow/S = loc

		if (S.bleed_layer > 0)
			S.bleed_layer--
			S.update_icon(1, 0)

	if (istype(loc, /turf/open/auto_turf/snow))
		var/turf/open/auto_turf/snow/S = loc
		if(S.bleed_layer > 0)
			var/new_layer = S.bleed_layer - 1
			S.changing_layer(new_layer)

	for(var/mob/living/M in loc) //Deal bonus damage if someone's caught directly in initial stream
		if(M.stat == DEAD)
			continue

		if(ishuman(M))
			var/mob/living/carbon/human/H = M //fixed :s

			if(weapon_cause_data)
				var/mob/user = weapon_cause_data.resolve_mob()
				if(user)
					var/area/thearea = get_area(user)
					if(user.faction == H.faction && !thearea?.statistic_exempt)
						H.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> shot <b>[key_name(H)]</b> with \a <b>[name]</b> in [get_area(user)]."
						user.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> shot <b>[key_name(H)]</b> with \a <b>[name]</b> in [get_area(user)]."
						if(weapon_cause_data.cause_name)
							H.track_friendly_fire(weapon_cause_data.cause_name)
						var/ff_msg = "[key_name(user)] shot [key_name(H)] with \a [name] in [get_area(user)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>) ([user.client ? "<a href='?priv_msg=[user.client.ckey]'>PM</a>" : "NO CLIENT"])"
						var/ff_living = TRUE
						if(H.stat == DEAD)
							ff_living = FALSE
						msg_admin_ff(ff_msg, ff_living)
					else
						H.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> shot <b>[key_name(H)]</b> with \a <b>[name]</b> in [get_area(user)]."
						user.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> shot <b>[key_name(H)]</b> with \a <b>[name]</b> in [get_area(user)]."
						msg_admin_attack("[key_name(user)] shot [key_name(H)] with \a [name] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
				if(weapon_cause_data.cause_name)
					H.track_shot_hit(weapon_cause_data.cause_name, H)

		var/fire_intensity_resistance = M.check_fire_intensity_resistance()
		var/firedamage = max(burn_dam - fire_intensity_resistance, 0)
		if(!firedamage)
			continue

		var/sig_result = SEND_SIGNAL(M, COMSIG_LIVING_FLAMER_FLAMED, tied_reagent)

		if(!(sig_result & COMPONENT_NO_IGNITE))
			switch(fire_variant)
				if(FIRE_VARIANT_TYPE_B) //Armor Shredding Greenfire, super easy to pat out. 50 duration -> 10 stacks (1 pat/resist)
					M.TryIgniteMob(round(tied_reagent.durationfire / 5), tied_reagent)
				else
					M.TryIgniteMob(tied_reagent.durationfire, tied_reagent)

		if(sig_result & COMPONENT_NO_BURN)
			continue

		M.last_damage_data = weapon_cause_data
		M.apply_damage(firedamage, BURN)

		var/msg = "Augh! You are roasted by the flames!"
		if (isXeno(M))
			to_chat(M, SPAN_XENODANGER(msg))
		else
			to_chat(M, SPAN_HIGHDANGER(msg))

		if(weapon_cause_data)
			var/mob/SM = weapon_cause_data.resolve_mob()
			if(istype(SM))
				SM.track_shot_hit(weapon_cause_data.cause_name)

/obj/flamer_fire/Destroy()
	SetLuminosity(0)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/flamer_fire/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_FLAME

/obj/flamer_fire/Crossed(atom/movable/atom_movable)
	atom_movable.handle_flamer_fire_crossed(src)

/obj/flamer_fire/proc/type_b_debuff_xeno_armor(var/mob/living/carbon/Xenomorph/X)
	var/sig_result = SEND_SIGNAL(X, COMSIG_LIVING_FLAMER_CROSSED, tied_reagent)
	. = 1
	if(sig_result & COMPONENT_XENO_FRENZY)
		. = 0.8
	if(sig_result & COMPONENT_NO_IGNITE)
		. = 0.6
	X.armor_deflection_debuff = (X.armor_deflection + X.armor_deflection_buff) * 0.5 * . //At the moment this just directly sets the debuff var since it's the only interaction with it. In the future if the var is used more, usages of type_b_debuff_armor may need to be refactored (or just make them mutually exclusive and have the highest overwrite).

/mob/living/carbon/Xenomorph/proc/reset_xeno_armor_debuff_after_time(var/mob/living/carbon/Xenomorph/X, var/wait_ticks) //Linked onto Xenos instead of the fire so it doesn't cancel on fire deletion.
	spawn(wait_ticks)
	if(X.armor_deflection_debuff)
		X.armor_deflection_debuff = 0

/obj/flamer_fire/proc/set_on_fire(mob/living/M)
	if(!istype(M))
		return

	var/sig_result = SEND_SIGNAL(M, COMSIG_LIVING_FLAMER_CROSSED, tied_reagent)
	var/burn_damage = round(burnlevel * 0.5)
	switch(fire_variant)
		if(FIRE_VARIANT_TYPE_B) //Armor Shredding Greenfire, 2x tile damage (Equiavlent to UT)
			burn_damage = burnlevel
	var/fire_intensity_resistance = M.check_fire_intensity_resistance()

	if(!tied_reagent.fire_penetrating)
		burn_damage = max(burn_damage - fire_intensity_resistance * 0.5, 0)

	if(sig_result & COMPONENT_XENO_FRENZY)
		var/mob/living/carbon/Xenomorph/X = M
		if(X.plasma_stored != X.plasma_max) //limit num of noise
			to_chat(X, SPAN_DANGER("The heat of the fire roars in your veins! KILL! CHARGE! DESTROY!"))
			X.emote("roar")
		X.plasma_stored = X.plasma_max

	if(!(sig_result & COMPONENT_NO_IGNITE) && burn_damage)
		switch(fire_variant)
			if(FIRE_VARIANT_TYPE_B) //Armor Shredding Greenfire, super easy to pat out. 50 duration -> 10 stacks (1 pat/resist)
				M.TryIgniteMob(round(tied_reagent.durationfire / 5), tied_reagent)
			else
				M.TryIgniteMob(tied_reagent.durationfire, tied_reagent)

	if(sig_result & COMPONENT_NO_BURN && !tied_reagent.fire_penetrating)
		burn_damage = 0

	if(!burn_damage)
		to_chat(M, SPAN_DANGER("You step over the flames."))
		return

	M.last_damage_data = weapon_cause_data
	M.apply_damage(burn_damage, BURN) //This makes fire stronk.

	var/variant_burn_msg = null
	switch(fire_variant) //Fire variant special message appends.
		if(FIRE_VARIANT_TYPE_B)
			if(isXeno(M))
				var/mob/living/carbon/Xenomorph/X = M
				X.armor_deflection?(variant_burn_msg=" You feel the flames weakening your exoskeleton!"):(variant_burn_msg=" You feel the flaming chemicals eating into your body!")
	to_chat(M, SPAN_DANGER("You are burned![variant_burn_msg?"[variant_burn_msg]":""]"))
	M.updatehealth()

/obj/flamer_fire/proc/update_flame()
	if(burnlevel < 15 && flame_icon != "dynamic")
		color = "#c1c1c1" //make it darker to make show its weaker.
	var/flame_level = 1
	switch(firelevel)
		if(1 to 9)
			flame_level = 1
		if(10 to 25)
			flame_level = 2
		if(25 to INFINITY) //Change the icons and luminosity based on the fire's intensity
			flame_level = 3

	if(initial_burst)
		flame_level++ //the initial flame burst is 1 level higher for a small time

	icon_state = "[flame_icon]_[flame_level]"
	SetLuminosity(flame_level * 2)

/obj/flamer_fire/proc/un_burst_flame()
	initial_burst = FALSE
	update_flame()

/obj/flamer_fire/process(delta_time)
	var/turf/T = loc
	firelevel = max(0, firelevel)
	if(!istype(T)) //Is it a valid turf? Has to be on a floor
		qdel(src)
		return PROCESS_KILL
	var/damage = burnlevel*delta_time
	T.flamer_fire_act(damage)

	update_flame()

	if(!firelevel)
		qdel(src)
		return

	for(var/atom/thing in loc)
		thing.handle_flamer_fire(src, damage, delta_time)

	//This has been made a simple loop, for the most part flamer_fire_act() just does return, but for specific items it'll cause other effects.
	firelevel -= 2 //reduce the intensity by 2 per tick
	return

/proc/fire_spread_recur(var/turf/target, var/datum/cause_data/cause_data, remaining_distance, direction, fire_lvl, burn_lvl, f_color, burn_sprite = "dynamic", var/aerial_flame_level)
	var/direction_angle = dir2angle(direction)
	var/obj/flamer_fire/foundflame = locate() in target
	if(!foundflame)
		var/datum/reagent/R = new()
		R.intensityfire = burn_lvl
		R.durationfire = fire_lvl
		R.burn_sprite = burn_sprite
		R.burncolor = f_color
		new/obj/flamer_fire(target, cause_data, R)
	if(target.density)
		return

	for(var/spread_direction in alldirs)

		var/spread_power = remaining_distance

		var/spread_direction_angle = dir2angle(spread_direction)

		var/angle = 180 - abs( abs( direction_angle - spread_direction_angle ) - 180 ) // the angle difference between the spread direction and initial direction

		switch(angle) //this reduces power when the explosion is going around corners
			if (0)
				//no change
			if (45)
				spread_power *= 0.75
			else //turns out angles greater than 90 degrees almost never happen. This bit also prevents trying to spread backwards
				continue

		switch(spread_direction)
			if(NORTH,SOUTH,EAST,WEST)
				spread_power--
			else
				spread_power -= 1.414 //diagonal spreading

		if (spread_power < 1)
			continue

		var/turf/T = get_step(target, spread_direction)

		if(!T) //prevents trying to spread into "null" (edge of the map?)
			continue

		if(aerial_flame_level && (T.get_pylon_protection_level() >= aerial_flame_level))
			break

		spawn(0)
			fire_spread_recur(T, cause_data, spread_power, spread_direction, fire_lvl, burn_lvl, f_color, burn_sprite, aerial_flame_level)

/proc/fire_spread(var/turf/target, var/datum/cause_data/cause_data, range, fire_lvl, burn_lvl, f_color, burn_sprite = "dynamic", var/aerial_flame_level = TURF_PROTECTION_NONE)
	var/datum/reagent/R = new()
	R.intensityfire = burn_lvl
	R.durationfire = fire_lvl
	R.burn_sprite = burn_sprite
	R.burncolor = f_color

	new/obj/flamer_fire(target, cause_data, R)
	for(var/direction in alldirs)
		var/spread_power = range
		switch(direction)
			if(NORTH,SOUTH,EAST,WEST)
				spread_power--
			else
				spread_power -= 1.414 //diagonal spreading
		var/turf/T = get_step(target, direction)
		if(aerial_flame_level && (T.get_pylon_protection_level() >= aerial_flame_level))
			continue
		fire_spread_recur(T, cause_data, spread_power, direction, fire_lvl, burn_lvl, f_color, burn_sprite, aerial_flame_level)
