/obj/item/device/radio/intercom
	name = "station intercom"
	desc = "Talk through this. To speak directly into an intercom next to you, use :i."
	icon_state = "intercom"
	anchored = TRUE
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
			if(!A || !isarea(A))
				on = FALSE
			else
				on = A.powered(POWER_CHANNEL_EQUIP) // set "on" to the power status

		if(!on)
			icon_state = "intercom-p"
		else
			icon_state = "intercom"

/obj/item/device/radio/intercom/alamo
	name = "dropship alamo intercom"
	frequency = DS1_FREQ

/obj/item/device/radio/intercom/normandy
	name = "dropship normandy intercom"
	frequency = DS2_FREQ

/obj/item/device/radio/intercom/saipan
	name = "dropship saipan intercom"
	frequency = DS3_FREQ

/obj/item/device/radio/intercom/morana
	name = "dropship morana intercom"
	frequency = UPP_DS1_FREQ

/obj/item/device/radio/intercom/devana
	name = "dropship devana intercom"
	frequency = UPP_DS2_FREQ

/obj/item/device/radio/intercom/fax
	name = "Monitoring Frequency Speaker"
	canhear_range = 4

/obj/item/device/radio/intercom/fax/wy
	frequency = FAX_WY_FREQ

/obj/item/device/radio/intercom/fax/uscm_hc
	frequency = FAX_USCM_HC_FREQ

/obj/item/device/radio/intercom/fax/uscm_pvst
	frequency = FAX_USCM_PVST_FREQ
