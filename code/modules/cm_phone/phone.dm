GLOBAL_LIST_EMPTY_TYPED(transmitters, /obj/structure/transmitter)

/obj/structure/transmitter
	name = "telephone receiver"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "wall_phone"

	var/phone_id = "Telephone"

	var/obj/item/phone/attached_to
	var/atom/tether_holder

	var/obj/structure/transmitter/calling
	var/obj/structure/transmitter/caller

	var/next_ring = 0

	var/phone_type = /obj/item/phone

	var/range = 7

	var/enabled = TRUE

/obj/structure/transmitter/update_icon()
	. = ..()
	if(attached_to.loc != src)
		icon_state = "wall_phone_ear"
	else
		icon_state = "wall_phone"

/obj/structure/transmitter/Initialize(mapload, ...)
	. = ..()
	attached_to = new phone_type(src)
	RegisterSignal(attached_to, COMSIG_PARENT_PREQDELETED, .proc/override_delete)
	update_icon()

	if(!get_turf(src))
		return

	GLOB.transmitters += src

/obj/structure/transmitter/proc/override_delete()
	SIGNAL_HANDLER
	recall_phone()
	return COMPONENT_ABORT_QDEL


#define TRANSMITTER_UNAVAILABLE(T) (\
	T.get_calling_phone() \
	|| !T.attached_to \
	|| T.attached_to.loc != T \
	|| !T.enabled\
)

/proc/get_transmitters()
	var/list/phone_list = list()

	for(var/obj/structure/transmitter/T in GLOB.transmitters)
		if(TRANSMITTER_UNAVAILABLE(T)) // Phone not available
			continue

		var/id = T.phone_id
		var/num_id = 1
		while(id in phone_list)
			id = "[T.phone_id] [num_id]"
			num_id++

		T.phone_id = id
		phone_list += list("[id]" = T)

	return phone_list

/obj/structure/transmitter/attack_hand(mob/user)
	. = ..()

	if(!attached_to || attached_to.loc != src)
		return

	if(!ishuman(user))
		return

	if(!enabled)
		return

	if(!get_calling_phone())
		var/list/transmitters = get_transmitters()
		transmitters -= phone_id

		if(!transmitters.len)
			to_chat(user, SPAN_PURPLE("[icon2html(src, user)] No transmitters could be located to call!"))
			return

		var/to_call = tgui_input_list(user, "Select a station to call", "Call list", transmitters)

		if(!to_call)
			return

		var/obj/structure/transmitter/T = transmitters[to_call]
		if(!istype(T) || QDELETED(T))
			transmitters -= T
			CRASH("Qdelled/improper atom inside transmitters list! (istype returned: [istype(T)], QDELETED returned: [QDELETED(T)])")

		if(TRANSMITTER_UNAVAILABLE(T))
			return

		calling = T
		T.caller = src

		to_chat(user, SPAN_PURPLE("[icon2html(src, user)] Dialing [to_call].."))
		playsound(get_turf(user), "rtb_handset")

		START_PROCESSING(SSobj, src)
		START_PROCESSING(SSobj, T)
	else
		var/obj/structure/transmitter/T = get_calling_phone()

		if(T.attached_to && ismob(T.attached_to.loc))
			var/mob/M = T.attached_to.loc
			to_chat(M, SPAN_PURPLE("[icon2html(src, M)] [phone_id] has picked up."))

		to_chat(user, SPAN_PURPLE("[icon2html(src, user)] Picked up a call from [T.phone_id]."))
		playsound(get_turf(user), "rtb_handset")

	var/mob/living/carbon/human/H = user

	H.put_in_active_hand(attached_to)

	update_icon()

#undef TRANSMITTER_UNAVAILABLE

/obj/structure/transmitter/proc/set_tether_holder(var/atom/A)
	tether_holder = A

	if(attached_to)
		attached_to.reset_tether()

/obj/structure/transmitter/proc/reset_call()
	var/obj/structure/transmitter/T = get_calling_phone()
	if(T)
		if(T.attached_to && ismob(T.attached_to.loc))
			var/mob/M = T.attached_to.loc
			to_chat(M, SPAN_PURPLE("[icon2html(src, M)] [phone_id] has hung up on you."))

		if(attached_to && ismob(attached_to.loc))
			var/mob/M = attached_to.loc
			to_chat(M, SPAN_PURPLE("[icon2html(src, M)] You have hung up on [T.phone_id]."))

	if(calling)
		STOP_PROCESSING(SSobj, src)
		calling.caller = null
		calling = null

	if(caller)
		STOP_PROCESSING(SSobj, src)
		caller.calling = null
		caller = null

	STOP_PROCESSING(SSobj, src)

/obj/structure/transmitter/process()
	if(caller)
		if(!attached_to)
			STOP_PROCESSING(SSobj, src)
			return

		if(attached_to.loc == src)
			if(next_ring < world.time)
				playsound(loc, 'sound/machines/telephone/telephone_ring.ogg', 75)
				next_ring = world.time + 3 SECONDS

	else if(calling)
		var/obj/structure/transmitter/T = get_calling_phone()
		if(!T)
			STOP_PROCESSING(SSobj, src)
			return

		var/obj/item/phone/P = T.attached_to

		if(P && attached_to.loc == src && P.loc == T && next_ring < world.time)
			playsound(get_turf(attached_to), 'sound/machines/telephone/telephone_ring.ogg', 20, FALSE, 14)
			next_ring = world.time + 3 SECONDS

	else
		STOP_PROCESSING(SSobj, src)
		return


/obj/structure/transmitter/proc/recall_phone()
	if(ismob(attached_to.loc))
		var/mob/M = attached_to.loc
		M.drop_held_item(attached_to)
		playsound(get_turf(M), "rtb_handset", 100, FALSE, 7)

	attached_to.forceMove(src)
	update_icon()

	reset_call()

/obj/structure/transmitter/proc/get_calling_phone()
	if(calling)
		return calling
	else if(caller)
		return caller

	return

/obj/structure/transmitter/proc/handle_speak(var/message, var/datum/language/L, var/mob/speaking)
	if(L.flags & SIGNLANG) return

	var/obj/structure/transmitter/T = get_calling_phone()
	if(!istype(T))
		return

	var/obj/item/phone/P = T.attached_to

	if(!P || !attached_to)
		return

	P.handle_hear(message, L, speaking)
	attached_to.handle_hear(message, L, speaking)

/obj/structure/transmitter/attackby(obj/item/W, mob/user)
	if(W == attached_to)
		recall_phone()
	else
		. = ..()

/obj/structure/transmitter/Destroy()
	if(attached_to)
		if(attached_to.loc == src)
			UnregisterSignal(attached_to, COMSIG_PARENT_PREQDELETED)
			qdel(attached_to)
		else
			attached_to.attached_to = null
			attached_to = null

	GLOB.transmitters -= src

	reset_call()
	return ..()

/obj/item/phone
	name = "telephone"
	icon = 'icons/obj/items/misc.dmi'
	icon_state = "rpb_phone"

	w_class = SIZE_LARGE

	var/obj/structure/transmitter/attached_to
	var/datum/effects/tethering/tether_effect

	var/raised = FALSE

/obj/item/phone/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/structure/transmitter))
		attach_to(loc)

/obj/item/phone/Destroy()
	remove_attached()
	return ..()

/obj/item/phone/proc/handle_speak(var/mob/speaking, var/message, var/datum/language/L)
	SIGNAL_HANDLER

	if(!attached_to || loc == attached_to)
		UnregisterSignal(speaking, COMSIG_LIVING_SPEAK)
		return

	attached_to.handle_speak(message, L, speaking)

/obj/item/phone/proc/handle_hear(var/message, var/datum/language/L, var/mob/speaking)
	if(!attached_to)
		return

	var/obj/structure/transmitter/T = attached_to.get_calling_phone()

	if(!T)
		return

	if(!ismob(loc))
		return

	var/loudness = 0
	if(raised)
		loudness = 3

	var/mob/M = loc
	var/vname = T.phone_id

	if(M == speaking)
		vname = attached_to.phone_id

	M.hear_radio(
		message, "says", L, part_a = "<span class='purple'><span class='name'>",
		part_b = "</span><span class='message'> ", vname = vname,
		speaker = speaking, command = loudness, no_paygrade = TRUE)

/obj/item/phone/proc/attach_to(var/obj/structure/transmitter/to_attach)
	if(!istype(to_attach))
		return

	remove_attached()

	attached_to = to_attach


/obj/item/phone/proc/remove_attached()
	attached_to = null
	reset_tether()

/obj/item/phone/proc/reset_tether()
	if (tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		if(!QDESTROYING(tether_effect))
			qdel(tether_effect)
		tether_effect = null
	on_beam_removed()

/obj/item/phone/attack_hand(mob/user)
	if(attached_to && get_dist(user, attached_to) > attached_to.range)
		return FALSE
	return ..()


/obj/item/phone/proc/on_beam_removed()
	if(!attached_to)
		return

	if(loc == attached_to)
		return

	if(get_dist(attached_to, src) > attached_to.range)
		attached_to.recall_phone()

	var/atom/tether_to = src

	if(loc != get_turf(src))
		tether_to = loc
		if(tether_to.loc != get_turf(tether_to))
			attached_to.recall_phone()
			return

	var/atom/tether_from = attached_to

	if(attached_to.tether_holder)
		tether_from = attached_to.tether_holder

	if(tether_from == tether_to)
		return

	var/list/tether_effects = apply_tether(tether_from, tether_to, range = attached_to.range, icon = "wire", always_face = FALSE)
	tether_effect = tether_effects["tetherer_tether"]
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, .proc/reset_tether)

/obj/item/phone/attack_self(mob/user)
	if(raised)
		set_raised(FALSE, user)
		to_chat(user, SPAN_NOTICE("You lower [src]."))
	else
		set_raised(TRUE, user)
		to_chat(user, SPAN_NOTICE("You raise [src] to your ear."))


/obj/item/phone/proc/set_raised(var/to_raise, var/mob/living/carbon/human/H)
	if(!istype(H))
		return

	if(!to_raise)
		raised = FALSE
		item_state = "rpb_phone"

		var/obj/item/device/radio/R = H.wear_ear
		if(istype(R))
			R.on = TRUE
	else
		raised = TRUE
		item_state = "rpb_phone_ear"

		var/obj/item/device/radio/R = H.wear_ear
		if(istype(R))
			R.on = TRUE

	H.update_inv_r_hand()
	H.update_inv_l_hand()

/obj/item/phone/dropped(var/mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_LIVING_SPEAK)

	set_raised(FALSE, user)

/obj/item/phone/on_enter_storage(obj/item/storage/S)
	. = ..()
	if(attached_to)
		attached_to.recall_phone()

/obj/item/phone/pickup(mob/user)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SPEAK, .proc/handle_speak)

/obj/item/phone/forceMove(atom/dest)
	. = ..()
	if(.)
		reset_tether()
