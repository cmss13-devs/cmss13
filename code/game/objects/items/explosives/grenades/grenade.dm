/obj/item/explosive/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
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
	max_container_size = 60
	var/det_time = 40
	var/dangerous = 0		//Make an danger overlay for humans?
	var/harmful = TRUE      //Is it harmful? Can synths use them?
	var/arm_sound = 'sound/weapons/armbomb.ogg'
	var/underslug_launchable = FALSE

/obj/item/explosive/grenade/Initialize()
	..()
	det_time = rand(det_time - 5, det_time + 5)

/obj/item/explosive/grenade/attack_self(mob/user)
	if(active)
		return
	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(harmful && isSynth(user))
		to_chat(user, SPAN_WARNING("Your programming prevents you from using this!"))
		return

	. = ..()

	if(grenade_grief_check(src))
		to_chat(user, SPAN_WARNING("\The [name]'s IFF inhibitor prevents you from priming the grenade!"))
		// Let staff know, in case someone's actually about to try to grief
		message_staff("[key_name(user)] attempted to prime \a [name] in [get_area(src)] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")
		return

	add_fingerprint(user)

	activate(user)
		
	source_mob = user

	user.visible_message(SPAN_WARNING("[user] primes \a [name]!"), \
	SPAN_WARNING("You prime \a [name]!"))
	msg_admin_attack("[user] ([user.ckey]) primed \a grenade ([name]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
	user.attack_log += text("\[[time_stamp()]\] <font color='red'> [user] primed \a grenade ([name]) at ([src.loc.x],[src.loc.y],[src.loc.z]) ([user.ckey])</font>")
	if(initial(dangerous) && has_species(user, "Human"))
		var/nade_sound = user.gender == FEMALE ? get_sfx("female_fragout") : get_sfx("male_fragout")
		playsound(user, nade_sound, 35)

			
	var/mob/living/carbon/C = user
	if(istype(C) && !C.throw_mode)
		C.toggle_throw_mode(THROW_MODE_NORMAL)


/obj/item/explosive/grenade/proc/activate(mob/user = null)
	if(active)
		return
	source_mob = user
	playsound(loc, arm_sound, 25, 1, 6)
	if(customizable)
		activate_sensors()
	else
		active = TRUE
		add_timer(CALLBACK(src, .proc/prime), det_time)
	update_icon()

/obj/item/explosive/grenade/update_icon()
	if(active && dangerous)
		overlays+=new/obj/effect/overlay/danger
		dangerous = 0
	. = ..()

/obj/item/explosive/grenade/launch_towards(var/atom/target, var/range, var/speed = 0, var/atom/thrower, var/spin, var/launch_type = NORMAL_LAUNCH, var/pass_flags = NO_FLAGS)
	if(active && ismob(thrower))
		var/mob/M = thrower
		M.count_niche_stat(STATISTICS_NICHE_GRENADES)
	. = ..()


/obj/item/explosive/grenade/attackby(obj/item/W as obj, mob/user as mob)
	if(isscrewdriver(W))
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
