/obj/item/device/radio/intercom
	name = "station intercom"
	desc = "Talk through this. To speak directly into an intercom next to you, use :i."
	icon_state = "intercom"
	anchored = 1
	w_class = SIZE_LARGE
	canhear_range = 2
	flags_atom = FPRINT|CONDUCT|NOBLOODY
	var/number = 0
	var/anyai = 1
	var/list/mob/living/silicon/ai/ai
	var/last_tick //used to delay the powercheck
	volume = RADIO_VOLUME_RAISED

	appearance_flags = TILE_BOUND

/obj/item/device/radio/intercom/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/device/radio/intercom/Destroy()
	STOP_PROCESSING(SSobj, src)
	ai = null
	. = ..()

/obj/item/device/radio/intercom/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/item/device/radio/intercom/attack_remote(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if (!(src.wires & WIRE_RECEIVE))
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(QDELETED(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range


/obj/item/device/radio/intercom/hear_talk(mob/M as mob, msg)
	if(!src.anyai && !(M in src.ai))
		return
	..()

/obj/item/device/radio/intercom/process()
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday

		if(!src.loc)
			on = FALSE
		else
			var/area/A = src.loc.loc
			if(!A || !isarea(A) || !A.master)
				on = FALSE
			else
				on = A.master.powered(POWER_CHANNEL_EQUIP) // set "on" to the power status

		if(!on)
			icon_state = "intercom-p"
		else
			icon_state = "intercom"
