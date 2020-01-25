


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
						/obj/item/attachable/magnetic_harness)
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_WIELDED_FIRING_ONLY
	gun_skill_category = SKILL_HEAVY_WEAPONS

/obj/item/weapon/gun/flamer/New()
	..()
	update_icon()


/obj/item/weapon/gun/flamer/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 0, "muzzle_y" = 0,"rail_x" = 9, "rail_y" = 21, "under_x" = 0, "under_y" = 0, "stock_x" = 0, "stock_y" = 0)

/obj/item/weapon/gun/flamer/set_gun_config_values()
	..()
	fire_delay = config.max_fire_delay * 5

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

	if (istype(magazine, /obj/item/ammo_magazine/flamer_tank/large))
		to_chat(user, SPAN_WARNING("That tank is too large for this model!"))
		return

	if(!isnull(current_mag) && current_mag.loc == src)
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
	if(!current_mag) return //no magazine to unload
	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		current_mag.forceMove(get_turf(src)) //Drop it on the ground.
	else user.put_in_hands(current_mag)

	playsound(user, unload_sound, 25, 1)
	user.visible_message(SPAN_NOTICE("[user] unloads [current_mag] from [src]."),
	SPAN_NOTICE("You unload [current_mag] from [src]."))
	current_mag.update_icon()
	current_mag = null

	update_icon()

/obj/item/weapon/gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	last_fired = world.time
	var/burnlevel
	var/burntime
	var/fire_color = "red"

	switch(current_mag.caliber)
		if("UT-Napthal Fuel") //This isn't actually Napalm actually
			burnlevel = config.med_burnlevel
			burntime = config.low_burntime
			max_range = config.close_shell_range

		// Area denial, light damage, large AOE, long burntime
		if("Napalm B")
			burnlevel = config.low_burnlevel
			burntime = config.instant_burntime
			max_range = config.min_shell_range
			playsound(user, src.get_fire_sound(), 50, 1)
			triangular_flame(target, user, burntime, burnlevel)
			return

		if("Napalm Gel") //Long range, low damage
			burnlevel = config.low_burnlevel
			burntime = config.instant_burntime
			max_range = config.near_shell_range
			fire_color = "green"
			playsound(user, src.get_fire_sound(), 50, 1)

		if("Napalm X") //Probably can end up as a spec fuel or DS flamer fuel. Also this was the original fueltype, the madman i am.
			burnlevel = config.high_burnlevel
			burntime = config.high_burntime
			max_range = config.near_shell_range
			fire_color = "blue"

		if("Fuel") //This is welding fuel and thus pretty weak. Not ment to be exactly used for flamers either.
			burnlevel = config.min_burnlevel
			burntime = config.min_burntime
			max_range = config.min_shell_range

		else return

	var/list/turf/turfs = getline2(user,target)
	playsound(user, src.get_fire_sound(), 50, 1)
	var/distance = 1
	var/turf/prev_T = user.loc
	var/stop_at_turf = FALSE

	for(var/turf/T in turfs)
		if(T == user.loc)
			prev_T = T
			continue
		if(loc != user)
			break
		if(!current_mag || !current_mag.current_rounds)
			break
		if(distance > max_range)
			break

		current_mag.current_rounds--
		if(T.density)
			T.flamer_fire_act(rand(burnlevel*2, burnlevel*3))
			stop_at_turf = TRUE
		else if(prev_T)
			var/atom/movable/temp = new/obj/flamer_fire()
			var/atom/movable/AM = LinkBlocked(temp, prev_T, T)
			qdel(temp)
			if(AM)
				AM.flamer_fire_act(rand(burnlevel*2, burnlevel*3))
				if (AM.flags_atom & ON_BORDER)
					break
				stop_at_turf = TRUE
		var/obj/flamer_fire/foundflame = locate() in T
		if(foundflame)
			qdel(foundflame) //No stacking
		flame_turf(T, user, burntime, burnlevel, fire_color)
		if (stop_at_turf)
			break
		distance++
		prev_T = T
		sleep(1)

	if(current_mag)
		to_chat(user, SPAN_WARNING("The gauge reads: <b>[round(current_mag.get_ammo_percent())]</b>% fuel remains."))

/obj/item/weapon/gun/flamer/proc/flame_turf(turf/T, mob/living/user, heat, burn, f_color = "red")
	if(!istype(T))
		return

	new /obj/flamer_fire(T, initial(name), user, heat, burn, f_color, 0)

/obj/item/weapon/gun/flamer/proc/triangular_flame(var/atom/target, var/mob/living/user, var/burntime, var/burnlevel)
	set waitfor = 0

	var/unleash_dir = user.dir //don't want the player to turn around mid-unleash to bend the fire.
	var/list/turf/turfs = getline2(user,target)
	playsound(user, src.get_fire_sound(), 50, 1)
	var/distance = 1
	var/turf/prev_T = user.loc
	var/hit_dense_atom_mid = FALSE
	var/burn_dam = rand(burnlevel*2, burnlevel*3)

	for(var/turf/T in turfs)
		if(T == user.loc)
			prev_T = T
			continue
		if(loc != user)
			break
		if(!current_mag || !current_mag.current_rounds)
			break
		if(distance > max_range)
			break

		current_mag.current_rounds--
		if(T.density)
			T.flamer_fire_act()
			hit_dense_atom_mid = TRUE
		else if(prev_T)
			var/atom/movable/temp = new/obj/flamer_fire()
			var/atom/movable/AM = LinkBlocked(temp, prev_T, T)
			qdel(temp)
			if(AM)
				AM.flamer_fire_act(burn_dam)
				if (AM.flags_atom & ON_BORDER)
					break
				hit_dense_atom_mid = TRUE
		flame_turf(T,user, burntime, burnlevel, "green")
		prev_T = T
		sleep(1)

		var/list/turf/right = list()
		var/list/turf/left = list()
		var/turf/right_turf = T
		var/turf/left_turf = T
		var/right_dir = turn(unleash_dir, 90)
		var/left_dir = turn(unleash_dir, -90)
		for (var/i = 0, i < distance - 1, i++)
			right_turf = get_step(right_turf, right_dir)
			right += right_turf
			left_turf = get_step(left_turf, left_dir)
			left += left_turf

		var/hit_dense_atom_side = FALSE

		var/turf/prev_R = T
		for (var/turf/R in right)
			if(prev_R)
				var/atom/movable/temp = new/obj/flamer_fire()
				var/atom/movable/AM = LinkBlocked(temp, prev_R, R)
				qdel(temp)
				if(AM)
					AM.flamer_fire_act(burn_dam)
					if (AM.flags_atom & ON_BORDER)
						break
					hit_dense_atom_side = TRUE
				else if (hit_dense_atom_mid)
					break
			flame_turf(R, user, burntime, burnlevel, "green")
			if (!hit_dense_atom_mid && hit_dense_atom_side)
				break
			prev_R = R
			sleep(1)

		var/turf/prev_L = T
		for (var/turf/L in left)
			if(prev_L)
				var/atom/movable/temp = new/obj/flamer_fire()
				var/atom/movable/AM = LinkBlocked(temp, prev_L, L)
				qdel(temp)
				if(AM)
					AM.flamer_fire_act(burn_dam)
					if (AM.flags_atom & ON_BORDER)
						break
					hit_dense_atom_side = TRUE
				else if (hit_dense_atom_mid)
					break
			flame_turf(L, user, burntime, burnlevel, "green")
			if (!hit_dense_atom_mid && hit_dense_atom_side)
				break
			prev_L = L
			sleep(1)

		if (hit_dense_atom_mid)
			break

		distance++
	to_chat(user, SPAN_WARNING("The gauge reads: <b>[round(current_mag.get_ammo_percent())]</b>% fuel remains!"))



/obj/item/weapon/gun/flamer/M240T
	name = "\improper M240-T incinerator unit"
	desc = "An improved version of the M240A1 incenerator unit, the M240-T model is capable of dispersing a larger variety of fuel types."
	icon_state = "m240t"
	item_state = "m240t"
	unacidable = TRUE
	indestructible = 1
	current_mag = null
	var/obj/item/storage/large_holster/fuelpack/fuelpack

/obj/item/weapon/gun/flamer/M240T/Dispose()
	if(fuelpack)
		if(fuelpack.linked_flamer == src)
			fuelpack.linked_flamer = null
		fuelpack = null
	. = ..()

/obj/item/weapon/gun/flamer/M240T/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if(!link_fuelpack(user))
		to_chat(user, "You must equip the specialized Broiler-T back harness to use this incinerator unit!")
		click_empty(user)
		return
	// Check we're actually firing the right fuel tank
	if(current_mag != fuelpack.active_fuel)
		current_mag = fuelpack.active_fuel
	..()


/obj/item/weapon/gun/flamer/M240T/reload(mob/user, obj/item/ammo_magazine/magazine)
	to_chat(user, SPAN_WARNING("The Broiler-T feed system cannot be reloaded manually."))
	return

/obj/item/weapon/gun/flamer/M240T/unload(mob/user, reload_override = 0, drop_override = 0, loc_override = 0)
	to_chat(user, SPAN_WARNING("The incinerator tank is locked in place. It cannot be removed."))
	return

/obj/item/weapon/gun/flamer/M240T/able_to_fire(mob/user)
	. = ..()
	if(.)
		if(!current_mag || !current_mag.current_rounds)
			return

		if(!skillcheck(user, SKILL_SPEC_WEAPONS,  SKILL_SPEC_TRAINED) && user.mind.cm_skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_PYRO)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return FALSE

		var/mob/living/carbon/human/H = user
		if(!istype(H))
			return FALSE
		if(!istype(H.back, /obj/item/storage/large_holster/fuelpack))
			click_empty(H)
			return FALSE

/obj/item/weapon/gun/flamer/M240T/proc/link_fuelpack(var/mob/user)
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
	icon_state = "red_2"
	layer = BELOW_OBJ_LAYER
	flags_pass = PASS_FLAGS_FLAME
	var/firelevel = 12 //Tracks how much "fire" there is. Basically the timer of how long the fire burns
	var/burnlevel = 10 //Tracks how HOT the fire is. This is basically the heat level of the fire and determines the temperature.
	var/flame_color = "red"
	var/flameshape = FLAMESHAPE_DEFAULT // diagonal square shape
	var/weapon_source
	var/weapon_source_mob

/obj/flamer_fire/New(turf/loc, var/source, var/source_mob, fire_lvl, burn_lvl, f_color, fire_spread_amount, new_flameshape)
	..()
	if(f_color)
		flame_color = f_color

	if(new_flameshape)
		flameshape = new_flameshape

	if(!flame_color)
		flame_color = "red"

	weapon_source = source
	weapon_source_mob = source_mob

	icon_state = "[flame_color]_2"
	if(fire_lvl)
		firelevel = fire_lvl
	if(burn_lvl)
		burnlevel = burn_lvl
	processing_objects.Add(src)

	var/burn_dam = rand(burnlevel*2, burnlevel*3)

	if(fire_spread_amount > 0)
		if(flameshape == FLAMESHAPE_DEFAULT || flameshape == FLAMESHAPE_IRREGULAR) // Irregular 'stutters' in shape
			var/turf/T
			var/turf/source_turf = get_turf(loc)
			for(var/dirn in cardinal)
				T = get_step(source_turf, dirn)
				if(istype(T, /turf/open/space))
					continue
				var/obj/flamer_fire/foundflame = locate() in T
				if(foundflame)
					foundflame.flame_color = f_color
					foundflame.burnlevel = burn_lvl
					foundflame.firelevel = fire_lvl
					continue
				var/new_spread_amt = fire_spread_amount - 1
				if(T.density)
					T.flamer_fire_act(burn_dam)
					new_spread_amt = 0
				else
					var/atom/A = LinkBlocked(src, source_turf, T)

					if(A)
						A.flamer_fire_act(burn_dam)
						if (A.flags_atom & ON_BORDER)
							break
						new_spread_amt = 0

				if(flameshape == FLAMESHAPE_IRREGULAR && prob(33))
					continue
				spawn(0)
					new /obj/flamer_fire(T, weapon_source, weapon_source_mob, fire_lvl, burn_lvl, f_color, new_spread_amt, flameshape)

		if(flameshape == FLAMESHAPE_STAR || flameshape == FLAMESHAPE_MINORSTAR) // spread in a star-like pattern
			fire_spread_amount = round(fire_spread_amount * 1.5) // branch 'length'
			var/list/dirs = alldirs
			var/turf/source_turf = get_turf(loc)

			if(flameshape == FLAMESHAPE_MINORSTAR)
				if(prob(50))
					dirs = cardinal
				else
					dirs = diagonals

			for(var/dirn in dirs)
				var/endturf = get_ranged_target_turf(src, dirn, fire_spread_amount)
				var/list/turfs = getline2(src, endturf)
				var/new_spread_amt = 0

				for(var/turf/T in turfs)
					if(istype(T,/turf/open/space)) continue
					var/obj/flamer_fire/foundflame = locate() in T
					if(foundflame)
						foundflame.flame_color = f_color
						foundflame.burnlevel = burn_lvl
						foundflame.firelevel = fire_lvl
						continue

					if(prob(15) && flameshape != FLAMESHAPE_MINORSTAR) // chance to branch a little
						new_spread_amt = 1.5

					if(T.density && !T.throwpass) // unpassable turfs stop the spread
						T.flamer_fire_act(burn_dam)
						new_spread_amt = 0

					var/atom/A = LinkBlocked(src, source_turf, T)
					if(A)
						A.flamer_fire_act()
						if (A.flags_atom & ON_BORDER)
							break
						new_spread_amt = 0

					spawn(0)
						new /obj/flamer_fire(T, weapon_source, weapon_source_mob, fire_lvl, burn_lvl, f_color, new_spread_amt, FLAMESHAPE_MINORSTAR)
					new_spread_amt = 0

	//Apply fire effects onto everyone in the fire

	// Melt a single layer of snow
	if (istype(loc, /turf/open/snow))
		var/turf/open/snow/S = loc

		if (S.slayer > 0)
			S.slayer -= 1
			S.update_icon(1, 0)

	for(var/mob/living/M in loc) //Deal bonus damage if someone's caught directly in initial stream
		if(M.stat == DEAD)
			continue

		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(X.caste.fire_immune)
				continue
			if(X.burrow)
				continue
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M //fixed :s

			if(weapon_source_mob)
				var/mob/user = weapon_source_mob
				if(user.mind && H.mind && user.mind.faction == H.mind.faction)
					H.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[H]/[H.ckey]</b> with \a <b>[name]</b> in [get_area(user)]."
					user.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[H]/[H.ckey]</b> with \a <b>[name]</b> in [get_area(user)]."
					if(weapon_source)
						H.track_friendly_fire(weapon_source)
					msg_admin_ff("[user] ([user.ckey]) shot [H] ([H.ckey]) with \a [name] in [get_area(user)] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>) (<a href='?priv_msg=\ref[user.client]'>PM</a>)")
				else
					H.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[H]/[H.ckey]</b> with \a <b>[name]</b> in [get_area(user)]."
					user.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[H]/[H.ckey]</b> with \a <b>[name]</b> in [get_area(user)]."
					msg_admin_attack("[user] ([user.ckey]) shot [H] ([H.ckey]) with \a [name] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
				if(weapon_source)
					H.track_shot_hit(weapon_source, H)
			if(istype(H.wear_suit, /obj/item/clothing/suit/fire)) continue
		if(weapon_source)
			M.last_damage_source = weapon_source
		else
			M.last_damage_source = initial(name)
		M.last_damage_mob = weapon_source_mob
		M.adjust_fire_stacks(rand(5,burn_lvl*2))
		M.IgniteMob()
		M.adjustFireLoss(rand(burn_lvl,(burn_lvl*2))) // Make it so its the amount of heat or twice it for the initial blast.
		if(weapon_source_mob)
			var/mob/SM = weapon_source_mob
			SM.track_shot_hit(weapon_source)
		var/msg = "Augh! You are roasted by the flames!"
		if (isXeno(M))
			to_chat(M, SPAN_XENODANGER(msg))
		else
			to_chat(M, SPAN_HIGHDANGER(msg))


/obj/flamer_fire/Dispose()
	SetLuminosity(0)
	processing_objects.Remove(src)
	. = ..()


/obj/flamer_fire/Crossed(mob/living/M) //Only way to get it to reliable do it when you walk into it.
	if(istype(M))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(isXeno(H.pulledby))
				var/mob/living/carbon/Xenomorph/Z = H.pulledby
				if(!Z.caste.fire_immune)
					Z.adjust_fire_stacks(burnlevel)
					Z.IgniteMob()
			if(istype(H.wear_suit, /obj/item/clothing/suit/storage/marine/M35) || istype(H.wear_suit, /obj/item/clothing/suit/fire))
				H.show_message(text("Your suit protects you from the flames."),1)
				H.adjustFireLoss(burnlevel*0.25) //Does small burn damage to a person wearing one of the suits.
				return
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(X.caste.fire_immune)
				return
			if(X.burrow)
				return
		M.adjust_fire_stacks(burnlevel) //Make it possible to light them on fire later.
		if (prob(firelevel + 2*M.fire_stacks)) //the more soaked in fire you are, the likelier to be ignited
			M.IgniteMob()

		if(weapon_source)
			M.last_damage_source = weapon_source
		else
			M.last_damage_source = initial(name)
		M.last_damage_mob = weapon_source_mob
		M.adjustFireLoss(round(burnlevel*0.5)) //This makes fire stronk.
		to_chat(M, SPAN_DANGER("You are burned!"))
		if(isXeno(M)) M.updatehealth()


/obj/flamer_fire/proc/updateicon()
	if(burnlevel < 15)
		color = "#c1c1c1" //make it darker to make show its weaker.
	switch(firelevel)
		if(1 to 9)
			icon_state = "[flame_color]_1"
			SetLuminosity(2)
		if(10 to 25)
			icon_state = "[flame_color]_2"
			SetLuminosity(4)
		if(25 to INFINITY) //Change the icons and luminosity based on the fire's intensity
			icon_state = "[flame_color]_3"
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
			if(ishuman(I))
				var/mob/living/carbon/human/M = I
				if(istype(M.wear_suit, /obj/item/clothing/suit/storage/marine/M35) || istype(M.wear_suit, /obj/item/clothing/suit/fire))
					M.show_message(text("Your suit protects you from the flames."),1)
					M.adjustFireLoss(rand(0 ,burnlevel*0.25)) //Does small burn damage to a person wearing one of the suits.
					continue
			if(isXenoQueen(I))
				var/mob/living/carbon/Xenomorph/Queen/X = I
				X.show_message(text("Your extra-thick exoskeleton protects you from the flames."),1)
				continue
			if(isXenoBurrower(I))
				var/mob/living/carbon/Xenomorph/Burrower/B = I
				if(B.burrow)
					continue
			if(isXenoRavager(I))
				if(!I.stat)
					var/mob/living/carbon/Xenomorph/Ravager/X = I
					X.plasma_stored = X.plasma_max
					X.used_charge = 0 //Reset charge cooldown
					X.show_message(text(SPAN_DANGER("The heat of the fire roars in your veins! KILL! CHARGE! DESTROY!")),1)
					if(rand(1,100) < 70) X.emote("roar")
				continue
			I.adjust_fire_stacks(burnlevel) //If i stand in the fire i deserve all of this. Also Napalm stacks quickly.
			if(prob(firelevel)) I.IgniteMob()
			//I.adjustFireLoss(rand(10 ,burnlevel)) //Including the fire should be way stronger.
			I.show_message(text(SPAN_WARNING("You are burned!")),1)
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
		new/obj/flamer_fire(target, source, source_mob, fire_lvl, burn_lvl, f_color)

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
	new/obj/flamer_fire(target, source, source_mob, fire_lvl, burn_lvl, f_color)
	for(var/direction in alldirs)
		var/spread_power = range
		switch(direction)
			if(NORTH,SOUTH,EAST,WEST)
				spread_power -= 1
			else
				spread_power -= 1.414 //diagonal spreading
		var/turf/T = get_step(target, direction)
		fire_spread_recur(T, source, source_mob, spread_power, direction, fire_lvl, burn_lvl, f_color)