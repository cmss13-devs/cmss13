/obj/structure/machinery/door/poddoor/shutters
	name = "\improper Shutters"
	icon = 'icons/obj/structures/doors/rapid_pdoor.dmi'
	icon_state = "shutter1"
	base_icon_state = "shutter"
	power_channel = POWER_CHANNEL_ENVIRON

/obj/structure/machinery/door/poddoor/shutters/opened
	density = FALSE

/obj/structure/machinery/door/poddoor/shutters/update_icon()
	if(density)
		icon_state = "[base_icon_state]1"
	else
		icon_state = "[base_icon_state]0"
	return

/obj/structure/machinery/door/poddoor/shutters/attackby(obj/item/C as obj, mob/user as mob)
	add_fingerprint(user)
	if(!C.pry_capable)
		return
	if(density && (stat & NOPOWER) && !operating && !unacidable)
		operating = DOOR_OPERATING_OPENING
		spawn(-1)
			flick("[base_icon_state]c0", src)
			icon_state = "[base_icon_state]0"
			sleep(15)
			density = FALSE
			set_opacity(0)
			operating = DOOR_OPERATING_IDLE
			return
	return

/obj/structure/machinery/door/poddoor/shutters/open(forced = FALSE)
	if(operating) //doors can still open when emag-disabled
		return FALSE

	operating = DOOR_OPERATING_OPENING
	flick("[base_icon_state]c0", src)
	icon_state = "[base_icon_state]0"
	playsound(loc, 'sound/machines/blastdoor.ogg', 25)

	addtimer(CALLBACK(src, PROC_REF(finish_open)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/poddoor/shutters/finish_open()
	if(operating != DOOR_OPERATING_OPENING)
		return
	if(QDELETED(src))
		return // Specifically checked because of the possiible addtimer

	density = FALSE
	layer = open_layer
	set_opacity(0)

	operating = DOOR_OPERATING_IDLE
	if(autoclose)
		addtimer(CALLBACK(src, PROC_REF(autoclose)), 15 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/obj/structure/machinery/door/poddoor/shutters/close(forced = FALSE)
	if(operating)
		return FALSE

	operating = DOOR_OPERATING_CLOSING
	flick("[base_icon_state]c1", src)
	icon_state = "[base_icon_state]1"
	layer = closed_layer
	density = TRUE
	if(visible)
		set_opacity(1)
	playsound(loc, 'sound/machines/blastdoor.ogg', 25)

	addtimer(CALLBACK(src, PROC_REF(finish_close)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/poddoor/shutters/finish_close()
	if(operating != DOOR_OPERATING_CLOSING)
		return

	operating = DOOR_OPERATING_IDLE

/obj/structure/machinery/door/poddoor/shutters/almayer
	icon = 'icons/obj/structures/doors/blastdoors_shutters.dmi'
	openspeed = 4 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/poddoor/shutters/almayer/open
	density = FALSE

/obj/structure/machinery/door/poddoor/shutters/almayer/Initialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/poddoor/yautja
	name = "Yautja Shutter"
	desc = "A heavily reinforced metal-alloy door, designed to be virtually indestructible—nothing can penetrate its defenses."
	icon = 'icons/obj/structures/doors/hybrisashutters.dmi'
	icon_state = "udoor1"
	base_icon_state = "udoor"
	unslashable = TRUE
	emp_proof = TRUE
	openspeed = 6
	color = "#f0ebd3"

/obj/structure/machinery/door/poddoor/yautja/open
	density = FALSE

/obj/structure/machinery/door/poddoor/yautja/emp_act(power, severity)
	if(emp_proof)
		return FALSE
	..()
	return TRUE

/obj/structure/machinery/door/poddoor/yautja/hunting_grounds
	name = "Preserve Shutter"
	id = "Yautja Preserve"
	needs_power = FALSE
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE
	explo_proof = TRUE

/obj/structure/machinery/door/poddoor/yautja/hunting_grounds/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_YAUTJA_PRESERVE_OPENED, PROC_REF(open))
	RegisterSignal(SSdcs, COMSIG_GLOB_YAUTJA_PRESERVE_CLOSED, PROC_REF(close))

/obj/structure/machinery/door/poddoor/yautja/armory
	name = "Armory Shutter"

/obj/structure/machinery/door/poddoor/yautja/armory/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_YAUTJA_ARMORY_OPENED, PROC_REF(open))

/obj/structure/machinery/door/poddoor/shutters/almayer/containment
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/attack_alien(mob/living/carbon/xenomorph/M)
	if(isqueen(M) && density && !operating)
		INVOKE_ASYNC(src, PROC_REF(pry_open), M)
		return XENO_ATTACK_ACTION
	else
		. = ..(M)

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/pry_open(mob/living/carbon/xenomorph/X, time = 4 SECONDS)
	. = ..()
	if(. && !(stat & BROKEN))
		stat |= BROKEN
		addtimer(CALLBACK(src, PROC_REF(unbreak_doors)), 10 SECONDS)

/obj/structure/machinery/door/poddoor/shutters/almayer/containment/proc/unbreak_doors()
	stat &= ~BROKEN

//transit shutters used by marine dropships
/obj/structure/machinery/door/poddoor/shutters/transit
	name = "Transit shutters"
	desc = "Safety shutters to prevent dangerous depressurization during flight"
	icon = 'icons/obj/structures/doors/blastdoors_shutters.dmi'
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/shutters/transit/ex_act(severity) //immune to explosions
	return

/obj/structure/machinery/door/poddoor/shutters/transit/open
	density = FALSE

/obj/structure/machinery/door/poddoor/shutters/almayer/pressure
	name = "pressure shutters"
	density = FALSE
	opacity = FALSE
	unacidable = TRUE
	icon_state = "shutter0"
	open_layer = PODDOOR_CLOSED_LAYER
	closed_layer = PODDOOR_CLOSED_LAYER

/obj/structure/machinery/door/poddoor/shutters/almayer/pressure/ex_act(severity)
	return

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors
	name = "\improper Uniform Vendor Shutters"
	id = "bot_uniforms"
	unacidable = TRUE
	unslashable = TRUE

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors/ex_act(severity)
	return

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors/emp_act(severity)
	. = ..()
	return

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors/attackby(obj/item/attacking_item, mob/user)
	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR) || attacking_item.pry_capable)
		return
	. = ..()

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors/antitheft
	name = "Anti-Theft Shutters"
	desc = "Secure Storage shutters, they're reinforced against entry attempts."
	var/req_level = SEC_LEVEL_RED

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors/antitheft/Initialize()
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_SECURITY_LEVEL_CHANGED, PROC_REF(sec_changed))

/obj/structure/machinery/door/poddoor/shutters/almayer/uniform_vendors/antitheft/proc/sec_changed(datum/source, new_sec)
	SIGNAL_HANDLER
	if(new_sec < req_level)
		if(density)
			return
		close()
	else
		if(!density)
			return
		open()

//make a subtype for CL office so it as a proper name.
/obj/structure/machinery/door/poddoor/shutters/almayer/cl
		name = "\improper Corporate Liaison Privacy Shutters"
//adding a subtype for CL office to use to secure access to cl office.
/obj/structure/machinery/door/poddoor/shutters/almayer/cl/office
/obj/structure/machinery/door/poddoor/shutters/almayer/cl/office/door
	id = "cl_office_door"
/obj/structure/machinery/door/poddoor/shutters/almayer/cl/office/window
	id = "cl_office_windows"
//adding a subtype for CL quarter to use to secure access to cl quarter.(including seperation with the office)
/obj/structure/machinery/door/poddoor/shutters/almayer/cl/quarter
/obj/structure/machinery/door/poddoor/shutters/almayer/cl/quarter/backdoor
	id = "cl_quarter_maintenance"
	dir = 4
/obj/structure/machinery/door/poddoor/shutters/almayer/cl/quarter/door
	id = "cl_quarter_door"
	dir = 4
/obj/structure/machinery/door/poddoor/shutters/almayer/cl/quarter/window
	id = "cl_quarter_windows"
