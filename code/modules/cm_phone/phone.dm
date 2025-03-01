GLOBAL_LIST_EMPTY_TYPED(transmitters, /obj/structure/transmitter)

/obj/structure/transmitter
	name = "telephone receiver"
	icon = 'icons/obj/structures/phone.dmi'
	icon_state = "wall_phone"
	desc = "It is a wall mounted telephone. The fine text reads: To log your details with the mainframe please insert your keycard into the slot below. Unfortunately the slot is jammed. You can still use the phone, however."

	var/phone_category = "Uncategorised"
	var/phone_color = "white"
	var/phone_id = "Telephone"
	var/phone_icon

	var/obj/item/phone/attached_to
	var/atom/tether_holder

	var/obj/structure/transmitter/outbound_call
	var/obj/structure/transmitter/inbound_call

	var/next_ring = 0

	var/phone_type = /obj/item/phone

	var/range = 7

	var/enabled = TRUE
	/// Whether or not the phone is receiving calls or not. Varies between on/off or forcibly on/off.
	var/do_not_disturb = PHONE_DND_OFF
	/// The Phone_ID of the last person to call this telephone.
	var/last_caller

	var/base_icon_state

	var/timeout_timer_id
	var/timeout_duration = 30 SECONDS

	var/list/networks_receive = list(FACTION_MARINE)
	var/list/networks_transmit = list(FACTION_MARINE)

	var/datum/looping_sound/telephone/busy/busy_loop
	var/datum/looping_sound/telephone/hangup/hangup_loop
	var/datum/looping_sound/telephone/ring/outring_loop

/obj/structure/transmitter/hidden
	do_not_disturb = PHONE_DND_FORCED

/obj/structure/transmitter/Initialize(mapload, ...)
	. = ..()
	base_icon_state = icon_state

	attached_to = new phone_type(src)
	RegisterSignal(attached_to, COMSIG_PARENT_PREQDELETED, PROC_REF(override_delete))
	update_icon()

	outring_loop = new(attached_to)
	busy_loop = new(attached_to)
	hangup_loop = new(attached_to)

	if(!get_turf(src))
		return

	GLOB.transmitters += src

/obj/structure/transmitter/update_icon()
	. = ..()
	SEND_SIGNAL(src, COMSIG_TRANSMITTER_UPDATE_ICON)
	if(attached_to.loc != src)
		icon_state = "[base_icon_state]_ear"
		return

	if(inbound_call)
		icon_state = "[base_icon_state]_ring"
	else
		icon_state = base_icon_state

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

/obj/structure/transmitter/proc/get_transmitters()
	var/list/phone_list = list()

	for(var/possible_phone in GLOB.transmitters)
		var/obj/structure/transmitter/target_phone = possible_phone
		var/current_dnd = FALSE
		switch(target_phone.do_not_disturb)
			if(PHONE_DND_ON, PHONE_DND_FORCED)
				current_dnd = TRUE
		if(TRANSMITTER_UNAVAILABLE(target_phone) || current_dnd) // Phone not available
			continue
		var/net_link = FALSE
		for(var/network in networks_transmit)
			if(network in target_phone.networks_receive)
				net_link = TRUE
				continue
		if(!net_link)
			continue

		var/id = target_phone.phone_id
		var/num_id = 1
		while(id in phone_list)
			id = "[target_phone.phone_id] [num_id]"
			num_id++

		target_phone.phone_id = id
		phone_list[id] = target_phone

	return phone_list

/obj/structure/transmitter/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(TRANSMITTER_UNAVAILABLE(src))
		return UI_CLOSE

/obj/structure/transmitter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(TRANSMITTER_UNAVAILABLE(src))
		return

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	switch(action)
		if("call_phone")
			call_phone(user, params["phone_id"])
			. = TRUE
			SStgui.close_uis(src)
		if("toggle_dnd")
			toggle_dnd(user)

	update_icon()

/obj/structure/transmitter/ui_data(mob/user)
	var/list/data = list()

	data["availability"] = do_not_disturb
	data["last_caller"] = last_caller

	return data

/obj/structure/transmitter/ui_static_data(mob/user)
	. = list()

	.["available_transmitters"] = get_transmitters() - list(phone_id)
	var/list/transmitters = list()
	for(var/i in GLOB.transmitters)
		var/obj/structure/transmitter/T = i
		transmitters += list(list(
			"phone_category" = T.phone_category,
			"phone_color" = T.phone_color,
			"phone_id" = T.phone_id,
			"phone_icon" = T.phone_icon
		))

	.["transmitters"] = transmitters

/obj/structure/transmitter/proc/call_phone(mob/living/carbon/human/user, calling_phone_id)
	var/list/transmitters = get_transmitters()
	transmitters -= phone_id

	if(!length(transmitters) || !(calling_phone_id in transmitters))
		to_chat(user, SPAN_PURPLE("[icon2html(src, user)] No transmitters could be located to call!"))
		return

	var/obj/structure/transmitter/T = transmitters[calling_phone_id]
	if(!istype(T) || QDELETED(T))
		transmitters -= T
		CRASH("Qdelled/improper atom inside transmitters list! (istype returned: [istype(T)], QDELETED returned: [QDELETED(T)])")

	if(TRANSMITTER_UNAVAILABLE(T))
		return

	outbound_call = T
	outbound_call.inbound_call = src
	T.last_caller = src.phone_id
	T.update_icon()

	to_chat(user, SPAN_PURPLE("[icon2html(src, user)] Dialing [calling_phone_id].."))
	playsound(get_turf(user), "rtb_handset")
	timeout_timer_id = addtimer(CALLBACK(src, PROC_REF(reset_call), TRUE), timeout_duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
	outring_loop.start()

	START_PROCESSING(SSobj, src)
	START_PROCESSING(SSobj, T)

	user.put_in_hands(attached_to)

/obj/structure/transmitter/proc/toggle_dnd(mob/living/carbon/human/user)
	switch(do_not_disturb)
		if(PHONE_DND_ON)
			do_not_disturb = PHONE_DND_OFF
			to_chat(user, SPAN_NOTICE("Do Not Disturb has been disabled. You can now receive calls."))
		if(PHONE_DND_OFF)
			do_not_disturb = PHONE_DND_ON
			to_chat(user, SPAN_WARNING("Do Not Disturb has been enabled. No calls will be received."))
		else
			return FALSE
	return TRUE

/obj/structure/transmitter/attack_hand(mob/user)
	. = ..()

	if(!attached_to || attached_to.loc != src)
		return

	if(!ishuman(user))
		return

	if(!enabled)
		return

	if(!get_calling_phone())
		tgui_interact(user)
		return

	var/obj/structure/transmitter/T = get_calling_phone()

	if(T.attached_to && ismob(T.attached_to.loc))
		var/mob/M = T.attached_to.loc
		to_chat(M, SPAN_PURPLE("[icon2html(src, M)] [phone_id] has picked up."))
		playsound(T.attached_to.loc, 'sound/machines/telephone/remote_pickup.ogg', 20)
		if(T.timeout_timer_id)
			deltimer(T.timeout_timer_id)
			T.timeout_timer_id = null

	to_chat(user, SPAN_PURPLE("[icon2html(src, user)] Picked up a call from [T.phone_id]."))
	playsound(get_turf(user), "rtb_handset")

	T.outring_loop.stop()
	user.put_in_active_hand(attached_to)
	update_icon()


#undef TRANSMITTER_UNAVAILABLE

/obj/structure/transmitter/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PhoneMenu", phone_id)
		ui.open()

/obj/structure/transmitter/proc/set_tether_holder(atom/A)
	tether_holder = A

	if(attached_to)
		attached_to.reset_tether()

/obj/structure/transmitter/proc/reset_call(timeout = FALSE)
	var/obj/structure/transmitter/T = get_calling_phone()
	if(T)
		if(T.attached_to && ismob(T.attached_to.loc))
			var/mob/M = T.attached_to.loc
			to_chat(M, SPAN_PURPLE("[icon2html(src, M)] [phone_id] has hung up on you."))
			T.hangup_loop.start()

		if(attached_to && ismob(attached_to.loc))
			var/mob/M = attached_to.loc
			if(timeout)
				to_chat(M, SPAN_PURPLE("[icon2html(src, M)] Your call to [T.phone_id] has reached voicemail, nobody picked up the phone."))
				busy_loop.start()
				outring_loop.stop()
			else
				to_chat(M, SPAN_PURPLE("[icon2html(src, M)] You have hung up on [T.phone_id]."))

	if(outbound_call)
		outbound_call.inbound_call = null
		outbound_call = null

	if(inbound_call)
		inbound_call.outbound_call = null
		inbound_call = null

	if(timeout_timer_id)
		deltimer(timeout_timer_id)
		timeout_timer_id = null

	if(T)
		if(T.timeout_timer_id)
			deltimer(T.timeout_timer_id)
			T.timeout_timer_id = null

		T.update_icon()
		STOP_PROCESSING(SSobj, T)

	outring_loop.stop()

	STOP_PROCESSING(SSobj, src)

/obj/structure/transmitter/process()
	if(inbound_call)
		if(!attached_to)
			STOP_PROCESSING(SSobj, src)
			return

		if(attached_to.loc == src)
			if(next_ring < world.time)
				playsound(loc, 'sound/machines/telephone/telephone_ring.ogg', 75)
				visible_message(SPAN_WARNING("[src] rings vigorously!"))
				next_ring = world.time + 3 SECONDS

	else if(outbound_call)
		var/obj/structure/transmitter/T = get_calling_phone()
		if(!T)
			STOP_PROCESSING(SSobj, src)
			return

		var/obj/item/phone/P = T.attached_to

		if(P && attached_to.loc == src && P.loc == T && next_ring < world.time)
			playsound(get_turf(attached_to), 'sound/machines/telephone/telephone_ring.ogg', 20, FALSE, 14)
			visible_message(SPAN_WARNING("[src] rings vigorously!"))
			next_ring = world.time + 3 SECONDS

	else
		STOP_PROCESSING(SSobj, src)
		return


/obj/structure/transmitter/proc/recall_phone()
	if(ismob(attached_to.loc))
		var/mob/M = attached_to.loc
		M.drop_held_item(attached_to)
		playsound(get_turf(M), "rtb_handset", 100, FALSE, 7)
		hangup_loop.stop()

	attached_to.forceMove(src)
	reset_call()
	busy_loop.stop()
	outring_loop.stop()

	update_icon()

/obj/structure/transmitter/proc/get_calling_phone()
	if(outbound_call)
		return outbound_call
	else if(inbound_call)
		return inbound_call

	return

/obj/structure/transmitter/proc/handle_speak(message, datum/language/L, mob/speaking)
	if(L.flags & SIGNLANG)
		return

	var/obj/structure/transmitter/T = get_calling_phone()
	if(!istype(T))
		return

	var/obj/item/phone/P = T.attached_to

	if(!P || !attached_to)
		return

	P.handle_hear(message, L, speaking)
	attached_to.handle_hear(message, L, speaking)
	playsound(P, "talk_phone", 5)
	log_say("TELEPHONE: [key_name(speaking)] on Phone '[phone_id]' to '[T.phone_id]' said '[message]'")

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
	SStgui.close_uis(src)

	reset_call()
	return ..()

/obj/item/phone
	name = "telephone"
	icon = 'icons/obj/structures/phone.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi'
	)
	icon_state = "rpb_phone"

	w_class = SIZE_LARGE

	var/obj/structure/transmitter/attached_to
	var/datum/effects/tethering/tether_effect

	var/raised = FALSE
	var/zlevel_transfer = FALSE
	var/zlevel_transfer_timer = TIMER_ID_NULL
	var/zlevel_transfer_timeout = 5 SECONDS

/obj/item/phone/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/structure/transmitter))
		attach_to(loc)

/obj/item/phone/Destroy()
	remove_attached()
	return ..()

/obj/item/phone/proc/handle_speak(mob/speaking, message, datum/language/L)
	SIGNAL_HANDLER

	if(!attached_to || loc == attached_to)
		UnregisterSignal(speaking, COMSIG_LIVING_SPEAK)
		return

	attached_to.handle_speak(message, L, speaking)

/obj/item/phone/proc/handle_hear(message, datum/language/L, mob/speaking)
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

/obj/item/phone/proc/attach_to(obj/structure/transmitter/to_attach)
	if(!istype(to_attach))
		return

	remove_attached()

	attached_to = to_attach


/obj/item/phone/proc/remove_attached()
	attached_to = null
	reset_tether()

/obj/item/phone/proc/reset_tether()
	SIGNAL_HANDLER
	if (tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		if(!QDESTROYING(tether_effect))
			qdel(tether_effect)
		tether_effect = null
	if(!do_zlevel_check())
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
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, PROC_REF(reset_tether))

/obj/item/phone/attack_self(mob/user)
	..()
	if(raised)
		set_raised(FALSE, user)
		to_chat(user, SPAN_NOTICE("You lower [src]."))
	else
		set_raised(TRUE, user)
		to_chat(user, SPAN_NOTICE("You raise [src] to your ear."))


/obj/item/phone/proc/set_raised(to_raise, mob/living/carbon/human/H)
	if(!istype(H))
		return

	if(!to_raise)
		raised = FALSE
		item_state = "rpb_phone"

		var/obj/item/device/radio/R = H.get_type_in_ears(/obj/item/device/radio)
		R?.on = TRUE
	else
		raised = TRUE
		item_state = "rpb_phone_ear"

		var/obj/item/device/radio/R = H.get_type_in_ears(/obj/item/device/radio)
		R?.on = FALSE

	H.update_inv_r_hand()
	H.update_inv_l_hand()

/obj/item/phone/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_LIVING_SPEAK)

	set_raised(FALSE, user)

/obj/item/phone/on_enter_storage(obj/item/storage/S)
	. = ..()
	if(attached_to)
		attached_to.recall_phone()

/obj/item/phone/pickup(mob/user)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SPEAK, PROC_REF(handle_speak))

/obj/item/phone/forceMove(atom/dest)
	. = ..()
	if(.)
		reset_tether()

/obj/item/phone/proc/do_zlevel_check()
	if(!attached_to || !loc.z || !attached_to.z)
		return FALSE

	if(zlevel_transfer)
		if(loc.z == attached_to.z)
			zlevel_transfer = FALSE
			if(zlevel_transfer_timer)
				deltimer(zlevel_transfer_timer)
			UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
			return FALSE
		return TRUE

	if(attached_to && loc.z != attached_to.z)
		zlevel_transfer = TRUE
		zlevel_transfer_timer = addtimer(CALLBACK(src, PROC_REF(try_doing_tether)), zlevel_transfer_timeout, TIMER_UNIQUE|TIMER_STOPPABLE)
		RegisterSignal(attached_to, COMSIG_MOVABLE_MOVED, PROC_REF(transmitter_move_handler))
		return TRUE
	return FALSE

/obj/item/phone/proc/transmitter_move_handler(datum/source)
	SIGNAL_HANDLER
	zlevel_transfer = FALSE
	if(zlevel_transfer_timer)
		deltimer(zlevel_transfer_timer)
	UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
	reset_tether()

/obj/item/phone/proc/try_doing_tether()
	zlevel_transfer_timer = TIMER_ID_NULL
	zlevel_transfer = FALSE
	UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
	reset_tether()

/obj/structure/transmitter/no_dnd
	do_not_disturb = PHONE_DND_FORBIDDEN

//rotary desk phones (need a touch tone handset at some point)
/obj/structure/transmitter/rotary
	name = "rotary telephone"
	icon_state = "rotary_phone"
	desc = "The finger plate is a little stiff."

/obj/structure/transmitter/rotary/no_dnd
	do_not_disturb = PHONE_DND_FORBIDDEN

/obj/structure/transmitter/rotary/fax_responder
	phone_category = "Comms Relay"
	networks_receive = list("Fax Responders")
	pixel_x = -6
	pixel_y = 6

/obj/structure/transmitter/touchtone
	name = "touch-tone telephone"
	icon_state = "rotary_phone"//placeholder
	desc = "Ancient aliens, it's all true. I'm an expert just like you!"

/obj/structure/transmitter/colony_net
	networks_receive = list(FACTION_COLONIST)
	networks_transmit = list(FACTION_COLONIST)

/obj/structure/transmitter/colony_net/rotary
	name = "rotary telephone"
	icon_state = "rotary_phone"
	desc = "The finger plate is a little stiff."

/obj/structure/transmitter/upp_net
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)

/obj/structure/transmitter/upp_net/rotary
	name = "rotary telephone"
	icon_state = "rotary_phone"
	desc = "The finger plate is a little stiff."

/obj/structure/transmitter/clf_net
	networks_receive = list(FACTION_CLF)
	networks_transmit = list(FACTION_CLF)

/obj/structure/transmitter/clf_net/rotary
	name = "rotary telephone"
	icon_state = "rotary_phone"
	desc = "The finger plate is a little stiff."

/obj/structure/transmitter/wy_net
	networks_receive = list(FACTION_WY)
	networks_transmit = list(FACTION_WY)

/obj/structure/transmitter/wy_net/rotary
	name = "rotary telephone"
	icon_state = "rotary_phone"
	desc = "The finger plate is a little stiff."
