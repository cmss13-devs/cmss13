/obj/item/explosive/grenade
	name = "grenade"
	desc = "A hand-held grenade, with an adjustable timer."
	w_class = SIZE_SMALL
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = SPEED_VERY_FAST
	throw_range = 7
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	hitsound = 'sound/weapons/smash.ogg'
	allowed_sensors = list(/obj/item/device/assembly/timer)
	max_container_volume = 60
	var/det_time = 40
	var/dangerous = FALSE //Make an danger overlay for humans?
	var/arm_sound = 'sound/weapons/armbomb.ogg'
	var/has_arm_sound = TRUE
	var/underslug_launchable = FALSE
	var/hand_throwable = TRUE
	harmful = TRUE //Is it harmful? Are they banned for synths?
	antigrief_protection = TRUE //Should it be checked by antigrief?
	ground_offset_x = 7
	ground_offset_y = 6

/obj/item/explosive/grenade/Initialize()
	. = ..()
	det_time = max(0, rand(det_time - 5, det_time + 5))

/obj/item/explosive/grenade/proc/can_use_grenade(mob/living/carbon/human/user)
	if(!hand_throwable)
		to_chat(user, SPAN_WARNING("This isn't a hand grenade!"))
		return FALSE

	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return FALSE

	if(harmful && ishuman(user) && !user.allow_gun_usage)
		to_chat(user, SPAN_WARNING("Your programming prevents you from using this!"))
		return FALSE

	return TRUE

/obj/item/explosive/grenade/dropped(mob/user)
	. = ..()
	if(iscarbon(user) && active)
		var/mob/living/carbon/nade_user = user
		nade_user.toggle_throw_mode(THROW_MODE_OFF)

/obj/item/explosive/grenade/attack_self(mob/user)
	if(active)
		return

	if(!can_use_grenade(user))
		return

	. = ..()

	if(!. || isnull(loc))
		return

	if(antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(src, user))
		to_chat(user, SPAN_WARNING("\The [name]'s safe-area accident inhibitor prevents you from priming the grenade!"))
		// Let staff know, in case someone's actually about to try to grief
		msg_admin_niche("[key_name(user)] attempted to prime \a [name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return

	if(SEND_SIGNAL(user, COMSIG_GRENADE_PRE_PRIME) & COMPONENT_GRENADE_PRIME_CANCEL)
		return

	add_fingerprint(user)

	activate(user)

	cause_data = create_cause_data(initial(name), user)

	user.visible_message(SPAN_WARNING("[user] primes \a [name]!"), \
	SPAN_WARNING("You prime \a [name]!"))
	msg_admin_attack("[key_name(user)] primed \a grenade ([name]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
	user.attack_log += text("\[[time_stamp()]\] <font color='red'> [key_name(user)] primed \a grenade ([name]) at ([src.loc.x],[src.loc.y],[src.loc.z])</font>")
	if(initial(dangerous))
		var/nade_sound
		if(has_species(user, "Human"))
			nade_sound = user.gender == FEMALE ? get_sfx("female_fragout") : get_sfx("male_fragout")
		else if(ismonkey(user))
			nade_sound = sound('sound/voice/monkey_scream.ogg')
		if(nade_sound)
			playsound(user, nade_sound, 35)

	var/mob/living/carbon/C = user
	if(istype(C) && !C.throw_mode)
		C.toggle_throw_mode(THROW_MODE_NORMAL)


/obj/item/explosive/grenade/proc/activate(mob/user = null, hand_throw = TRUE)
	if(active)
		return
	if(!hand_throwable && hand_throw)
		to_chat(user, SPAN_WARNING("This isn't a hand grenade!"))
		return
	cause_data = create_cause_data(initial(name), user)
	if(has_arm_sound)
		playsound(loc, arm_sound, 25, 1, 6)
	if(customizable)
		activate_sensors()
	else
		active = TRUE
		det_time ? addtimer(CALLBACK(src, PROC_REF(prime)), det_time) : prime()
	w_class = SIZE_MASSIVE // We cheat a little, primed nades become massive so they cant be stored anywhere
	update_icon()

/obj/item/explosive/grenade/prime(force = FALSE)
	..()
	if(!QDELETED(src))
		w_class = initial(w_class)

/obj/item/explosive/grenade/update_icon()
	if(active && dangerous)
		overlays+=new/obj/effect/overlay/danger
		dangerous = FALSE
	. = ..()

/obj/item/explosive/grenade/launch_towards(datum/launch_metadata/LM)
	if(active && ismob(LM.thrower))
		var/mob/M = LM.thrower
		M.count_niche_stat(STATISTICS_NICHE_GRENADES)
	. = ..()


/obj/item/explosive/grenade/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		switch(det_time)
			if ("1")
				det_time = 10
				to_chat(user, SPAN_NOTICE("You set the [name] for 1 second detonation time."))
			if ("10")
				det_time = 30
				to_chat(user, SPAN_NOTICE("You set the [name] for 3 second detonation time."))
			if ("30")
				det_time = 50
				to_chat(user, SPAN_NOTICE("You set the [name] for 5 second detonation time."))
			if ("50")
				det_time = 1
				to_chat(user, SPAN_NOTICE("You set the [name] for instant detonation."))
		add_fingerprint(user)
	..()
	return

/obj/item/explosive/grenade/attack_hand()
	walk(src, null, null)
	..()
	return
