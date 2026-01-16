//regular vehicle seats for general vehicles.
/obj/structure/bed/chair/comfy/vehicle
	name = "seat"

	unacidable = TRUE
	unslashable = TRUE
	explo_proof = TRUE
	can_rotate = FALSE

	//you want these chairs to not be easily obscured by objects
	layer = BELOW_MOB_LAYER

	// The vehicle this seat is tied to
	var/obj/vehicle/multitile/vehicle = null

	// Which seat this is in the vehicle
	var/seat = null

	// Which vehicle skill level required to use this
	var/required_skill = SKILL_VEHICLE_SMALL

/obj/structure/bed/chair/comfy/vehicle/ex_act()
	return

/obj/structure/bed/chair/comfy/vehicle/handle_rotation()
	if(dir == NORTH)
		layer = FLY_LAYER
	else
		layer = BELOW_MOB_LAYER
	if(buckled_mob)
		buckled_mob.setDir(dir)

/obj/structure/bed/chair/comfy/vehicle/afterbuckle(mob/M)
	..()
	handle_afterbuckle(M)

/obj/structure/bed/chair/comfy/vehicle/proc/handle_afterbuckle(mob/M)

	if(!vehicle)
		return

	if(QDELETED(buckled_mob))
		M.unset_interaction()
		vehicle.set_seated_mob(seat, null)
		if(M.client)
			M.client.change_view(GLOB.world_view_size, vehicle)
			M.client.pixel_x = 0
			M.client.pixel_y = 0
			M.reset_view()
	else
		if(M.stat == DEAD)
			unbuckle()
			return
		vehicle.set_seated_mob(seat, M)
		if(M && M.client)
			M.client.change_view(8, vehicle)

/obj/structure/bed/chair/comfy/vehicle/clicked(mob/user, list/mods) // If you're buckled, you can shift-click on the seat in order to return to camera-view
	if(user == buckled_mob && mods[SHIFT_CLICK] && !user.is_mob_incapacitated())
		user.client.change_view(8, vehicle)
		vehicle.set_seated_mob(seat, user)
		return TRUE
	else
		. = ..()

// Pass movement relays to the vehicle
/obj/structure/bed/chair/comfy/vehicle/relaymove(mob/user, direction)
	vehicle.relaymove(user, direction)

// Driver's seat
/obj/structure/bed/chair/comfy/vehicle/driver
	name = "driver's seat"
	desc = "Comfortable seat for a driver."
	seat = VEHICLE_DRIVER
	var/skill_to_check = SKILL_VEHICLE

/obj/structure/bed/chair/comfy/vehicle/driver/do_buckle(mob/target, mob/user)
	required_skill = vehicle.required_skill
	if(!skillcheck(target, skill_to_check, required_skill))
		if(target == user)
			to_chat(user, SPAN_WARNING("You have no idea how to drive this thing!"))
		return FALSE

	if(vehicle)
		vehicle.vehicle_faction = target.faction

	return ..()

// Gunner seat
/obj/structure/bed/chair/comfy/vehicle/gunner
	name = "gunner's seat"
	desc = "Comfortable seat for a gunner."
	seat = VEHICLE_GUNNER
	required_skill = SKILL_VEHICLE_CREWMAN

/obj/structure/bed/chair/comfy/vehicle/gunner/do_buckle(mob/target, mob/user)
	// Gunning always requires crewman-level skill
	if(!skillcheck(target, SKILL_VEHICLE, required_skill))
		if(target == user)
			to_chat(user, SPAN_WARNING("You have no idea how to operate the weapons on this thing!"))
		return FALSE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.allow_gun_usage)
			if(issynth(user))
				to_chat(user, SPAN_WARNING("Your programming does not allow you to use heavy weaponry."))
			else
				to_chat(user, SPAN_WARNING("You are unable to use heavy weaponry."))
			return
		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/ceasefire))
			to_chat(user, SPAN_WARNING("You will not break the ceasefire by doing that!"))
			return FALSE

	for(var/obj/item/I in user.contents)		//prevents shooting while zoomed in, but zoom can still be activated and used without shooting
		if(I.zoom)
			I.zoom(user)

	if(vehicle)
		vehicle.vehicle_faction = target.faction

	return ..()

/obj/structure/bed/chair/comfy/vehicle/attackby(obj/item/W, mob/living/user)
	return

/obj/structure/bed/chair/comfy/vehicle/attack_alien(mob/living/carbon/xenomorph/X, dam_bonus)

	if(X.is_mob_incapacitated() || !Adjacent(X))
		return

	if(buckled_mob)
		manual_unbuckle(X)
		return

//custom vehicle seats for armored vehicles
//spawners located in interior_landmarks

/obj/structure/bed/chair/comfy/vehicle/driver/armor
	desc = "Military-grade seat for armored vehicle driver with some controls, switches and indicators."
	var/image/over_image = null

/obj/structure/bed/chair/comfy/vehicle/driver/armor/Initialize(mapload)
	over_image = image(icon, "armor_chair_buckled")
	over_image.layer = ABOVE_MOB_LAYER

	return ..()

/obj/structure/bed/chair/comfy/vehicle/driver/armor/do_buckle(mob/target, mob/user)
	. = ..()
	update_icon()

/obj/structure/bed/chair/comfy/vehicle/driver/armor/update_icon()
	overlays.Cut()

	..()

	if(buckled_mob)
		overlays += over_image

/obj/structure/bed/chair/comfy/vehicle/gunner/armor
	desc = "Military-grade seat for armored vehicle gunner with some controls, switches and indicators."
	var/image/over_image = null

/obj/structure/bed/chair/comfy/vehicle/gunner/armor/Initialize(mapload)
	over_image = image(icon, "armor_chair_buckled")
	over_image.layer = ABOVE_MOB_LAYER

	return ..()

/obj/structure/bed/chair/comfy/vehicle/gunner/armor/do_buckle(mob/target, mob/user)
	. = ..()
	update_icon()

/obj/structure/bed/chair/comfy/vehicle/gunner/armor/handle_afterbuckle(mob/M)

	if(!vehicle)
		return

	if(QDELETED(buckled_mob))
		M.unset_interaction()
		vehicle.set_seated_mob(seat, null)
		if(M.client)
			M.client.change_view(GLOB.world_view_size, vehicle)
			M.client.pixel_x = 0
			M.client.pixel_y = 0
	else
		if(M.stat != CONSCIOUS)
			unbuckle()
			return
		vehicle.set_seated_mob(seat, M)
		if(M && M.client)
			if(istype(vehicle, /obj/vehicle/multitile/apc))
				var/obj/vehicle/multitile/apc/APC = vehicle
				M.client.change_view(APC.gunner_view_buff, vehicle)
			else
				M.client.change_view(8, vehicle)

/obj/structure/bed/chair/comfy/vehicle/gunner/armor/update_icon()
	overlays.Cut()

	..()

	if(buckled_mob)
		overlays += over_image

//armored vehicles support gunner seat

/obj/structure/bed/chair/comfy/vehicle/support_gunner
	name = "left support gunner's seat"
	desc = "Military-grade seat for a support gunner with some controls, switches and indicators."
	seat = VEHICLE_SUPPORT_GUNNER_ONE

	required_skill = SKILL_VEHICLE_DEFAULT

	var/image/over_image = null

/obj/structure/bed/chair/comfy/vehicle/support_gunner/Destroy()
	var/obj/structure/prop/vehicle/firing_port_weapon/FPW = locate() in get_turf(src)
	if(FPW)
		FPW.SG_seat = null
	. = ..()

/obj/structure/bed/chair/comfy/vehicle/support_gunner/Initialize(mapload)
	over_image = image(icon, "armor_chair_buckled")
	over_image.layer = ABOVE_MOB_LAYER

	return ..()


/obj/structure/bed/chair/comfy/vehicle/support_gunner/do_buckle(mob/target, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.allow_gun_usage)
			if(issynth(user))
				to_chat(user, SPAN_WARNING("Your programming does not allow you to use firearms."))
			else
				to_chat(user, SPAN_WARNING("You are unable to use firearms."))
			return
		if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/ceasefire))
			to_chat(user, SPAN_WARNING("You will not break the ceasefire by doing that!"))
			return FALSE
	. = ..()

	update_icon()

/obj/structure/bed/chair/comfy/vehicle/support_gunner/update_icon()
	overlays.Cut()

	..()

	if(buckled_mob)
		overlays += over_image

/obj/structure/bed/chair/comfy/vehicle/support_gunner/handle_afterbuckle(mob/M)

	if(!vehicle)
		return

	if(QDELETED(buckled_mob))
		M.unset_interaction()
		vehicle.set_seated_mob(seat, null)
		if(M.client)
			M.client.change_view(GLOB.world_view_size, vehicle)
			M.client.pixel_x = 0
			M.client.pixel_y = 0
			M.reset_view()
	else
		if(M.stat == DEAD)
			unbuckle()
			return
		vehicle.set_seated_mob(seat, M)
		if(M && M.client)
			M.client.change_view(8, vehicle)

		if(vehicle.health < initial(vehicle.health) / 2)
			to_chat(M, SPAN_WARNING("\The [vehicle] is too damaged to operate the Firing Port Weapon!"))
			return

		for(var/obj/item/hardpoint/special/firing_port_weapon/FPW in vehicle.hardpoints)
			if(FPW.allowed_seat == seat)
				vehicle.active_hp[seat] = FPW
				var/msg = SPAN_NOTICE("You take the control of the M56 Firing Port Weapon.")
				if(FPW.reloading)
					msg += SPAN_WARNING("The M56 FPW is currently reloading. Wait [SPAN_HELPFUL((FPW.reload_time_started + FPW.reload_time - world.time) / 10)] seconds.")
				else if(FPW.ammo)
					msg += SPAN_NOTICE("Ammo: <b>[SPAN_HELPFUL(FPW.ammo.current_rounds)]/[SPAN_HELPFUL(FPW.ammo.max_rounds)]</b>")
				else
					msg += SPAN_DANGER("<b>ERROR. AMMO NOT FOUND, TELL A DEV!</b>")
				msg = SPAN_INFO("Use 'Reload Firing Port Weapon' verb in 'Vehicle' tab to activate automated reload.")
				to_chat(M, msg)
				return
		to_chat(M, SPAN_WARNING("ERROR. NO FPW FOUND, TELL A DEV!"))

/obj/structure/bed/chair/comfy/vehicle/support_gunner/second
	name = "right support gunner's seat"
	seat = VEHICLE_SUPPORT_GUNNER_TWO

//ARMORED VEHICLES PASSENGER SEATS
//Unique feature - you can put two seats on same tile with different pixel_offsets, humans will be buckled with respective offsets
//and only when both seats taken, seats will be made dense and, therefore, tile will become unpassible

//DOES NOT SUPPORT MORE THAN TWO SEATS ON TILE
/obj/structure/bed/chair/vehicle
	name = "passenger seat"
	desc = "A sturdy chair with a brace that lowers over your body. Prevents being flung around in vehicle during crash being injured as a result. Fasten your seatbelts, kids! Fix with welding tool in case of damage."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "vehicle_seat"
	var/image/chairbar = null
	var/broken = FALSE
	buildstackamount = 0
	can_rotate = FALSE
	picked_up_item = null

	unslashable = FALSE
	unacidable = TRUE

	var/buckle_offset_x = 0
	var/mob_old_x = 0
	var/buckle_offset_y = 0
	var/mob_old_y = 0

/obj/structure/bed/chair/vehicle/Initialize()
	. = ..()
	chairbar = image(icon, "vehicle_bars")
	chairbar.layer = ABOVE_MOB_LAYER

	addtimer(CALLBACK(src, PROC_REF(setup_buckle_offsets)), 1 SECONDS)

	handle_rotation()

/obj/structure/bed/chair/vehicle/proc/setup_buckle_offsets()
	if(pixel_x != 0)
		buckle_offset_x = pixel_x
	if(pixel_y != 0)
		buckle_offset_y = pixel_y

/obj/structure/bed/chair/vehicle/handle_rotation()
	if(dir == NORTH)
		layer = FLY_LAYER
	else
		layer = BELOW_MOB_LAYER
	if(buckled_mob)
		buckled_mob.setDir(dir)

//------BUCKLING AND UNBUCKLING
//trying to buckle a mob
/obj/structure/bed/chair/vehicle/buckle_mob(mob/M, mob/user)

	if(broken)
		to_chat(user, SPAN_WARNING("\The [name] is broken and requires fixing with a welder!"))
		return

	. = ..()

/obj/structure/bed/chair/vehicle/afterbuckle(mob/M)
	if(buckled_mob)
		if(buckled_mob != M)
			return
		icon_state = initial(icon_state) + "_buckled"
		overlays += chairbar

		if(buckle_offset_x != 0)
			mob_old_x = M.pixel_x
			M.pixel_x = buckle_offset_x
		if(buckle_offset_y != 0)
			mob_old_y = M.pixel_y
			M.pixel_y = buckle_offset_y
	else
		icon_state = initial(icon_state)
		overlays -= chairbar

		if(buckle_offset_x != 0)
			M.pixel_x = mob_old_x
			mob_old_x = 0
		if(buckle_offset_y != 0)
			M.pixel_y = mob_old_y
			mob_old_y = 0

	for(var/obj/structure/bed/chair/vehicle/VS in get_turf(src))
		if(VS != src)
			//if both seats on same tile have buckled mob, we become dense, otherwise, not dense.
			if(buckled_mob)
				if(VS.buckled_mob)
					REMOVE_TRAIT(buckled_mob, TRAIT_UNDENSE, DOUBLE_SEATS_TRAIT)
					REMOVE_TRAIT(VS.buckled_mob, TRAIT_UNDENSE, DOUBLE_SEATS_TRAIT)
				else
					ADD_TRAIT(buckled_mob, TRAIT_UNDENSE, DOUBLE_SEATS_TRAIT)
			else
				if(VS.buckled_mob)
					ADD_TRAIT(VS.buckled_mob, TRAIT_UNDENSE, DOUBLE_SEATS_TRAIT)
				REMOVE_TRAIT(M, TRAIT_UNDENSE, DOUBLE_SEATS_TRAIT)
			break

	handle_rotation()

//attack handling

/obj/structure/bed/chair/vehicle/attack_alien(mob/living/user)
	if(!unslashable)
		user.visible_message(SPAN_WARNING("[user] smashes \the [src]!"),
		SPAN_WARNING("You smash \the [src]!"))
		playsound(loc, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)
		if(!broken)
			break_seat()
		else
			deconstruct(FALSE)


/obj/structure/bed/chair/vehicle/attackby(obj/item/W, mob/living/user)
	if((iswelder(W) && broken))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/C = W
		if(C.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/weldingtool_weld.ogg', 25)
			user.visible_message(SPAN_WARNING("[user] begins repairing \the [src]."),
			SPAN_WARNING("You begin repairing \the [src]."))
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && broken)
				user.visible_message(SPAN_WARNING("[user] repairs \the [src]."),
				SPAN_WARNING("You repair \the [src]."))
				repair_seat()
				return

//breaking and repairing seats
/obj/structure/bed/chair/vehicle/proc/break_seat()
	broken = TRUE
	if(buckled_mob)
		unbuckle()
	icon_state = "vehicle_seat_destroyed"

/obj/structure/bed/chair/vehicle/proc/repair_seat()
	broken = FALSE
	icon_state = "vehicle_seat"

//MISC

/obj/structure/bed/chair/vehicle/ex_act(severity)
	if(broken || explo_proof)
		return
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(20))
				break_seat()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(60))
				break_seat()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			break_seat()

// White chairs

/obj/structure/bed/chair/vehicle/white
	name = "passenger seat"
	desc = "A sturdy chair with a brace that lowers over your body. Prevents being flung around in vehicle during crash being injured as a result. Fasten your seatbelts, kids! Fix with welding tool in case of damage."
	icon = 'icons/obj/vehicles/interiors/general_wy.dmi'
