


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
	var/max_range = 9 //9 tiles, 7 is screen range, controlled by the type of napalm in the canister. We max at 9 since diagonal bullshit.
	var/lit = 0 //Turn the flamer on/off

	attachable_allowed = list( //give it some flexibility.
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/attached_gun/extinguisher)
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/flamer/New()
	. = ..()
	update_icon()


/obj/item/weapon/gun/flamer/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 0, "muzzle_y" = 0,"rail_x" = 9, "rail_y" = 21, "under_x" = 21, "under_y" = 14, "stock_x" = 0, "stock_y" = 0)

/obj/item/weapon/gun/flamer/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4 * 5

/obj/item/weapon/gun/flamer/unique_action(mob/user)
	toggle_flame(user)

/obj/item/weapon/gun/flamer/examine(mob/user)
	..()
	to_chat(user, "It's turned [lit? "on" : "off"].")
	if(current_mag)
		to_chat(user, "The fuel gauge shows the current tank is [round(current_mag.get_ammo_percent())]% full!")
	else
		to_chat(user, "There's no tank in [src]!")

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

	if(lit)
		var/image/I = image('icons/obj/items/weapons/guns/gun.dmi', src, "+lit")
		I.pixel_x += 3
		overlays += I

/obj/item/weapon/gun/flamer/able_to_fire(mob/user)
	. = ..()
	if(.)
		if(!current_mag || !current_mag.current_rounds)
			return

/obj/item/weapon/gun/flamer/proc/toggle_flame(mob/user)
	playsound(user,'sound/weapons/handling/flamer_ignition.ogg', 25, 1)
	lit = !lit

	update_icon()

/obj/item/weapon/gun/flamer/proc/get_fire_sound()
	var/list/fire_sounds = list(
					 'sound/weapons/gun_flamethrower1.ogg',
					 'sound/weapons/gun_flamethrower2.ogg',
					 'sound/weapons/gun_flamethrower3.ogg')
	return pick(fire_sounds)

/obj/item/weapon/gun/flamer/Fire(atom/target, mob/living/user, params, reflex)
	set waitfor = 0
	if(!able_to_fire(user)) return
	var/turf/curloc = get_turf(user) //In case the target or we are expired.
	var/turf/targloc = get_turf(target)
	if (!targloc || !curloc) return //Something has gone wrong...

	if(!lit)
		to_chat(user, SPAN_WARNING("The weapon isn't lit"))
		return

	if(!current_mag) return
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
			magazine.loc = src
			replace_ammo(,magazine)

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

	update_icon()

/obj/item/weapon/gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	last_fired = world.time
	if(!current_mag || !current_mag.reagents || !current_mag.reagents.reagent_list.len)
		return

	var/datum/reagent/R = current_mag.reagents.reagent_list[1]

	var/flameshape = R.flameshape

	R.intensityfire = Clamp(R.intensityfire, current_mag.reagents.min_fire_int, current_mag.reagents.max_fire_int)
	R.durationfire = Clamp(R.durationfire, current_mag.reagents.min_fire_dur, current_mag.reagents.max_fire_dur)
	R.rangefire = Clamp(R.rangefire, current_mag.reagents.min_fire_rad, current_mag.reagents.max_fire_rad)
	var/max_range = R.rangefire

	if(R.rangefire == -1)
		max_range = current_mag.reagents.max_fire_rad

	var/turf/temp[] = getline2(get_turf(user), get_turf(target))

	var/turf/to_fire = temp[2]

	var/obj/flamer_fire/fire = locate() in to_fire
	if(fire)
		qdel(fire)

	playsound(to_fire, src.get_fire_sound(), 50, TRUE)

	new /obj/flamer_fire(to_fire, initial(name), user, R, max_range, current_mag.reagents, flameshape, target, CALLBACK(src, .proc/show_percentage, user))

/obj/item/weapon/gun/flamer/proc/show_percentage(var/mob/living/user)
	if(current_mag)
		to_chat(user, SPAN_WARNING("The gauge reads: <b>[round(current_mag.get_ammo_percent())]</b>% fuel remains!"))

/obj/item/weapon/gun/flamer/underextinguisher
	starting_attachment_types = list(/obj/item/attachable/attached_gun/extinguisher)

/obj/item/weapon/gun/flamer/M240T
	name = "\improper M240-T incinerator unit"
	desc = "An improved version of the M240A1 incinerator unit, the M240-T model is capable of dispersing a larger variety of fuel types."
	icon_state = "m240t"
	item_state = "m240t"
	unacidable = TRUE
	indestructible = 1
	current_mag = null
	var/obj/item/storage/large_holster/fuelpack/fuelpack
	starting_attachment_types = list(/obj/item/attachable/attached_gun/extinguisher/pyro)

/obj/item/weapon/gun/flamer/M240T/Destroy()
	if(fuelpack)
		if(fuelpack.linked_flamer == src)
			fuelpack.linked_flamer = null
		fuelpack = null
	. = ..()

/obj/item/weapon/gun/flamer/M240T/harness_check(var/mob/living/carbon/human/user)
	if (..())
		return TRUE

	var/obj/item/I = user.back
	if(!istype(I, /obj/item/storage/large_holster/fuelpack))
		return FALSE
	return TRUE

/obj/item/weapon/gun/flamer/M240T/harness_return(var/mob/living/carbon/human/user)
	var/obj/item/storage/large_holster/fuelpack/FP = user.back
	if (istype(FP) && FP.handle_item_insertion(src, TRUE))
		to_chat(user, SPAN_WARNING("[src] snaps into place on [FP]."))
		return

	..()

/obj/item/weapon/gun/flamer/M240T/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 0, "muzzle_y" = 0,"rail_x" = 9, "rail_y" = 21, "under_x" = 21, "under_y" = 14, "stock_x" = 0, "stock_y" = 0)

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
				unload()
			current_mag = fuelpack.active_fuel
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

		if(!skillcheck(user, SKILL_SPEC_WEAPONS,  SKILL_SPEC_TRAINED) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_PYRO)
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

	var/flame_icon = "dynamic"
	var/flameshape = FLAMESHAPE_DEFAULT // diagonal square shape
	var/weapon_source
	var/weapon_source_mob
	var/turf/target_clicked

	var/datum/reagent/tied_reagent
	var/datum/reagents/tied_reagents
	var/datum/callback/to_call

/obj/flamer_fire/Initialize(mapload, var/source, var/source_mob, var/datum/reagent/R, fire_spread_amount = 0, var/datum/reagents/obj_reagents = null, new_flameshape = FLAMESHAPE_DEFAULT, var/atom/target = null, var/datum/callback/C)
	. = ..()
	if(!R)
		R = new /datum/reagent/napalm/ut()

	if(!tied_reagents)
		create_reagents(100) // So that the expanding flames are all linked together by 1 tied_reagents object
		tied_reagents = reagents
		tied_reagents.locked = TRUE

	flameshape = new_flameshape

	color = R.burncolor

	tied_reagent = new R.type() // Can't get deleted this way
	tied_reagent.make_alike(R)

	tied_reagents = obj_reagents

	target_clicked = target
	weapon_source = source
	weapon_source_mob = source_mob

	icon_state = "[flame_icon]_2"

	firelevel = R.durationfire
	burnlevel = R.intensityfire

	START_PROCESSING(SSobj, src)

	to_call = C

	var/burn_dam = burnlevel*FIRE_DAMAGE_PER_LEVEL

	if(tied_reagents && !tied_reagents.locked)
		var/removed = tied_reagents.remove_reagent(tied_reagent.id, FLAME_REAGENT_USE_AMOUNT)
		if(removed)
			qdel(src)
			return

	if(fire_spread_amount > 0)
		var/datum/flameshape/FS = flameshapes[flameshape]
		if(!FS)
			CRASH("Invalid flameshape passed to /obj/flamer_fire. (Expected /datum/flameshape, got [FS] (id: [flameshape]))")

		FS.handle_fire_spread(src, fire_spread_amount, burn_dam)
	//Apply fire effects onto everyone in the fire

	// Melt a single layer of snow
	if (istype(loc, /turf/open/snow))
		var/turf/open/snow/S = loc

		if (S.bleed_layer > 0)
			S.bleed_layer -= 1
			S.update_icon(1, 0)

	if (istype(loc, /turf/open/auto_turf/snow))
		var/turf/open/auto_turf/snow/S = loc
		if(S.bleed_layer > 0)
			var/new_layer = S.bleed_layer - 1
			S.changing_layer(new_layer)

	for(var/mob/living/M in loc) //Deal bonus damage if someone's caught directly in initial stream
		if(M.stat == DEAD)
			continue

		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(!X.caste)
				CRASH("CASTE ERROR: flamer New() was called without a caste. (name: [X.name], disposed: [QDELETED(X)], health: [X.health])")
			if(X.caste.fire_immune && !tied_reagent.fire_penetrating)
				continue
			if(X.burrow)
				continue
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M //fixed :s

			if(weapon_source_mob)
				var/mob/user = weapon_source_mob
				if(user.faction == H.faction && !get_area(user)?.statistic_exempt)
					H.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> shot <b>[key_name(H)]</b> with \a <b>[name]</b> in [get_area(user)]."
					user.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> shot <b>[key_name(H)]</b> with \a <b>[name]</b> in [get_area(user)]."
					if(weapon_source)
						H.track_friendly_fire(weapon_source)
					msg_admin_ff("[key_name(user)] shot [key_name(H)] with \a [name] in [get_area(user)] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>) (<a href='?priv_msg=\ref[user.client]'>PM</a>)")
				else
					H.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> shot <b>[key_name(H)]</b> with \a <b>[name]</b> in [get_area(user)]."
					user.attack_log += "\[[time_stamp()]\] <b>[key_name(user)]</b> shot <b>[key_name(H)]</b> with \a <b>[name]</b> in [get_area(user)]."
					msg_admin_attack("[key_name(user)] shot [key_name(H)] with \a [name] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
				if(weapon_source)
					H.track_shot_hit(weapon_source, H)


		if (raiseEventSync(M, EVENT_PREIGNITION_CHECK) != HALTED || tied_reagent.fire_penetrating)
			M.adjust_fire_stacks(tied_reagent.durationfire, tied_reagent)
			M.IgniteMob()

		// If fire shield is on, do not receive burn damage
		if (raiseEventSync(M, EVENT_PRE_FIRE_BURNED_CHECK) == HALTED && !tied_reagent.fire_penetrating)
			continue

		M.last_damage_mob = weapon_source_mob
		M.apply_damage(burn_dam, BURN)

		var/msg = "Augh! You are roasted by the flames!"
		if (isXeno(M))
			to_chat(M, SPAN_XENODANGER(msg))
		else
			to_chat(M, SPAN_HIGHDANGER(msg))

		if(weapon_source)
			M.last_damage_source = weapon_source
		else
			M.last_damage_source = initial(name)
		if(weapon_source_mob)
			var/mob/SM = weapon_source_mob
			SM.track_shot_hit(weapon_source)

/obj/flamer_fire/Destroy()
	SetLuminosity(0)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/flamer_fire/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_FLAME

/obj/flamer_fire/Crossed(mob/living/M) //Only way to get it to reliable do it when you walk into it.
	if(!istype(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(isXeno(H.pulledby))
			var/mob/living/carbon/Xenomorph/Z = H.pulledby
			if(raiseEventSync(Z, EVENT_PREIGNITION_CHECK) != HALTED && !tied_reagent.fire_penetrating)
				Z.adjust_fire_stacks(tied_reagent.durationfire, tied_reagent)
				Z.IgniteMob()
		if(istype(H.wear_suit, /obj/item/clothing/suit/storage/marine/M35) || istype(H.wear_suit, /obj/item/clothing/suit/fire))
			if (raiseEventSync(H, EVENT_PRE_FIRE_BURNED_CHECK) == HALTED)
				return
			H.show_message(text("Your suit protects you from the flames."),1)
			H.apply_damage(burnlevel*0.25, BURN) //Does small burn damage to a person wearing one of the suits.
			return

	if(isXeno(M))
		var/mob/living/carbon/Xenomorph/X = M
		if(X.caste.fire_immune && !tied_reagent.fire_penetrating)
			return
		if(X.burrow)
			return

	if (raiseEventSync(M, EVENT_PREIGNITION_CHECK) != HALTED || tied_reagent.fire_penetrating)
		M.adjust_fire_stacks(tied_reagent.durationfire, tied_reagent) //Make it possible to light them on fire later.
		M.IgniteMob()

	if(weapon_source)
		M.last_damage_source = weapon_source
	else
		M.last_damage_source = initial(name)

	M.last_damage_mob = weapon_source_mob
	M.apply_damage(round(burnlevel*0.5), BURN) //This makes fire stronk.
	to_chat(M, SPAN_DANGER("You are burned!"))
	if(isXeno(M))
		M.updatehealth()


/obj/flamer_fire/proc/updateicon()
	if(burnlevel < 15 && flame_icon != "dynamic")
		color = "#c1c1c1" //make it darker to make show its weaker.
	switch(firelevel)
		if(1 to 9)
			icon_state = "[flame_icon]_1"
			SetLuminosity(2)
		if(10 to 25)
			icon_state = "[flame_icon]_2"
			SetLuminosity(4)
		if(25 to INFINITY) //Change the icons and luminosity based on the fire's intensity
			icon_state = "[flame_icon]_3"
			SetLuminosity(6)


/obj/flamer_fire/process()
	var/turf/T = loc
	firelevel = max(0, firelevel)
	if(!istype(T)) //Is it a valid turf? Has to be on a floor
		qdel(src)
		return

	updateicon()

	if(!firelevel)
		qdel(src)
		return

	var/j = 0
	for(var/i in loc)
		if(++j >= 11) break
		if(isliving(i))
			var/mob/living/I = i
			if(isXenoBurrower(I))
				var/mob/living/carbon/Xenomorph/Burrower/B = I
				if(B.burrow)
					continue
			if(isXenoRavager(I) && !tied_reagent.fire_penetrating)
				if(!I.stat)
					var/mob/living/carbon/Xenomorph/Ravager/X = I
					X.plasma_stored = X.plasma_max
					X.used_charge = 0 //Reset charge cooldown
					X.show_message(text(SPAN_DANGER("The heat of the fire roars in your veins! KILL! CHARGE! DESTROY!")),1)
					if(rand(1,100) < 70)
						X.emote("roar")
				continue
			if(ishuman(I))
				var/mob/living/carbon/human/H = I
				if(istype(H.wear_suit, /obj/item/clothing/suit/storage/marine/M35) || istype(H.wear_suit, /obj/item/clothing/suit/fire))
					continue
			if (raiseEventSync(I, EVENT_PREIGNITION_CHECK) == HALTED && !tied_reagent.fire_penetrating)
				continue
			I.adjust_fire_stacks(firelevel, tied_reagent) // If I stand in the fire I deserve all of this. Also Napalm stacks quickly.
			I.IgniteMob()
			I.show_message(text(SPAN_WARNING("You are burned!")), 1)
			if(isXeno(I)) //Have no fucken idea why the Xeno thing was there twice.
				var/mob/living/carbon/Xenomorph/X = I
				X.updatehealth()
		if(isobj(i))
			var/obj/O = i
			O.flamer_fire_act()

	//This has been made a simple loop, for the most part flamer_fire_act() just does return, but for specific items it'll cause other effects.
	firelevel -= 2 //reduce the intensity by 2 per tick
	return

/proc/fire_spread_recur(var/turf/target, var/source, var/source_mob, remaining_distance, direction, fire_lvl, burn_lvl, f_color)
	var/direction_angle = dir2angle(direction)
	var/obj/flamer_fire/foundflame = locate() in target
	if(!foundflame)
		var/datum/reagent/R = new()
		R.intensityfire = burn_lvl
		R.durationfire = fire_lvl

		R.burncolor = f_color
		new/obj/flamer_fire(target, source, source_mob, R)

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
				spread_power -= 1
			else
				spread_power -= 1.414 //diagonal spreading

		if (spread_power < 1)
			continue

		var/turf/T = get_step(target, spread_direction)

		if(!T) //prevents trying to spread into "null" (edge of the map?)
			continue

		if(T.density)
			continue

		spawn(0)
			fire_spread_recur(T, source, source_mob, spread_power, spread_direction, fire_lvl, burn_lvl, f_color)

/proc/fire_spread(var/turf/target, var/source, var/source_mob, range, fire_lvl, burn_lvl, f_color)
	var/datum/reagent/R = new()
	R.intensityfire = burn_lvl
	R.durationfire = fire_lvl

	R.burncolor = f_color

	new/obj/flamer_fire(target, source, source_mob, R)
	for(var/direction in alldirs)
		var/spread_power = range
		switch(direction)
			if(NORTH,SOUTH,EAST,WEST)
				spread_power -= 1
			else
				spread_power -= 1.414 //diagonal spreading
		var/turf/T = get_step(target, direction)
		fire_spread_recur(T, source, source_mob, spread_power, direction, fire_lvl, burn_lvl, f_color)
